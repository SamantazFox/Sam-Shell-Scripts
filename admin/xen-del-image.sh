#!/bin/sh
#
# Xen del-image
#
# Deletes a VM previously created with xen-new-image,
# along with all its assets (logs and config files)
#
# Copyright (c) 2021 Samantaz Fox
#
# Licensed under the "BSD 3 clauses" license.
# Refer to LICENSE.md for more details.
#


DNS_DOMAIN="example.com"
CFG_DIR="/srv/xen/configs"
LOG_DIR="/var/log/xen-tools"


usage()
{
	echo "Usage $1 <VM hostname>"
}

name=$(basename "$1" .${DNS_DOMAIN})
name=$(echo $name | sed -E 's/[^A-Za-z0-9\-]//g')

if [ -z $name ]; then usage "$0"; return 1; fi

full_name=${name}.${DNS_DOMAIN}

# Double check if user really wants that
printf "Do you want to delete '$full_name'? [y/N] "
read result
echo

case $result in
	y|Y) ;; # Continue
	*)   return 69;;
esac

# Stop VM
if ! [ -z $(xl vm-list | grep "$full_name") ]; then
	xl destroy "$full_name" || return 2
fi

# Remove disk image
xen-delete-image "$full_name" || return 3

# Delete logs
cfg_file=${CFG_DIR}/${full_name}.cfg
echo "Deleting: $cfg_file"
test -e "$cfg_file" && rm "$cfg_file"

# Delete config file
log_file=${LOG_DIR}/${full_name}.log
echo "Deleting: $log_file"
test -e "$log_file" && rm "$log_file"
