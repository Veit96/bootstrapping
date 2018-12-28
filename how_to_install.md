---
# YAML header with metadata
title:
- ARCH LINUX INSTALLATION AND CONFIGURATION
author:
- Veit Karpf
date:
- \today
highlight-style:
- pygments
numbersections: true
toc: true
geometry: margin=3.5cm
urlcolor: blue
header-includes: |
    \usepackage{fancyhdr}
    \pagestyle{fancy}
---

\maketitle
\pagebreak

# BASIC SYSTEM INSTALL

## Load keyboard

```bash
loadkeys de_CH-latin1
```

## set time

```bash
timedatectl status
timedatectl set-ntp true
```

## Disk partitioning and mounting
(gpt -> gdisk, mbr -> fdisk)

```bash
gdisk /dev/sdx
# code root: 8300
# code home: 8300
# code swap: 8200

(mkfs.fat -F 32 -n EFIBOOT /dev/sdx#)
mkfs.ext4 -L ARCH_ROOT /dev/sdx#
mkfs.ext4 -L ARCH_HOME /dev/sdx#
mkswap -L ARCH_SWAP /dev/sdx#

mount -L ARCH_ROOT /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount -L ARCH_HOME /mnt/home
mount -L ARCH_BOOT /mnt/boot
swapon -L ARCH_SWAP
```

## setup network connection (wifi-menu)

```bash
wifi-menu
```

## choose mirror

```bash
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
vim /etc/pacman.d/mirrorlist
```

## install base system

```bash
pacstrap /mnt base base-devel intel-ucode networkmanager vim

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt/

ln -sf /usr/share/zoneinfo/Europe/Zurich /etc/localtime
echo myhostname > /etc/hostname
vim /etc/locale.gen  # uncomment all en_US, de_CH, de_DE
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf  # (or: de_CH.UTF-8)
```

```bash
add the following to /etc/vconsole.conf
KEYMAP=sg-latin1
FONT=Lat2-Terminus16
Lang=en_US
```

```bash
vim /etc/hosts
#
# /etc/hosts: static lookup table for host names
#
#<ip-address>	<hostname.domain.org>	<hostname>
127.0.0.1	localhost.localdomain	localhost arch
::1		localhost.localdomain	localhost arch

mkinitcpio -p linux
passwd
````

## Install grub (boot loader)

```bash
pacman -S grub os-prober efibootmgr dosfstools gptfdisk

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck --debug
grub-mkconfig -o /boot/grub/grub.cfg
````


## exit chroot and boot into new system

```bash
exit
umount -R /mnt
reboot

useradd -m -g users -s /bin/bash user_name
passwd user_name

vim /etc/sudoers
%wheel ALL=(ALL) ALL

gpasswd -a user_name wheel

pacman -S acpid dbus avahi cronie
```


# CUSTOMIZE SYSTEM

## install configs

```bash
pacman -S git
mkdir .dotfiles
git clone https://github.com/Veit96/dotfiles.git .dotfiles
cd .dotfiles
./install
````

## install packages

```bash
pacman -S $(< my_packages.txt)
```

## install yay (aur helper)

```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```

## aur packages

- urxvt-resize-font-git
- polybar
- mons
- spotify
- popcorntime
- arch-silence-grub-theme

## switch capslock and escape:
`add "XkbOptions" "terminate:ctrl_alt_bksp,caps:swapescape" in /etc/X11/xorg.conf.d/00-keyboard.conf`

## install lightdm greeter

```bash
systemctl enable lightdm.service
```

```bash
/etc/lightdm/lightdm.conf
[Seat:*]
...
greeter-session=lightdm-webkit2-greeter
...
```

```bash
/etc/lightdm/lightdm-webkit2-greeter.conf
...
webkit-theme = litarvan
...
```


# DUAL BOOTING WITH WINDOWS

## setting windows to UTC instead of localtime:
`reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f`

## disable fast startup
1. go to windows power settings
2. go to additional settings
3. go to what power buttons do
4. uncheck fast startup

## Mount Windows partition on boot
Add the following to your /etc/fstab, where /dev/sdxy is the ntfs windows partition to be mounted:
`# /dev/sdxy UUID=...
LABEL=share		/home/veit/share	ntfs-3g		utf8,uid=1000,gid=1000,dmask=027,fmask=137  0 2`



# ADDITIONAL SETTINGS

### pacman stuff:
uncomment "#Color" for color pacman
add aur

### vim stuff:
- install vundle
- vim-jedi
- vim-jellybeans
- vim-latexsuite
- vim-spell-de
- vim-supertab

### have a look at tlp

### pywal:
`wal -i image.png`

### Fixing Invalid MIT-MAGIC-COOKIE-1:
This was needed to launch the graphical matlab installer from terminal with sudo privileges
uncomment `Defaults env_keep += “HOME”` in `/etc/sudoers`


# PROGRAMMS FOR CERTAIN TASKS

- display manager / login manager -> lightdm
- window manager -> i3
- shell -> zsh
- terminal -> rxvt-unicode
- app launcher -> rofi, dmenu
- aur helper -> yay
- file manager -> ranger
- browser -> qutebrowser
- wallpaper setter -> nitrogen, wal
- image viewer -> sxiv
- pdf viewer -> zathura, okular
- office ->
- video/audo player -> smplayer, mpv
- system monitoring -> deepin-system-monitor
- offline docs browser -> zeal
- firewall -> ufw
- BitTorrent client -> transmission
- Screenshot -> deepin-screenshot



# USEFULL COMMANDS

## connect to ethernet:

```bash
sudo systemctl enable dhcpcd@enp3s0.service

sudo systemctl enable netctl-auto@wlo1.service

sudo systemctl stop/disable netctl/NetworkManager/...
```

## this app handles monitor setup
`mons`


i3lock-blur replaced i3lock as a screenlocker

wicd
connman
wpa_supplicant_gui

## search disk an list memory usage
`ncdu -x`

## list packages sorted by size
`expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n`


## remove orphant packages
`sudo pacman -Rns $(pacman -Qtdq)`

## check for errors
`sudo systemctl --failed
sudo journalctl -p 3 -xb`

## wifi settings with nmcli
`nmcli radio wifi on/off
nmcli con
nmcli dev`



