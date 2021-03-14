#!/bin/sh
#
# Git init new repository
#
# Inits a new bare repository, in a folder named
# after the owner (like github or gitlab) and with
# the required files for git web.
#
# Copyright (c) 2021 Samantaz Fox
#
# Licensed under the "BSD 3 clauses" license.
# Refer to LICENSE.md for more details.
#


usage()
{
	echo "Usage: $0 <User name> <Repository>";
	exit 0;
}


user=$1
owner=$(echo "$1" | sed -E 's/[^A-Za-z0-9_\-]//g')
repo=$(echo "$2" | sed -E 's/[^A-Za-z0-9\.\-]//g') # | tr 'A-Z' 'a-z')

if [ -z $user ]; then echo "Error: empty user name"; usage; fi
if [ -z $repo ]; then echo "Error: empty repo name"; usage; fi

echo "Creating repo '$user/$repo'"
cd /srv/git


# Create user dir if needed
[ -d $user ] || mkdir $user
cd $user

# Create repo directory, unless it already exists
full_name=$(basename $repo .git).git
[ -d $full_name ] && echo "Error: repo exists" && return 3
mkdir $full_name


# Initialize repo
cd $full_name
git init --bare


# Make it public
if test "$3" = "true" -o "$3" = "yes"
then
	touch "git-daemon-export-ok"
fi

# Prepare repo for being server over HTTP
git update-server-info
mv hooks/post-update.sample hooks/post-update


# Set proper owner name
printf "\n[gitweb]\n\towner = \"${owner}\"\n" >> config

# Give proper rights to git user
chown -R git:git .
