#!/bin/sh

sudo pacman -S tlp acpi_call # acpi_call only on thinkpads (for really old thinkpads consider tp_smapi)
systemctl enable tlp.service
systemctl enable tlp-sleep.service
systemctl mask systemd-rfkill.service
systemctl mask systemd-rfkill.socket

# grafik drivers

# touchpad
sudo pacman -S libinput
# put the following in /etc/X11/xorg.conf.d/30-touchpad.conf
# --> include /etc/X11/xorg.conf.d/... in configuration
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "NaturalScrolling" "on"
    Option "HorizontalScrolling" "on"
    Option "DisableWhileTyping" "on"
EndSection


# fingerprint reader

# media buttons?
