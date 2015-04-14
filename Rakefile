require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

desc "Validate manifests, templates, and ruby files"
task :validate do
  Dir['manifests/**/*.pp'].each do |manifest|
    sh "puppet parser validate --noop #{manifest}"
  end
  Dir['spec/**/*.rb','lib/**/*.rb'].each do |ruby_file|
    sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
  end
  Dir['templates/**/*.erb'].each do |template|
    sh "erb -P -x -T '-' #{template} | ruby -c"
  end
end

task :default => [:pre, :modules, :force]

desc "Validate prerequisits"
task :pre do
  sh "yum list installed puppet"
end

desc "install puppet modules"
task :modules do
  ['puppetlabs-apache',
   'puppetlabs-mcollective',
   'puppetlabs-firewall',
   'puppetlabs-stdlib',
   'jpopelka-firewalld',
   'puppetlabs-postgresql',
   'puppetlabs-puppetdb',
   'herculesteam-augeasproviders_ssh',
   'petems-swap_file',
   'puppetlabs-java_ks',
   'puppetlabs-activemq',
   'thias-samba'
  ].each do |puppet_module|
    sh "puppet module install -i /usr/share/puppet/modules #{puppet_module}"
  end
end

desc "Force puppet run"
task :force do
  sh "puppet apply -t -e \"notify { 'puppet' : message => 'puppet' } \" "
end
