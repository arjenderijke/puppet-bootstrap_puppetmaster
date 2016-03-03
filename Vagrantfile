Vagrant.configure(2) do |config|
  config.vm.box = "fedora22"
  #config.vm.provision "puppet"

  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 1024
    libvirt.storage_pool_name = "vagrant"
  end
end
