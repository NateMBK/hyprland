#!/usr/bin/env bash
# @file Post-Setup
# @brief Finalizing installation configurations and cleaning up after script.

source ${HOME}/ArchSetup/configs/setup.conf

if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi

# set kernel parameter for adding splash screen
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& splash /' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

PLYMOUTH_THEMES_DIR="$HOME/ArchSetup/configs/usr/share/plymouth/themes"
PLYMOUTH_THEME="arch-glow" # can grab from config later if we allow selection
mkdir -p /usr/share/plymouth/themes
cp -rf "${PLYMOUTH_THEMES_DIR}/${PLYMOUTH_THEME}" /usr/share/plymouth/themes/
plymouth-set-default-theme ${PLYMOUTH_THEME}

cp -rf $HOME/ArchSetup/hyprland/dotconfig/* /home/$USERNAME/.config/
mkdir -p /home/$USERNAME/.wallpapers
cp -rf $HOME/ArchSetup/wallpaper.jpg /home/$USERNAME/.wallpapers/
echo 'export GTK_THEME=Materia-dark' | sudo tee -a /etc/profile
rm -rf /usr/share/icons/default/index.theme
touch /usr/share/icons/default/index.theme
echo [Icon Theme] >> /usr/share/icons/default/index.theme
echo Inherits=Oxygen_White >> /usr/share/icons/default/index.theme
echo [Theme] >> /etc/sddm.conf
echo Current=slice >> /etc/sddm.conf
cp -rf $HOME/ArchSetup/wallpaper.jpg /usr/share/sddm/themes/slice/
touch /usr/share/sddm/themes/slice/theme.conf.user
echo "[General]
font=Roboto
background=wallpaper.jpg
bg_mode=aspect
parallax_bg_shift=20
color_bg=#222222
color_main=#dddddd
color_dimmed=#888888
color_contrast=#1f1f1f
manual=false">> /usr/share/sddm/themes/slice/theme.conf.user
rm -rf /etc/locale.conf
touch /etc/locale.conf
echo "# This is the fallback locale configuration provided by systemd.

LANG=en_US.UTF-8">> /etc/locale.conf
systemctl enable sddm
systemctl enable libvirtd.service

PLYMOUTH_THEMES_DIR="$HOME/ArchSetup/configs/usr/share/plymouth/themes"
PLYMOUTH_THEME="arch-glow" # can grab from config later if we allow selection
mkdir -p /usr/share/plymouth/themes
cp -rf "${PLYMOUTH_THEMES_DIR}/${PLYMOUTH_THEME}" /usr/share/plymouth/themes/
plymouth-set-default-theme ${PLYMOUTH_THEME}

# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

rm -fr /root/ArchSetup
rm -fr /home/$USERNAME/ArchSetup
rm -fr home/$USERNAME/yay

# Replace in the same state
cd $pwd