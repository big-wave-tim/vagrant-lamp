# Vagrant LAMP machine
**For developing websites and applications that use the LAMP stack. This machine includes **

* [Ubuntu 14.04 Trusty Tahr](https://vagrantcloud.com/ubuntu/boxes/trusty64)
* Apache 2.4
* MySQL 5.5
* PHP 5.5
* phpMyAdmin
* Ruby via rvm (Ruby Version Manager)
* Nodejs via nvm (Node Version Manager)
* Mailcatcher


##MySQL
* Username = "root"
* Password = "root"
* phpMyAdmin = http://vagrant/phpmyadmin

##Mailcatcher
* Mailcatcher can been seen at http://vagrant:1080/
* catcher has been added to the php.ini files sendmail_path directives


##Vagrant File
Has some defines to configure for each project, such as
* VAGRANT_MACHINE_NAME = "vagrant-machine-name"
* VAGRANT_MACHINE_HOST_NAME = "vagrant"
* VAGRANT_PRIVATE_NETWORK_IP_ADDRESS = "192.168.10.10"
* I have added "vagrant" to the host machines hosts file with the value equal to that of VAGRANT_PRIVATE_NETWORK_IP_ADDRESS


##TODO
* scripts to install popular CMSs
* Webmin
* Off line cache for popular add-ons such as jQuery, Bootstrap, Font Awesome etc.
* [Webmin](http://www.webmin.com/)
* A way to store the VirtualBox machine in the same folder as the rest of the project
