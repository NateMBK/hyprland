#!/usr/bin/env bash
# @file User
# @brief User customizations and AUR package installation.

cd ~
git clone "https://aur.archlinux.org/yay.git"
cd ~/yay
makepkg -si --noconfirm
sed -n 's/^\s*#.*//; /^[[:space:]]*$/d; p' ~/ArchSetup/pkg-files/aur.txt | while read line
do
    yay -S --noconfirm --needed "${line}"
done

echo -ne "
_____________________

Starting 3-post-setup

_____________________
"
exit