#!/bin/sh

echo "Enter username:"
user_name="veit"

useradd -m -g users -s /bin/bash $user_name
passwd $user_name

vim /etc/sudoers
%wheel ALL=(ALL) ALL

gpasswd -a $user_name wheel
#gpasswd -a $user_name audio

# add to audio,video,games,power too?

pacman --noconfirm --needed -S acpid dbus avahi dbus cronie
systemctl enable acpid
systemctl enable avahi-daemon
systemctl enable cronie
systemctl enable org.cups.cupsd.service
systemctl enable systemd-timesyncd.service
systemctl start systemd-timesyncd.service
hwclock -w

# keyboard settings (swapping escape and capslock)
localectl set-x11-keymap ch pc105 de_nodeadkeys caps:swapescape