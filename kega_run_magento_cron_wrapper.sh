#!/bin/bash

# USAGE: 'kega_run_magento_cron_wrapper.sh'
# Checks if the dynamic host file exists.
# this script will run the 'kega_run_magento_cron.sh' script, remotely on the first webserver. 

# 3 parameters are used:
# DYNAMIC_HOST_FILE: Location of the ansible dynamic host file, this file requests AWS information.
# FIRST_HOST_IP:  all the EC2 instances in the VPC are requested, and the first webserver is selected.
# USERNAME: username is used which is entered as a CloudFormation parameter when creating the stack.
# This script can only be executed on the bastion host.

# Execute requirements: package 'jq' needs to be installed.


DYNAMIC_HOST_FILE=/etc/ansible/ec2.py
if [ -f $DYNAMIC_HOST_FILE ]; then
    FIRST_HOST_IP=$(${DYNAMIC_HOST_FILE} --list | jq -r '.tag_Role_Webserver[0]')
    USERNAME=$(sed -n -e 's/^login_name=//p' /etc/hsl.def)
    ssh ${USERNAME}@${FIRST_HOST_IP} 'bash -s' < kega_run_magento_cron.sh
else
    echo "$DYNAMIC_HOST_FILE does not exist"
fi

