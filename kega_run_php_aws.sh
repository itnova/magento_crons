#!/bin/bash

# Note: This is a modifaction of the original "kega_run_php.sh" script.
# This script requires to be run by the "kega_run_php_wrapper.sh".
# The parameter required must be specified as parameter of the kega_run_php_wrapper.sh script.

# Checks if php file given as parameter is already running.
# - if not, start it.
# - if it's already running do nothing

if [ ! "$CRONSCRIPTPASS" = "" ] ; then
    CRONSCRIPT=$CRONSCRIPTPASS
else
    echo 'Add php script to run as parameter'
    exit;
fi

CUSTOMER=$(sed -n -e 's/^customer_name=//p' /etc/hsl.def)
PHP_BIN=`which php`
if ! ps auxwww | grep "$PHP_BIN $CRONSCRIPT" | grep -v grep  1>/dev/null 2>/dev/null ; then
    cd /var/www/vhosts/${CUSTOMER}/httpdocs/bin/cron && $PHP_BIN $CRONSCRIPT | grep -i 'Success\|Error' >> kega_crm_customer_sync.log &
else
    echo '"'$CRONSCRIPT'"' 'already running'
fi

