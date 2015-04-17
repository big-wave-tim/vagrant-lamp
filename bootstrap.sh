#!/usr/bin/env bash
#
###############################################################
#
# Set some variables passed from the Vagrant file
#
###############################################################
VAGRANT_MACHINE_HOST_NAME=$1
VAGRANT_MACHINE_NAME=$2
VAGRANT_PRIVATE_NETWORK_IP_ADDRESS=$3
INSTALL_NODEJS=$4
INSTALL_RUBY=$5
#
#
###############################################################
#
# Set some variables for timing
#
###############################################################
TIME=$(date)
START_TIME=`date +%s`
#
#
###############################################################
#
# Make some functions to output messagges and commands nicely
#
###############################################################
HIGHLIGHT='\e[42m'
HIGHLIGHTCOMMAND='\e[44m'
HIGHLIGHTRESET='\e[0m'
exe() { echo -e "${HIGHLIGHTCOMMAND}-- Running Command \$ $@${HIGHLIGHTRESET}" ; "$@" ; }
msg() { echo -e "${HIGHLIGHT}****    $@    ****${HIGHLIGHTRESET}";}
#
#
###############################################################
#
# Display a start message
#
###############################################################
msg "BOOTSTRAPPING VAGRANT LAMP MACHINE"
msg "START TIME =  $TIME"
msg "Configured options passed from Vagrantfile"
msg "VAGRANT_MACHINE_HOST_NAME=${VAGRANT_MACHINE_HOST_NAME}"
msg "VAGRANT_PRIVATE_NETWORK_IP_ADDRESS=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS"
msg "INSTALL_NODEJS=$INSTALL_NODEJS"
msg "INSTALL_RUBY=$INSTALL_RUBY"
#
#
###############################################################
#
# Begin bootstrapping the machine
#
###############################################################
#
#
###############################################################
#
# Update package list and fetch utils for installing other things
#
###############################################################
msg "Update package list and fetch utils for installing other things"
exe sudo apt-get update
exe sudo apt-get install -y build-essential git
#
#
###############################################################
#
# Apache2 - Install and configure
#
###############################################################
msg "Apache2 - Install and configure"
exe sudo apt-get install -y apache2  apache2-utils
exe eval 'echo "ServerName " $VAGRANT_MACHINE_HOST_NAME | sudo tee /etc/apache2/conf-available/servername.conf'
exe sudo a2enconf servername
exe sudo a2enmod rewrite
exe sudo service apache2 restart
#
#
###############################################################
#
# MySql - Install and configure
#
###############################################################
msg "MySql - Install and configure"
# Set MySQL root password
exe eval 'sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password root"'
exe eval 'sudo debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password root"'
exe sudo apt-get install -y  mysql-server
#
#
###############################################################
#
# PHP5 - Install and configure
#
###############################################################
msg "PHP5 - Install and configure"
exe sudo apt-get -y install php5 libapache2-mod-php5 php5-mysql  php5-mcrypt
exe sudo php5enmod mcrypt
exe sudo sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
exe sudo sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL' /etc/php5/apache2/php.ini
#
#
###############################################################
#
# phpMyAdmin - Install and configure
#
###############################################################
msg "phpMyAdmin Install and configure"
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"'
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"'
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-user string root"'
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password root"'
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password root"'
exe eval 'sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password root"'
exe sudo apt-get -y install phpmyadmin
#
#
###############################################################
#
# Nodejs - Install if it has been specified in Vagrant file
#
###############################################################
if [ "$INSTALL_NODEJS" == "true" ]; then
  msg "Nodejs Install and configure"
  # libfontconfig is needed for phantomJS that the yeoman webapp generator (and perhaps others) uses
  # libpng-dev, libjpeg-turbo-progs, gifsicle is maybe needed for grunt-contrib-imagemin
  # default-jre is needed for grunt-html that validates html locally using java
  exe sudo apt-get install -y libfontconfig default-jre
  exe eval 'curl -sL https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash'
  #source ~/.bashrc !! this doesn't work for some reason
  #two lines below are what gets added to .bashrc so added them here as source wouldn't work
  export NVM_DIR="/home/vagrant/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  msg "install latest stable nodejs"
  exe nvm install stable
  exe nvm use stable
  # update npm to latest
  msg "update npm to latest"
  exe npm install -g npm
  # use stable nodejs for next bash session
  exe eval 'echo "nvm use stable" >> ~/.bashrc'
  msg "install some basic nodejs modules globally"
  exe npm install -g yo bower grunt-cli gulp
  msg "install some yeoman generators"
  exe npm install -g generator-webapp generator-zf5
