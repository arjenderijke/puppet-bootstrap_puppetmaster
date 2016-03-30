#
# class: puppetmaster
#

class bootstrap_puppetmaster::puppetmaster (
  $hiera_environment = 'production',
  $puppet_server_hostname = $::fqdn,
  $ssl_dir = '/var/lib/puppet/ssl',
) {
  if ($puppet_server_hostname == 'localhost') {
    $puppet_server = 'localhost.localdomain'
  } else {
    $puppet_server = $puppet_server_hostname
  }

  class {'apache':
    default_mods => [ 'actions', 'auth_digest', 'authn_anon', 'access_compat',
                      'authn_dbm', 'authz_dbm', 'authz_owner', 'authz_user',
                      'expires', 'ext_filter', 'include', 'logio', 'speling',
                      'substitute', 'suexec', 'usertrack', 'version',
                      'setenvif', 'rewrite', 'mime', 'ssl',
                      'authn_core', 'authn_file', 'auth_basic',
                      'cgi', 'dir', 'autoindex'],
  }

  class { 'apache::mod::passenger': }

  $allowed_hosts = ['127.0.0.1', '192.168.121.0/24']

  class { 'apache::mod::proxy' :
    proxy_requests => 'On',
    allow_from     => $allowed_hosts,
  }

  if ($::operatingsystemrelease == '22') {
    Service {
      provider => 'systemd',
    }

    package {'puppet':
      ensure  => '3.8.1-1.fc20',
    }

    service {'puppet':
      ensure     => stopped,
      enable     => false,
      hasrestart => true,
      hasstatus  => true,
      require    => Package['puppet'],
    }

    package {'puppet-server':
      ensure  => '3.8.1-1.fc20',
      require => File['puppetconf'],
    }
  } else {
    package {'puppet':
      ensure  => installed,
    }

    package {'puppet-server':
      ensure  => installed,
      require => File['puppetconf'],
    }
  }

  service {'puppetmaster':
    ensure     => stopped,
    enable     => false,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['puppet-server'],
  }

  $osversion = $::operatingsystemrelease

  file { 'puppetconf':
    path    => '/etc/puppet/puppet.conf',
    content => template("${module_name}/puppet.conf.erb"),
    notify  => Class['apache'],
    require => File['eyaml_keys_dir'],
  }

  file { 'eyaml_keys_dir':
    ensure => 'directory',
    path   => '/etc/puppet/keys',
  }

  package {'hiera':
    ensure => installed,
  }

  package { ['deep_merge', 'puppet-lint', 'hiera-eyaml']:
    ensure   => installed,
    provider => 'gem',
  }

  file { '/var/lib/puppet/reports':
    ensure  => 'directory',
    owner   => puppet,
    group   => puppet,
    mode    => '0750',
    require => Package['puppet'],
  }

  file { "/var/lib/puppet/reports/${::fqdn}":
    ensure  => 'directory',
    owner   => puppet,
    group   => puppet,
    mode    => '0750',
    require => File['/var/lib/puppet/reports'],
  }

  file { '/usr/share/puppet/rack':
    ensure  => 'directory',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => Package['puppet-server'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd':
    ensure  => 'directory',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/usr/share/puppet/rack'],
  }

  file { '/usr/share/puppet/rack/puppetmasterd/public':
    ensure  => 'directory',
    owner   => root,
    group   => root,
    mode    => '0755',
    require => File['/usr/share/puppet/rack/puppetmasterd'],

  }

  file { '/usr/share/puppet/rack/puppetmasterd/tmp':
    ensure  => 'directory',
    owner   => apache,
    group   => apache,
    mode    => '0755',
    require => File['/usr/share/puppet/rack/puppetmasterd'],

  }

  file { '/usr/share/puppet/rack/puppetmasterd/config.ru':
    ensure  => present,
    owner   => puppet,
    group   => puppet,
    mode    => '0755',
    notify  => Class['apache'],
    content => template("${module_name}/config.ru.erb"),
    require => File['/usr/share/puppet/rack/puppetmasterd'],
  }

  apache::vhost { 'puppetmaster':
    servername           => $puppet_server,
    port                 => '8140',
    ssl                  => true,
    ssl_protocol         => 'ALL -SSLv2 -SSLv3',
    ssl_cipher           => 'EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA384:EECDH+aRSA+SHA256:EECDH:+CAMELLIA256:+AES256:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA256-SHA:AES256-SHA:CAMELLIA128-SHA:AES128-SHA',
    ssl_honorcipherorder => 'on',
    ssl_cert             => "${ssl_dir}/certs/${puppet_server}.pem",
    ssl_key              => "${ssl_dir}/private_keys/${puppet_server}.pem",
    ssl_chain            => "${ssl_dir}/ca/ca_crt.pem",
    ssl_ca               => "${ssl_dir}/ca/ca_crt.pem",
    ssl_certs_dir        => "${ssl_dir}/certs",
    ssl_verify_client    => 'optional',
    ssl_verify_depth     => '1',
    ssl_options          => ['+StdEnvVars', '+ExportCertData'],
    request_headers      => [ 'set X-SSL-Subject %{SSL_CLIENT_S_DN}e', 'set X-Client-DN %{SSL_CLIENT_S_DN}e', 'set X-Client-Verify %{SSL_CLIENT_VERIFY}e' ],
    docroot              => '/usr/share/puppet/rack/puppetmasterd/public',
    directories          => [
      { 'path'          => '/usr/share/puppet/rack/puppetmasterd/public',
        'Options'       => ['-MultiViews'],
        'AllowOverride' => 'All',
        'Require'       => 'all granted' } ],
    error_log_file       => "${puppet_server}_ssl_error.log",
    access_log_file      => "${puppet_server}_ssl_access.log",
    require              => File['/usr/share/puppet/rack/puppetmasterd/config.ru'],
  }
}
