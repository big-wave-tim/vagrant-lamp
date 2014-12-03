#!/usr/bin/env bash
#
###############################################################
# Set some variables passed from the Vagrant file
###############################################################
VAGRANT_MACHINE_HOST_NAME=$1
VAGRANT_PRIVATE_NETWORK_IP_ADDRESS=$2
#
USE_CACHED_DEBS=$3
INSTALL_NODEJS=$4
INSTALL_RUBY=$5
#
#
#
###############################################################
# Start bootsrapping
###############################################################
HIGHLIGHT='\e[42m'
TIME=$(date)
#
echo -e "${HIGHLIGHT}  START TIME =  $TIME"
START_TIME=`date +%s`
echo -e "${HIGHLIGHT}  VAGRANT_MACHINE_HOST_NAME=$VAGRANT_MACHINE_HOST_NAME "
echo -e "${HIGHLIGHT}  VAGRANT_PRIVATE_NETWORK_IP_ADDRESS=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS "
echo -e "${HIGHLIGHT}  USE_CACHED_DEBS=$USE_CACHED_DEBS "
echo -e "${HIGHLIGHT}  INSTALL_NODEJS=$INSTALL_NODEJS "
echo -e "${HIGHLIGHT}  INSTALL_RUBY=$INSTALL_RUBY "
#
#
###############################################################
# un-tar cached dbs to save downloading (will not be latest debs)
###############################################################
if [[ "$USE_CACHED_DEBS"  == "true" ]]
then
echo -e "${HIGHLIGHT}  un taring cached deb files to /var/cache/apt/archives "
sudo tar -xvf /vagrant/cached.deb.tar -C /var/cache/apt/archives
fi
#
#
###############################################################
# update package list and fetch utils for installing other things
###############################################################
echo -e "${HIGHLIGHT}  update package list and fetch utils for installing other things "
#sudo apt-get update 
sudo apt-get install -y build-essential git 
#
#
###############################################################
# Apache2 - Install and configure
###############################################################
echo -e "${HIGHLIGHT}  Apache2 - Install and configure "
sudo apt-get install -y apache2  apache2-utils 
echo "ServerName" $VAGRANT_MACHINE_HOST_NAME | sudo tee /etc/apache2/conf-available/servername.conf
sudo a2enconf servername
sudo a2enmod rewrite
sudo service apache2 restart
#
#
###############################################################
# MySql - Install and configure
###############################################################
echo -e "${HIGHLIGHT}  MySql - Install and configure "
# Set MySQL root password
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get install -y  mysql-server 
#
#
###############################################################
# PHP5 - Install and configure
###############################################################
echo -e "${HIGHLIGHT}  PHP5 - Install and configure "
sudo apt-get -y install php5 libapache2-mod-php5 php5-mysql  php5-mcrypt 
sudo php5enmod mcrypt
sudo sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
sudo sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL' /etc/php5/apache2/php.ini
#
#
###############################################################
# phpMyAdmin Install and configure
###############################################################
echo -e "${HIGHLIGHT}  phpMyAdmin Install and configure "
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-user string root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
sudo debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
sudo apt-get -y install phpmyadmin 
#
#
###############################################################
# Install Nodejs if has been specified in Vagrant file
###############################################################
if [[ "$INSTALL_NODEJS" == "true" ]]
then
echo -e "${HIGHLIGHT}  Nodejs Install and configure "  
curl https://raw.githubusercontent.com/creationix/nvm/v0.18.0/install.sh | bash
source ~/.nvm/nvm.sh
nvm install stable
nvm use stable
npm install npm -g
echo "nvm use stable" >> ~/.bashrc
fi
#
#
###############################################################
# Ruby Install and configure
###############################################################
if [[ "$INSTALL_RUBY" == "true" ]]
then
echo -e "${HIGHLIGHT}  Ruby Install and configure "  
## install rvm (Ruby Version Manager)
gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
# install latest stable ruby using rvm 
rvm use --install ruby
# set the default version of ruby to be this
rvm use ruby --default
#
#
###############################################################
# mailcatcher - Install and configure
###############################################################
echo -e "${HIGHLIGHT}  mailcatcher - Install and configure "
#gem install mailcatcher --no-ri --no-rdoc
rvm default@mailcatcher --create do gem install mailcatcher --no-ri --no-rdoc
rvm wrapper default@mailcatcher --no-prefix mailcatcher catchmail
CATCHMAIL=$(command -v catchmail)
MAILCATCHER=$(command -v mailcatcher)
sudo sed -i '/;sendmail_path =/c sendmail_path = "'$CATCHMAIL' -f catchmail@mailcatcher.me"' /etc/php5/apache2/php.ini
sudo sed -i '/;sendmail_path =/c sendmail_path = "'$CATCHMAIL' -f catchmail@mailcatcher.me"' /etc/php5/cli/php.ini
sudo service apache2 restart
mailcatcher --http-ip=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
echo "@reboot vagrant $MAILCATCHER --http-ip=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS" | sudo tee -a /etc/crontab
fi
#
#
###############################################################
# create some initial files for info/reference
###############################################################
echo '<?php phpinfo(); ?>' > /var/www/html/phpinfo.php
sed -e "s;%VAGRANT_MACHINE_HOST_NAME%;$VAGRANT_MACHINE_HOST_NAME;g"  /vagrant/index.html > /var/www/html/index.html
#
#gem install foundation --no-ri --no-rdoc
#gem install compass --no-ri --no-rdoc
#npm install -g bower grunt-cli yo
#
###############################################################
# add nice prompt to the shell
###############################################################
cat >> ~/.bashrc <<"EOF"
black="\[\033[30m\]"
red="\[\033[31m\]"
green="\[\033[32m\]"
yellow="\[\033[33m\]"
dk_blue="\[\033[34m\]"
pink="\[\033[35m\]"
lt_blue="\[\033[36m\]"
bold="\[\033[1m\]"
reset="\[\033[0m\]"
PS1='\[\033]0;\@ \u@\h - ${PWD//[^[:ascii:]]/?}\007\]' # set window title
PS1="$PS1\n$bold$black[$lt_blue\@$black] - "
PS1="$PS1[$green\u$yellow@$green\h$black] - "
PS1="$PS1[$pink\w$black]"
PS1="$PS1$reset\n$reset\$ "
EOF
###############################################################
# Display time script finished
###############################################################
TIME=$(date)
echo -e "${HIGHLIGHT}  END TIME =  $TIME"
END_TIME=`date +%s`
echo -e "${HIGHLIGHT}  Provisioning took " `expr $END_TIME - $START_TIME` "seconds "
