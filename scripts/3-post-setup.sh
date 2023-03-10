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

systemctl enable sddm.service
echo [Theme] >> /etc/sddm.conf
echo Current=Dexy >> /etc/sddm.conf
# Set default lightdm-webkit2-greeter theme to Litarvan
sed -i 's/^webkit_theme\s*=.*/webkit_theme = litarvan/' /etc/lightdm/lightdm-webkit2-greeter.conf
# Set default lightdm greeter to lightdm-webkit2-greeter
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/' /etc/lightdm/lightdm.conf
sudo pacman -S --noconfirm --needed lightdm lightdm-gtk-greeter
systemctl enable lightdm.service

systemctl enable cups.service
ntpd -qg
systemctl enable ntpd.service
systemctl disable dhcpcd.service
systemctl stop dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable bluetooth
systemctl enable avahi-daemon.service
systemctl enable libvirtd.service

SNAPPER_CONF="$HOME/ArchSetup/configs/etc/snapper/configs/root"
mkdir -p /etc/snapper/configs/
cp -rfv "${SNAPPER_CONF}" /etc/snapper/configs/
SNAPPER_CONF_D="$HOME/ArchSetup/configs/etc/conf.d/snapper"
mkdir -p /etc/conf.d/
cp -rfv "${SNAPPER_CONF_D}" /etc/conf.d/

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

rm -r $HOME/ArchSetup
rm -r /home/$USERNAME/ArchSetup

# Replace in the same state
cd $pwd