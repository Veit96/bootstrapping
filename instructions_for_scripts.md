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

## install base system


```bash
# get scripts
pacman -S git
git clone https://github.com/Veit96/dotfiles.git dotfiles

# launch first script
# choose mirror
./script_install1.sh

# configure fstab, the options should be like this (for SSD):
root: rw,defaults,noatime,discard	0 1
home: rw,defaults,noatime,discard  0 2
boot: rw,noatime,fmask=0022,dmask=0022,codepage=437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro	0 2
swap: defaults,noatime,discard,pri=-2   0 0

# change root to new system
arch-chroot /mnt/

# launch second script
# choose hostname, default "arch"
# in /etc/locale.gen uncomment all en_US, de_CH, de_DE
./script_install2.sh
```


## exit chroot and boot into new system

```bash
exit
umount -R /mnt
reboot
# login as root
```

# launch third script:
./script_install3.sh


# CUSTOMIZE SYSTEM

## install packages

```bash
pacman -S $(< my_packages.txt)
localectl set-x11-keymap ch pc105 de_nodeadkeys caps:swapescape
pacman -S xorg-drivers
zsh
chsh -l
chsh -s /bin/zsh
pacman -S libinput
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
- popcorntime-bin
- arch-silence-grub-theme


## install configs

```bash
pacman -S git
mkdir .dotfiles
git clone https://github.com/Veit96/dotfiles.git .dotfiles
cd .dotfiles
./install
````


## install lightdm greeter (login/display manager)

```bash
systemctl enable lightdm.service
```

```bash
/etc/lightdm/lightdm.conf
[Seat:*]
...
greeter-session=lightdm-webkit2-greeter
...
display-setup-script=xrandr --output DP-0 --rotate left --pos 0x0 --output DP-2 --primary --pos 1440x530
#or
display-setup-script=xrandr --output DP-2 --primary
...
```

```bash
/etc/lightdm/lightdm-webkit2-greeter.conf
...
webkit-theme = litarvan
...
```

# LAPTOP/NOTEBOOK SPECIFIC

```bash
pacman -S xf86-input-synaptics
```


# DESKTOP SPECIFIC
install nvidia drivers:
nvidia, nvidia-settings

put the following in /etc/X11/xorg.conf.d/20-nvidia.conf
Section "Device"
        Identifier "Nvidia Card"
        Driver "nvidia"
        VendorName "NVIDIA Corporation"
        BoardName "GeForce GTX 780"
        Option "Coolbits" "28"
EndSection

# DUAL BOOTING WITH WINDOWS

## setting windows to UTC instead of localtime:
windows key + r, regedit
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

## pacman stuff:
uncomment "#Color" for color pacman
add aur

## vim stuff:
- vim-jedi
- vim-jellybeans
- vim-latexsuite
- vim-spell-de
- vim-supertab


## have a look at tlp


## pywal:
`wal -i image.png`


## Fixing Invalid MIT-MAGIC-COOKIE-1:
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

- connect to ethernet:

```bash
sudo systemctl enable dhcpcd@enp3s0.service

sudo systemctl enable netctl-auto@wlo1.service

sudo systemctl stop/disable netctl/NetworkManager/...
```

- this app handles monitor setup

`mons`

- stuff

i3lock-blur replaced i3lock as a screenlocker

wicd
connman
wpa_supplicant_gui

- search disk an list memory usage

`ncdu -x`

- list packages sorted by size

`expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel | sort)) | sort -n`

- remove orphant packages

`sudo pacman -Rns $(pacman -Qtdq)`


- check for errors

`sudo systemctl --failed
sudo journalctl -p 3 -xb`

- wifi settings with nmcli

`nmcli radio wifi on/off
nmcli con
nmcli dev`



