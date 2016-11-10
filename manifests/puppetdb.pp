#
# class bootstrap_puppetmaster::puppetdb
#
class bootstrap_puppetmaster::puppetdb {
  if ($::operatingsystemrelease >= 22) {
    Service {
      provider => 'systemd',
    }
  } else {
    class { '::postgresql::globals':
      version => '9.3',
    }
  }

  class { '::postgresql::server':
    ip_mask_allow_all_users => '0.0.0.0/0',
    service_enable          => false,
  }

  class { '::puppetdb':
    manage_dbserver => false,
    confdir         => '/etc/puppetdb/conf.d',
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
