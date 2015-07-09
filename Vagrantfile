Vagrant.configure(2) do |config|
  config.vm.box = "fedora21"
  #config.vm.provision "puppet"

  config.vm.provider :libvirt do |libvirt|
    libvirt.storage_pool_name = "vagrant"
  end
end
