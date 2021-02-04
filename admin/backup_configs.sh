#!/bin/bash
#
# Backup configs
#
# Utility script I use on my servers to backup the
# different config files located in /etc
#
# Copyright (c) 2020 Samantaz Fox
#
# Licensed under the "BSD 3 clauses" license.
# Refer to LICENSE.md for more details.
#


# Current date and time (one minute precision)
curr_date=$(date '+%Y-%m-%d')
curr_time=$(date '+%H-%M')
date_time=${curr_date}_${curr_time}

# Backup directory, absolute
all_backups_dir=/opt/backups
this_backup_dir=$all_backups_dir/$curr_date


# Some color codes for messages
red=$'\033[1;31m'
white=$'\033[1;37m'
dgrey=$'\033[1;30m'
green=$'\033[0;32m'
reset=$'\033[0m'



# Make a temporary directory, that will be used for the
# creation of .tar.gz archives
temp_dir=$(mktemp -d)
if ! test -d $temp_dir; then exit 2; fi


# Print configs
echo
echo "${dgrey}global backups dir: ${white}${all_backups_dir}${reset}"
echo "${dgrey}current backup dir: ${white}${this_backup_dir}${reset}"


# Create top dir if it doesn't exist yet
if ! test -d $all_backups_dir; then
	mkdir $all_backups_dir
	chmod go-rwx $all_backups_dir
fi

# Make subdir
if test -d $this_backup_dir
then
	# Load the time marker file
	last_backup=$(cat $this_backup_dir/.last_backup)

	if test "$last_backup" == "$time_date"
	then
		printf "\n${red}Error: A backup was made less than 1 minute ago${reset}\n\n"
		exit 1
	else
		# Update time marker
		echo $date_time > $this_backup_dir/.last_backup
	fi
else
	mkdir $this_backup_dir
	chmod go-rwx $this_backup_dir

	# Save backup time to detect multiple consecutive runs
	echo $date_time > $this_backup_dir/.last_backup
fi



#
# Some useful functions
#

function copy_to_temp()
{
	dest_dir=${temp_dir}/$1
	mkdir -p $dest_dir
	cp -r -t $dest_dir $1/*
}

function clean_temp()
{
	cd $temp_dir
	[ -z "$(ls --color=none)" ] || rm -r *
}


function targz()
{
	program_name=$1
	input_dir=$2
	excludes=$3

	if test -d "${temp_dir}${input_dir}"; then
		# Path relative to temp dir
		cd $temp_dir
		input=${input_dir#*/}

	elif test -d "$input_dir"; then
		# Absolute path
		cd /
		input=${input_dir#*/}
	else
		return 1
	fi

	backup_name=$(echo $program_name | tr '[:upper:]' '[:lower:]')
	output="${this_backup_dir}/${date_time}__${backup_name}.tar.gz"

	echo
	echo "Backing up ${red}${program_name}${reset}"
	echo "Backing up ${program_name}" | tr '[:alnum:] ' '--'
	echo "${dgrey}Source dir is: ${white}${input_dir}${reset}"
	echo "${dgrey}Output is: ${white}${output}${reset}"

	if test -z "${excludes}"; then
		tar -czf $output "$input" #> /dev/null 2>&1
		out=$?
	else
		echo "${dgrey}Excluding: ${white}${excludes}${reset}"
		tar --exclude="${excludes}" -czf $output "$input" #> /dev/null 2&>1
		out=$?
	fi

	if test $out -eq 0; then
		echo "${green}Done!${reset}"
	else
		echo "${red}Fail${reset}"
	fi
}



# Backup lighttpd config (without SSL private keys)
lighttpd_dir=/etc/lighttpd
targz "Lighttpd" $lighttpd_dir 'ssl/*.key'

# Backup SSH config (without keys)
ssh_dir=/etc/ssh
targz "SSH" $ssh_dir '*_host_*_key'

# Backup postgreSQL config
postgres_dir=/etc/postgresql
targz "postgreSQL" $postgres_dir

# Backup ufw firewall rules
ufw_dir=/etc/ufw
targz "ufw" $ufw_dir

# Backup Dovecot config (without private keys)
dovecot_dir=/etc/dovecot
targz "Dovecot" $dovecot_dir 'private/* ssl/*.key'


#
# Backup postfix config (without passwords)
#

postfix_dir=/etc/postfix

if test -d $postfix_dir; then
	# Remove passwords from some files
	copy_to_temp $postfix_dir
	sed -i -E 's/(password\s*=)\*.*/\1/' ${temp_dir}${postfix_dir}/pgsql/*
	clean_temp

	# Compress
	targz "Postfix" $postfix_dir
fi



# final new line and cleanup
clean_temp
rmdir $temp_dir
echo
