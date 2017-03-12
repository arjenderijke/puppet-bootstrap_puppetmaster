Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  $fixes = <<FIXES
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
FIXES

  $prepare = <<PREPARE
sed -i 's/localhost/localdomain/' /etc/resolv.conf
auditctl -e0
rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs
rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
yum -y install puppet-agent puppetserver
systemctl start puppetserver
/opt/puppetlabs/bin/puppet module install hunner-hiera
/opt/puppetlabs/bin/puppet module install puppetlabs-puppetdb
mkdir /etc/pupppetlabs/puppet/keys
/usr/bin/cp /vagrant/files/private_key.pkcs7.pem /etc/puppetlabs/puppet/keys/
/usr/bin/cp /vagrant/files/public_key.pkcs7.pem /etc/puppetlabs/puppet/keys/
/opt/puppetlabs/bin/puppet apply /vagrant/manifests/puppetserver.pp

PREPARE

  config.vm.provision "shell", inline: $fixes
  config.vm.provision :reload
  config.vm.provision "shell", inline: $prepare

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 4096
    libvirt.storage_pool_name = "vagrant"
  end
end
