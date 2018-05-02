#!/bin/bash

# will fire the cron:run command and save output to a log file. 

CUSTOMER=$(sed -n -e 's/^customer_name=//p' /etc/hsl.def)
PHP_BIN=`which php`
#cd /var/www/vhosts/${CUSTOMER}/httpdocs/bin && $PHP_BIN magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/vhosts/${CUSTOMER}/httpdocs/var/log/magento.cron.log &
/usr/bin/php /var/www/vhosts/${CUSTOMER}/httpdocs/bin/magento cron:run | grep -v "Ran jobs by schedule" >> /var/www/vhosts/${CUSTOMER}/httpdocs/var/log/magento.cron.log &

