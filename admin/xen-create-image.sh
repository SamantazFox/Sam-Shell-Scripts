#!/bin/sh
#
# Xen create-image
#
# Semi-interactive wrapper for xen-create-image
# with automatic domain name assignation and
# pre-defined roles.
#
# Copyright (c) 2021 Samantaz Fox
#
# Licensed under the "BSD 3 clauses" license.
# Refer to LICENSE.md for more details.
#


DNS_HOSTNAME="example.com"


usage()
{
	echo "Usage $1 <vCPUs> <RAM> <VM hostname>"
}


cpus=$(echo $1 | sed -E 's/[^0-9]//g')
memy=$(echo $2 | sed -E 's/[^0-9MG]//g')
name=$(echo $3 | sed -E 's/[^A-Za-z0-9\-]//g')

if [ -z $cpus ]; then usage "$0"; return 1; fi
if [ -z $memy ]; then usage "$0"; return 2; fi
if [ -z $name ]; then usage "$0"; return 3; fi


variant=""

do_menu_distro()
{
	echo
	echo "1) Debian"
	echo "2) Ubuntu"
	echo
	echo "q) Exit"
	echo
	printf "> "

	read distro
	case $distro in
		1) do_menu_debian;;
		2) do_menu_ubuntu;;
		q) exit 0;;
		*) do_menu_distro;;
	esac
}

do_menu_debian()
{
	echo
	echo "0) < Back"
	echo
	echo "1) Jessie      (8)"
	echo "2) Bullseye    (9)"
	echo "3) Buster     (10)"
	echo "4) Sid  (unstable)"
	echo
	echo "q) Exit"
	echo
	printf "> "

	read id
	case $id in
		0) do_menu_distro;;
		1) variant="jessie";;
		2) variant="stretch";;
		3) variant="buster";;
		4) variant="sid";;
		q) exit 0;;
		*) do_menu_debian;;
	esac
}

do_menu_ubuntu()
{
	echo
	echo "0) < Back"
	echo
	echo "1) 14.04 - Trusty Tahr"
	echo "2) 16.04 - Xenial Xerus"
	echo "3) 17.10 - Artful Aardvark"
	echo "4) 18.04 - Bionic Beaver"
	echo "5) 18.10 - Cosmic Cuttlefish"
	echo "6) 19.04 - Disco Dingo"
	echo "7) 20.04 - Focal Fossa"
	echo
	echo "q) Exit"
	echo
	printf "> "

	read id
	case $id in
		0) do_menu_distro;;
		1) variant="trusty";;
		2) variant="xenial";;
		3) variant="artful";;
		4) variant="bionic";;
		5) variant="cosmic";;
		6) variant="disco";;
		7) variant="focal";;
		q) exit 0;;
		*) do_distro_ubuntu;;
	esac
}


do_menu_distro
if [ -z $variant ]; then echo "No variant selected (error)"; exit 3; fi

xen-create-image \
	--hostname $name.${DNS_HOSTNAME} \
	--memory=$memy --vcpus $cpus \
	--dist $variant --noverbose \
	--randommac --genpass=1 \
	--role=builder --role=resolv --role=tmpfs --role=editor
