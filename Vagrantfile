# -*- mode: ruby -*-
# vi: set ft=ruby :

# Basic Vagrant development machine

# Based on Hashicorp Precise 64 installation, with a lean LAMP server installed on top. Specifically, this comes with Apache, MySQL, and PHP 5.5 installed, along with PHPMyAdmin.
# http://vagrant/
# http://vagrant/phpmyadmin Username = "root", Password = "root"
#

# Some basic configuraition definitions
VAGRANTFILE_API_VERSION = "2"
VAGRANT_MACHINE_NAME = "vagrant-machine-name"
VAGRANT_MACHINE_HOST_NAME = "vagrant"
VAGRANT_PRIVATE_NETWORK_IP_ADDRESS = "192.168.10.10"
INSTALL_NODE="false"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
    # Box to base machine on
    config.vm.box = "ubuntu/trusty64"
    
    # Networking
    config.vm.network :private_network, ip: VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
    
    # Synchronised folder
    config.vm.synced_folder "./html", "/var/www/html", owner: 'vagrant', group: 'www-data', mount_options: ['dmode=776', 'fmode=775']
      
    # Host name
    config.vm.hostname = VAGRANT_MACHINE_HOST_NAME
    
    # Set machine name for VirtualBox
    config.vm.provider :virtualbox do |v|
        v.name = VAGRANT_MACHINE_NAME;
    end
    
    
    
    config.vm.provision "shell", path: "bootstrap.sh", args: [VAGRANT_MACHINE_HOST_NAME, VAGRANT_PRIVATE_NETWORK_IP_ADDRESS, INSTALL_NODE],  privileged:false
    
end

