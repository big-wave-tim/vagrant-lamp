# Vagrant LAMP machine
**For developing websites and applications that use the LAMP stack. This machine includes Ubuntu 14.04 Trusty Tahr, Apache, MySQL, PHP 5.5 and PHPMyAdmin**

* Uses the [avenuefactory/lamp](https://vagrantcloud.com/avenuefactory/boxes/lamp) Vagrant box
* The [avenuefactory/lamp](https://vagrantcloud.com/avenuefactory/boxes/lamp) Vagrant box is based on the [Hashicorp/Precise64](https://vagrantcloud.com/hashicorp/boxes/precise64) Vagrant box, with a lean LAMP server installed on top. Specifically, it comes with Apache, MySQL, PHP 5.5 and PHPMyAdmin installed.

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

##TODO
Some things I am considering to include in the future
* [MailCatcher](http://mailcatcher.me/)
* Git
* Vim
* [Webmin](http://www.webmin.com/)
* Off line cache for popular add-ons such as jQuery, Bootstrap, Font Awesome etc.
* A way to store the VirtualBox machine in the same folder as the Vagrant stuff
