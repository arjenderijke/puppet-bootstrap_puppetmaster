#
# class bootstrap_puppetmaster::puppetdb
#
class bootstrap_puppetmaster::puppetdb (
  $postgresql_datadir = undef,
) {
  $manage_dbserver = !is_string($postgresql_datadir)
  $install_server = 'ciemaster.itf.cwi.nl'
  
  yumrepo { 'puppetlabs-products':
    descr    => "Puppet Labs Products Fedora ${::operatingsystemrelease} - ${::architecture}",
    baseurl  => "http://yum.puppetlabs.com/fedora/f${::operatingsystemrelease}/products/\$basearch",
    #baseurl  => "http://yum.puppetlabs.com/fedora/f20/products/\$basearch",
    enabled  => 1,
    gpgcheck => 0,
    priority => 99,
  }

  yumrepo { 'puppetlabs-deps':
    descr    => "Puppet Labs Dependencies Fedora ${::operatingsystemrelease} - \$basearch",
    baseurl  => "http://yum.puppetlabs.com/fedora/f${::operatingsystemrelease}/dependencies/\$basearch",
    #gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs"
    enabled  => 1,
    gpgcheck => 0,
    priority => 99,
  }

  yumrepo { 'puppetlabs-devel':
    descr    => "Puppet Labs Devel Fedora ${::operatingsystemrelease} - \$basearch",
    #baseurl  => "http://yum.puppetlabs.com/fedora/f${::operatingsystemrelease}/devel/\$basearch",
    baseurl  => "http://yum.puppetlabs.com/fedora/f20/devel/\$basearch",
    #gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs"
    enabled  => 1,
    gpgcheck => 0,
    priority => 99,
  }

  if ($manage_dbserver == false) {
    class { '::postgresql::globals':
      version => '9.3',
    }

    class { '::postgresql::server':
      ip_mask_allow_all_users => '0.0.0.0/0',
      #listen_addresses        => $listen_addresses,
      listen_addresses        => $::fqdn,
      datadir                 => $postgresql_datadir,
    }
  }

  class { '::puppetdb':
    listen_address   => $::fqdn,
    manage_dbserver  => $manage_dbserver,
    confdir          => '/etc/puppetdb/conf.d',
    require          => Yumrepo ['puppetlabs-products'],
  }

  class { '::puppetdb::master::config':
    terminus_package => 'puppetdb-terminus',
  }
}
