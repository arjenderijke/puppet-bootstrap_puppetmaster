node 'localhost' {
  class { 'hiera':
    hierarchy => [
                  '%{environment}/%{calling_class}',
                  '%{environment}',
                  'common',
                  ],
    eyaml     => true,
  }

  # Configure puppetdb and its underlying database
  class { 'puppetdb':
    require => Class['hiera'],
  }
  # Configure the Puppet master to use puppetdb
  class { 'puppetdb::master::config': }
}
