# install packages
sed '/^[[:blank:]]*$/d' my_packages.md | grep -v "^#" | sudo pacman --needed -S -

# keyboard settings (swapping escape and capslock)
localectl set-x11-keymap ch pc105 de_nodeadkeys caps:swapescape

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# changing default shell to zsh
# zsh
# chsh -l
chsh -s /bin/zsh
