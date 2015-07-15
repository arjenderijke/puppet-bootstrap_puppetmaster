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

task :default => [:pre, :modules, :force, :step0]
task :step => [:build_pkg, :install_pkg, :step1, :step2]

desc "Validate prerequisits"
task :pre do
  ['ruby',
   'rubygem-rake',
   'puppet',
   'java-1.8.0-openjdk'
  ].each do |rpm_package|
    sh "yum -y install #{rpm_package}"
  end
  ['puppetlabs_spec_helper',
   'puppet-lint'
  ].each do |ruby_gem|
    sh "gem install #{ruby_gem}"
  end
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
  sh "puppet apply -t -e \"notify { 'puppet' : message => 'puppet' } \" " do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "puppet generate cert"
task :step0 do
  sh "puppet cert generate localhost.localdomain --dns_alt_names=localhost" do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "Add puppetlabs repositories"
task :step1 do
  sh "puppet apply --modulepath /usr/share/puppet/modules:/etc/puppet/modules -t -v -e \"include ::bootstrap_puppetmaster::yum\" " do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "build package"
task :build_pkg do
  sh "puppet module build #{Dir.pwd}" do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "install package"
task :install_pkg do
  sh "puppet module install -f #{Dir.pwd}/pkg/arjenderijke-bootstrap_puppetmaster-0.1.0.tar.gz " do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "Second puppet run"
task :step2 do
  sh "puppet apply --modulepath /usr/share/puppet/modules:/etc/puppet/modules -t -v -e \"include bootstrap_puppetmaster\" " do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "Install PuppetDB"
task :step3 do
  sh "puppet apply --modulepath /usr/share/puppet/modules:/etc/puppet/modules -t -v -e \"include ::bootstrap_puppetmaster::puppetdb\" " do
  |ok, status|
    puts "ok #{ok} status #{status.exitstatus}\n"
  end
end

desc "Workarounds for puppetdb"
task :workaround do
  sh "/usr/bin/wget http://yum.puppetlabs.com/fedora/f20/products/x86_64/puppetdb-2.3.5-1.fc20.noarch.rpm -O /tmp/puppetdb-2.3.5-1.fc20.noarch.rpm"
  sh "/usr/bin/rpm -i --nodeps /tmp/puppetdb-2.3.5-1.fc20.noarch.rpm"
  sh "/usr/bin/cp #{Dir.pwd}/files/puppetdb.service /usr/lib/systemd/system/puppetdb.service"
end
