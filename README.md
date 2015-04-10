# Vagrant LAMP Machine  
## Otionally installs Ruby and/or Nodejs
**For developing websites and applications that use the LAMP stack. This machine includes**

* [Ubuntu 14.04 Trusty Tahr](https://vagrantcloud.com/ubuntu/boxes/trusty64) - ubuntu/trusty64 box
* Apache 2.4
* MySQL 5.5
* PHP 5.5
* phpMyAdmin
* Nodejs via nvm (Node Version Manager)  - (optional)
* Ruby via rvm (Ruby Version Manager)  - (optional)
* Mailcatcher  - (only if Ruby is installed)


##Vagrant Configuration
Has some defines to configure for each project, such as
* VAGRANT_MACHINE_NAME = "vagrant-machine-name" // Name used in virtualbox
* VAGRANT_MACHINE_HOST_NAME = "vagrant"
* VAGRANT_PRIVATE_NETWORK_IP_ADDRESS = "192.168.10.10"
* Add VAGRANT_MACHINE_HOST_NAME to the host machines hosts file with a value equal to that of VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
* INSTALL_NODEJS = (true/false) install or not
* INSTALL_RUBY = (true/false) install or not (will also install mailcatcher if true)


##MySQL
* Username = "root"
* Password = "root"
* phpMyAdmin = http://VAGRANT_MACHINE_HOST_NAME/phpmyadmin


##Mailcatcher
* Mailcatcher can been seen at http://VAGRANT_MACHINE_HOST_NAME:1080/
* catcher has been added to the php.ini files sendmail_path directives

##NodeJS
If you chose to install NodeJS
* Yeoman, Bower, Grunt & Gulp are installed globally - and you add anything else globally without needing to sudo
* Yeoman has the basic web app and Zurb Foundation 5 generators installed - you can add more if you like
* Vagrant with VirtualBox on Windows has issues with long path names found in node_modules folders. To get around this symlink (ln) your node_modules folder to a location that is not shared between the host & guest e.g. ln -s ~/node_modules_for_project_x node_modules

##TODO/IDEAS
* Option to run apt-get upgrade during provisioning
* Add more options to optionally install more components e.g. apache, mysql etc
* scripts to install popular CMSs
* Offline cache for popular add-ons such as jQuery, Bootstrap, Font Awesome etc.
* [Webmin](http://www.webmin.com/)
* A way to store the VirtualBox machine in the same folder as the rest of the project
