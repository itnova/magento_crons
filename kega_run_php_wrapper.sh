#!/bin/bash

# USAGE: 'kega_run_php_wrapper.sh <filename>.php'
# Checks if php file is given as parameter, if this is given then checks if the dynamic host file exists.
# this script will run the 'kega_run_php_aws.sh' script, remotely on the first webserver.

# 4 parameters are used:
# DYNAMIC_HOST_FILE: Location of the ansible dynamic host file, this file requests AWS information.
# FIRST_HOST_IP:  all the EC2 instances in the VPC are requested, and the first webserver is selected.
# USERNAME: username is used which is entered as a CloudFormation parameter when creating the stack.
# This script can only be executed on the bastion host.
# CRONSCRIPTPASS: will pass the php script to the remote environment.

# Execute requirements: package 'jq' needs to be installed.


if [ ! "$1" = "" ] ; then
    DYNAMIC_HOST_FILE=/etc/ansible/ec2.py
    if [ -f $DYNAMIC_HOST_FILE ]; then
        FIRST_HOST_IP=$(${DYNAMIC_HOST_FILE} --list | jq -r '.tag_Role_Webserver[0]')
        USERNAME=$(sed -n -e 's/^login_name=//p' /etc/hsl.def)
        ssh ${USERNAME}@${FIRST_HOST_IP} CRONSCRIPTPASS=$1 'bash -s' < kega_run_php_aws.sh
    else
      echo "$DYNAMIC_HOST_FILE does not exist"
   fi
else
    echo 'Add php script to run as parameter'
    exit;
fi

