Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"
  $fixes = <<FIXES
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
FIXES

  $prepare = <<PREPARE
sed -i 's/localhost/localdomain/' /etc/resolv.conf
auditctl -e0
yum -y install wget
PREPARE

  config.vm.provision "shell", inline: $fixes
  config.vm.provision :reload
  config.vm.provision "shell", inline: $prepare

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
    libvirt.storage_pool_name = "vagrant"
  end
end
