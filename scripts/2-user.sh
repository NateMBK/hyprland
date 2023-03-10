#!/usr/bin/env bash
# @file User
# @brief User customizations and AUR package installation.

cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ~/yay
makepkg -si --noconfirm
rm -fr /home/$USERNAME/yay
sed -n 's/^\s*#.*//; /^[[:space:]]*$/d; p' ~/ArchSetup/pkg-files/aur-pkgs.txt | while read line
do
    yay -S --noconfirm --needed "${line}"
done

echo -ne "_____________________________________________

Starting 3-post-setup

_____________________________________________"
exit