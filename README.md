# Vagrant LAMP machine
Machine based on the [avenuefactory/lamp](https://vagrantcloud.com/avenuefactory/boxes/lamp) Vagrant box

* LAMP using Ubuntu, Apache, MySQL, PHP 5.5 with PHPMyAdmin
* Hashicorp Precise 64 installation, with a lean LAMP server installed on top. Specifically, this comes with Apache, MySQL, and PHP 5.5 installed, along with PHPMyAdmin.

##MySQL
* Username = "root"
* Password = "root"
* phpMyAdmin = http://vagrant/phpmyadmin

##Vagrant File
Has some defines to configure for each project, such as
* VAGRANT_MACHINE_NAME = "vagrant-machine-name"
* VAGRANT_MACHINE_HOST_NAME = "vagrant"
* VAGRANT_PRIVATE_NETWORK_IP_ADDRESS = "192.168.10.10"
* 
Have added "vagrant" to hosts file with value of VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
