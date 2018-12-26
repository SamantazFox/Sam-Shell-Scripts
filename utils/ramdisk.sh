#!/bin/bash
#
# ramdisk.sh
#
# Insert description here
#
# Copyright 2018 (c) Samantaz
#


# Check if user is root
#
[[ $EUID -eq 0 ]] || { echo "This script needs root privileges"; exit; }


# Configuration
#
rd_dir="/mnt/ramdisk"
name="ramdisk"

lower=512
upper=8192


# Check if ramdisk has already been mounted/created
if [[ -e $rd_dir/.ramdisk_mounted ]]; then
	echo "Ramdisk already created and mounted!"

	# Ask for unmounting
	read -p "Do you want to unmount \"$name\" at $rd_dir? [y/N] " answer

	if [[ $answer == [yY]* ]]; then
		echo "Unmounting RAM disk"
		rm $rd_dir/.ramdisk_mounted
		umount $rd_dir
	fi

else
	# If ramdisk directory does not exist, create it
	if ! [[ -d $rd_dir ]]; then mkdir $rd_dir; fi

	# Ask user for the ramdisk's size
	read -p "Please enter a size (in MiB): " answer && echo;

	# Make basic boundaries checks before creating the disk
	if [[ $answer -ge 512 && $answer -lt 8192 ]]; then
		echo "Creating RAM disk \"$name\""
		echo " -> size = $answer MiB"
		echo " -> path = $rd_dir"

		mount -t tmpfs -o size=${answer}m $name $rd_dir
		touch $rd_dir/.ramdisk_mounted
	else
		echo "The ramdisk's size must be greater than $lower and lower than $upper."
	fi
fi
