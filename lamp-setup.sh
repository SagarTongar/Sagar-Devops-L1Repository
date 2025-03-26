#!/bin/bash

#Script for Installing LAMP-Stack.

#Variable Declaration for Database

WEB_DIR="/var/www/html"
DB_NAME="test_tb"
DB_USER="Haptik"
DB_PASS="Haptik@2025"

# Installing dependencies and updating Linux Packages
echo "Updating system and installing required packages..."
sudo apt-get update
sudo apt install -y apache2 php libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip wget unzip mysql-server

#Enable and start Apache

echo "Starting and enabling Apache..."
sudo systemctl enable --now apache2

#Secure MySQL installation (Non-interactive)

echo "Securing MySQL..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASS'; FLUSH PRIVILEGES;"

#Create MySQL database and user

echo "Creating MySQL database and user for WordPress..."
sudo mysql -u root -e "
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED WITH caching_sha2_password BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;"


#Downloading the wordpress from internet

echo "Downloading WordPress..."
cd $WEB_DIR
sudo wget -q https://wordpress.org/latest.tar.gz
sudo tar -xzf latest.tar.gz
sudo rm -rf latest.tar.gz
sudo chown -R www-data:www-data $WEB_DIR/wordpress
sudo chmod -R 755 $WEB_DIR/wordpress

#Configure wp-config.php

echo "Configuring WordPress..."
sudo cp $WEB_DIR/wordpress/wp-config-sample.php $WEB_DIR/wordpress/wp-config.php
sudo sed -i "s/database_name_here/$DB_NAME/" $WEB_DIR/wordpress/wp-config.php
sudo sed -i "s/username_here/$DB_USER/" $WEB_DIR/wordpress/wp-config.php
sudo sed -i "s/password_here/$DB_PASS/" $WEB_DIR/wordpress/wp-config.php

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart apache2

echo "MySQL Database Name: ${DB_NAME}"
echo "Wordpress App Has been Installed Successfully !"

#Changing Permissions for script
sudo chmod +x lamp_app.sh

#Run the Script
sudo ./lamp-setup.sh
