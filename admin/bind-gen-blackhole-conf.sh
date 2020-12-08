#!/bin/sh
#
# Script to generate the required bind configuration file
# in order to create a DNS blackhole, using StevenBlack's
# unified list of domains.
#
# Make sure to edit the sed script in the case where you
# want to save some domains, and also adapt paths to match
# your BIND installation.
#
# You may also want to host a HTTP server which will be
# as a fallback for those blocked domains, and explain to
# your user what hapenned. A single HTML page is enough.
#
# This script is in the public domain.
#


bind_config_dir=/etc/bind
bind_blackhole_db=${bind_config_dir}/db.dns-blackhole


print-header()
{
	local b='\033[1m'    # bold
	local g='\033[1;30m' # dark grey
	local r='\033[0;31m' # red
	local z='\033[0m'    # reset

	echo "${b}${g}------------------------------------------------------${z}"
	echo "${r}$@"
	echo "${b}${g}------------------------------------------------------${z}"
}


make-sed-file()
{
	cat > replace.sed << EOF
# Remove anything that is not "0.0.0.0 ..."
# Also remove "0.0.0.0 0.0.0.0"
/^(0\.0\.0\.0)/!d
/^(0\.0\.0\.0)\s(0\.0\.0\.0)/d

# Domains in the list we still want to access
# (Yeah, we all know that the "porn" list contains some of your favorite websites)
#/^0\.0\.0\.0\s(example.com)$/d

# format all other lines to have a valid bind zone file
s=^0\.0\.0\.0\s([A-Za-z0-9._\-]+).*$=zone "\1" {type master; file "${bind_blackhole_db}";};=
EOF

	# Sanity check, show the script
	cat replace.sed
}


make-bind-db()
{
	cat > ${bind_blackhole_db} << EOF
; DNS black-holing zone
;
; This zone will redirect all requests back to the blackhole server.
;
; Make sure to host a simple HTML file at the address defined below,
; in order to remind you that the site was blocked.
;

$TTL    86400   ; one day

@	IN	SOA	bhdns.lan. bhdns.lan. (
			           2020090301   ; Serial (yyyymmddnn)
			                28800   ; Refresh  8 hours
			                 7200   ; Retry    2 hours
			               864000   ; Expire  10 days
			                86400 ) ; Min ttl  1 day
		NS	<your DNS server IP here>

*	IN	A	<your HTTP server IP here>
EOF
}


#
# Download the "Unified hosts + fakenews + gambling + porn" list from StevenBlack
# More lists available here: https://github.com/StevenBlack/hosts
#
print-header "Download domains list"
wget "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts" -O hosts_raw.txt
echo


#
# Make sure that the source contains only 0.0.0.0 hosts remappings
# This is just a sanity check, the sed script will remove such lines anyway
#
print-header "Checking for funky lines"
sed -nE '/^(0\.0\.0\.0\s|\s*\#|$)/!p' hosts_raw.txt
echo


#
# Apply the sed script defined above
#
print-header "Replacing some entries"
make-sed-file
sed -E -f "replace.sed" hosts_raw.txt > tmp.txt
rm replace.sed
echo


#
# Generate the bind zone file
#
print-header "Generate the bind zone file"
make-bind-db
echo


#
# Split the formatted file into multiple files, so debugging is easier
# and BIND takes less time to load them
#
# Also print the config lines that have to be appended to named.conf
#
print-header "Generate bind config files"

[[ -d blackhole ]] || mkdir blackhole
cd blackhole
split -n l/8 -d --additional-suffix=.zone "../tmp.txt" blackhole
cd ..
rm tmp.txt

if ! [[ -d "${bind_config_dir}/blackhole/" ]]
then
	mv blackhole/ "${bind_config_dir}/blackhole/"
	chown -R root:bind blackhole/
else
	echo "Directory '${bind_config_dir}/blackhole/' already exists"
	echo "Can't move ./blackhole there"
then

echo
echo "Add the following lines at the end of your bind config file"
echo "(Usually /etc/bind/named.conf)"
echo

echo "// Blackhole zones definitions"
for $x in $(ls -1 blackhole/)
	do echo "include \"$x\";"
done
echo
