#!/bin/sh
# after change root
# set by user:
myhostname="arch"


ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime

vim /etc/locale.gen

locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf

echo "KEYMAP=sg-latin1" >> /etc/vconsole.conf
echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf
echo "Lang=en_US" >> /etc/vconsole.conf

echo $myhostname > /etc/hostname

cat <<EOT >> /etc/hosts
#
# /etc/hosts: static lookup table for host names
#
#<ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	    localhost.localdomain	localhost $myhostname
::1		        localhost.localdomain	localhost $myhostname
EOT

mkinitcpio -p linux
passwd

pacman --noconfirm --needed -S grub os-prober efibootmgr dosfstools gptfdisk
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