fi
#
#
###############################################################
#
# Ruby - Install if it has been specified in Vagrant file
#
###############################################################
if [ "$INSTALL_RUBY" == "true" ]; then
  msg "Ruby Install and configure"
  exe sudo apt-get -y install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
  exe gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  msg "Running Ruby install script from https://get.rvm.io"
  \curl -sSL https://get.rvm.io | bash -s stable
  exe source ~/.rvm/scripts/rvm
  exe rvm mount -r https://rvm.io/binaries/ubuntu/14.04/x86_64/ruby-2.2.1.tar.bz2
  exe rvm --default use ruby-2.2.1
  exe eval 'echo "gem: --no-ri --no-rdoc" > ~/.gemrc'
  exe gem install bundler rails sass
  #gem install foundation --no-ri --no-rdoc
  #gem install compass --no-ri --no-rdoc
  #
  #
  ###############################################################
  #
  # mailcatcher - Install and configure if Ruby was installed
  #
  ###############################################################
  msg "mailcatcher - Install and configure"
  exe rvm default@mailcatcher --create do gem install mailcatcher
  exe rvm wrapper default@mailcatcher --no-prefix mailcatcher catchmail
  CATCHMAIL=$(command -v catchmail)
  MAILCATCHER=$(command -v mailcatcher)
  msg "adding mailcatcher to php.ini"
  sudo sed -i '/;sendmail_path =/c sendmail_path = "'$CATCHMAIL' -f catchmail@mailcatcher.me"' /etc/php5/apache2/php.ini
  sudo sed -i '/;sendmail_path =/c sendmail_path = "'$CATCHMAIL' -f catchmail@mailcatcher.me"' /etc/php5/cli/php.ini
  exe sudo service apache2 restart
  exe mailcatcher --http-ip=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS
  echo "@reboot vagrant $MAILCATCHER --http-ip=$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS" | sudo tee -a /etc/crontab
fi
#
#
###############################################################
#
# Create some initial files for info/reference
#
###############################################################
msg "Create some initial files for info/reference"
exe eval 'echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php'
exe eval 'sed -e "s/%VAGRANT_MACHINE_HOST_NAME%/$VAGRANT_MACHINE_HOST_NAME/g" /vagrant/index.html > /var/www/html/index.html'
exe eval 'sed -i "s/%VAGRANT_PRIVATE_NETWORK_IP_ADDRESS%/$VAGRANT_PRIVATE_NETWORK_IP_ADDRESS/g" /var/www/html/index.html'
exe eval 'sed -i "s/%VAGRANT_MACHINE_HOST_NAME%/$VAGRANT_MACHINE_HOST_NAME/g" /var/www/html/index.html'
exe eval 'sed -i "s/%VAGRANT_MACHINE_NAME%/$VAGRANT_MACHINE_NAME/g" /var/www/html/index.html'
exe eval 'sed -i "s/%INSTALL_NODEJS%/$INSTALL_NODEJS/g" /var/www/html/index.html'
exe eval 'sed -i "s/%INSTALL_RUBY%/$INSTALL_RUBY/g" /var/www/html/index.html'
#
#
###############################################################
#
# Add nice prompt to the shell
#
###############################################################
msg "Adding a nice prompt to the shell"
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
PS1='\[\033]0;\t \u@\h - ${PWD//[^[:ascii:]]/?}\007\]' # set window title
PS1="$PS1\n$bold$black[$lt_blue\t$black] - "
PS1="$PS1[$green\u$yellow@$green\h$black] - "
PS1="$PS1[$pink\w$black]"
PS1="$PS1$reset\n$reset\$ "
EOF
###############################################################
#
# Tweeks, useful and cool things
#
###############################################################
echo alias ls='ls --color' >> ~/.bashrc
#
#
###############################################################
#
# Display time provisioning finished
#
###############################################################
msg "END TIME =  $TIME"
END_TIME=$(date '+%s')
TOTAL_TIME=$((END_TIME-START_TIME))
h=$(($TOTAL_TIME/3600))
m=$((($TOTAL_TIME/60)%60))
s=$(($TOTAL_TIME%60))
TOTAL_TIME=$(printf "%02d:%02d:%02d\n" $h $m $s)
msg "Provisioning took (hh:mm:ss) $TOTAL_TIME"
