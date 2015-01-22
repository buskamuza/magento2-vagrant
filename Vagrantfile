# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = 2048
  end
  config.vm.network :private_network, ip: '192.168.10.12'
  config.vm.hostname = "magento2.ce.dev"
  @magento2_path='../magento2'
  if Vagrant::Util::Platform.windows?
    config.vm.synced_folder @magento2_path, '/var/www/magento2', owner: "www-data", group: "www-data", type: "smb"
  else
    config.vm.synced_folder @magento2_path, '/var/www/magento2', owner: "www-data", group: "www-data", type: "nfs"
  end

  config.vm.provision "bootstrap", type: "shell", path: "bootstrap.sh"
  config.vm.provision "install", type: "shell", path: "install.sh"
end
