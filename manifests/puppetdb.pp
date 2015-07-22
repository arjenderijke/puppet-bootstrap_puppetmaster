#
# class bootstrap_puppetmaster::puppetdb
#
class bootstrap_puppetmaster::puppetdb (
  $postgresql_datadir = undef,
  $postgresql_password = undef,
) {
  $manage_dbserver = !is_string($postgresql_datadir)
  $install_server = 'ciemaster.itf.cwi.nl'
  
  if ($manage_dbserver == false) {
    class { '::postgresql::globals':
      version => '9.3',
    }

    class { '::postgresql::server':
      ip_mask_allow_all_users => '0.0.0.0/0',
      #listen_addresses        => $listen_addresses,
      listen_addresses        => $::fqdn,
      datadir                 => $postgresql_datadir,
      postgres_password       => $postgresql_password,
    }
  }

  class { '::puppetdb':
    listen_address   => $::fqdn,
    manage_dbserver  => $manage_dbserver,
    confdir          => '/etc/puppetdb/conf.d',
    #require          => Yumrepo ['puppetlabs-products'],
  }

  # According to the documentation this should work,
  # but it does not.
  #class { '::puppetdb::globals':
  #  version => '2.3.5-1.fc20',
  #}

  class { '::puppetdb::master::config':
    puppet_service_name => 'httpd',
    terminus_package    => 'puppetdb-terminus',
    test_url            => '/v3/version',
  }

  # The file /manifests/master/puppetdb_conf.pp does not
  # work as expected. This setting is a workaround for this.
  Ini_setting {
    ensure  => present,
    section => 'main',
    path    => '/etc/puppetdb/puppetdb.conf',
    setting => 'server',
    value   => $::fqdn,
    require => Class['puppetdb'],
  }
}
