# install packages
sed '/^[[:blank:]]*$/d' my_packages.md | grep -v "^#" | sudo pacman --noconfirm --needed -S -

git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# changing default shell to zsh
# zsh
# chsh -l
chsh -s /bin/zsh
