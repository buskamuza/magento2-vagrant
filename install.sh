#!/usr/bin/env bash

set -ex

# Determine external IP address
set +x
IP=`ifconfig eth1 | grep inet | awk '{print $2}' | sed 's/addr://'`
echo "IP address is '${IP}'"
set -x

# Determine hostname for Magento web-site
HOST=`hostname -f`
if [ -z ${HOST} ]; then
    # Use external IP address as hostname
    set +x
    HOST=${IP}
    echo "Use IP address '${HOST}' as hostname"
    set -x
fi

magento_dir="/var/www/magento2"
cd ${magento_dir}
composer install

rm -rf ${magento_dir}/var/*

# Install Magento application
php -f setup/index.php install \
        --db_host=localhost \
        --db_name=magento \
        --db_user=magento \
        --db_pass=magento \
        --backend_frontname=admin \
        --base_url=http://${HOST}/ \
        --language=en_US \
        --timezone=America/Chicago \
        --currency=USD \
        --admin_lastname=Admin \
        --admin_firstname=Admin \
        --admin_email=admin@example.com \
        --admin_username=admin \
        --admin_password=iamtheadmin \
        --use_secure=0

# Deploy static view files for better performance
php -f dev/tools/Magento/Tools/View/deploy.php -- --verbose=0

set +x

echo "Installed Magento application in ${magento_dir}"
echo "Access front-end at http://${HOST}/"
echo "Access back-end at http://${HOST}/admin/"
