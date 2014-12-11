# Vagrant LAMP Virtual Machine (with Ruby and/or Nodejs optionally)
**For developing websites and applications that use the LAMP stack. This machine includes**

* [Ubuntu 14.04 Trusty Tahr](https://vagrantcloud.com/ubuntu/boxes/trusty64) - ubuntu/trusty64 box
* Apache 2.4
* MySQL 5.5
* PHP 5.5
* phpMyAdmin
* Ruby via rvm (Ruby Version Manager)  - (optional)
* Nodejs via nvm (Node Version Manager)  - (optional)
* Mailcatcher  - (only if Ruby is installed)


##Vagrant Configuration
Has some defines to configure for each project, such as
* VAGRANT_MACHINE_NAME = "vagrant-machine-name"
* VAGRANT_MACHINE_HOST_NAME = "vagrant"
* VAGRANT_PRIVATE_NETWORK_IP_ADDRESS = "192.168.10.10"
* Add VAGRANT_MACHINE_HOST_NAME to the host machines hosts file with a value equal to that of VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
* USE_CACHED_DEBS = (true/false) use chacehed deb files to so you dont need to download stuff for apache, MySql, PHP and phpMyadmin during provisioning
* INSTALL_NODEJS = (true/false) install or not
* INSTALL_RUBY = (true/false) install or not (will also install mailcather if true)


##MySQL
* Username = "root"
* Password = "root"
* phpMyAdmin = http://VAGRANT_MACHINE_HOST_NAME/phpmyadmin


##Mailcatcher
* Mailcatcher can been seen at http://VAGRANT_MACHINE_HOST_NAME:1080/
* catcher has been added to the php.ini files sendmail_path directives


##TODO/IDEAS
* scripts to install popular CMSs
* Off line cache for popular add-ons such as jQuery, Bootstrap, Font Awesome etc.
* [Webmin](http://www.webmin.com/)
* A way to store the VirtualBox machine in the same folder as the rest of the project
