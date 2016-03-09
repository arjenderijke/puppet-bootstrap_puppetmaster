Vagrant.configure(2) do |config|
  config.vm.box = "fedora22"
  $fixes = <<FIXES
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
FIXES

  $prepare = <<PREPARE
sed -i 's/localhost/localdomain/' /etc/resolv.conf
auditctl -e0
cp /tmp/puppetlabs.repo /etc/yum.repos.d/
dnf -y install rake puppet-3.8.1 wget
rm -rf /usr/share/ruby/vendor_ruby/puppet/vendor/safe_yaml
rm -rf /usr/share/ruby/vendor_ruby/puppet/vendor/safe_yaml_patches.rb
echo "require 'safe_yaml'" > /usr/share/ruby/vendor_ruby/puppet/vendor/require_vendored.rb
gem install puppetlabs_spec_helper safe_yaml
cd /vagrant
rake puppetmaster HOSTNAME=localhost.localdomain
PREPARE

  config.vm.provision "file", source: "files/puppetlabs.repo", destination: "/tmp/puppetlabs.repo"
  config.vm.provision "shell", inline: $fixes
  config.vm.provision :reload
  config.vm.provision "shell", inline: $prepare

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
    libvirt.storage_pool_name = "vagrant"
  end
end
