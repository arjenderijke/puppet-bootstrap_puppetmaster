package {['ruby', 'rubygem-rake']:
  ensure => installed,
}

package { ['puppetlabs_spec_helper', 'deep_merge', 'puppet-lint', 'hiera-eyaml']:
  ensure   => installed,
  provider => 'gem',
}
