#!/bin/sh

systemctl enable NetworkManager.service

echo "Enter username:"
user_name="veit"

useradd -m -g users -s /bin/bash $user_name
passwd $user_name

vim /etc/sudoers
%wheel ALL=(ALL) ALL

gpasswd -a $user_name wheel
#gpasswd -a $user_name audio

# add to audio,video,games,power too?

pacman --noconfirm --needed -S acpid dbus avahi cups cronie
systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable cronie
systemctl enable org.cups.cupsd.service
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
hwclock -w


