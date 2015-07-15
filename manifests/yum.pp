#
# class bootstrap_puppetmaster::yum
#
class bootstrap_puppetmaster::yum {
  yumrepo { 'puppetlabs-products':
    descr    => "Puppet Labs Products Fedora ${::operatingsystemrelease} - ${::architecture}",
    #baseurl  => "http://yum.puppetlabs.com/fedora/f${::operatingsystemrelease}/products/\$basearch",
    baseurl  => "http://yum.puppetlabs.com/fedora/f20/products/\$basearch",
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
    baseurl  => "http://yum.puppetlabs.com/fedora/f${::operatingsystemrelease}/devel/\$basearch",
    #gpgkey   => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppetlabs"
    enabled  => 1,
    gpgcheck => 0,
    priority => 99,
  }
}
