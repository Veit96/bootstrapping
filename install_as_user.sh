# install packages
sed '/^[[:blank:]]*$/d' my_packages.md | grep -v "^#" | sudo pacman --needed -S -

# iso/ch keyboard settings (swapping escape and capslock)
localectl set-x11-keymap ch pc105 de_nodeadkeys caps:swapescape
# ansi/us keyboard
#localectl set-x11-keymap us pc104

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# changing default shell to zsh
# zsh
# chsh -l
chsh -s /bin/zsh
