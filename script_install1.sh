#!/bin/sh
# This script will setup the basic configurations

timedatectl set-ntp true

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
vim /etc/pacman.d/mirrorlist

pacstrap /mnt base base-devel intel-ucode networkmanager vim git

genfstab -Lp /mnt >> /mnt/etc/fstab

