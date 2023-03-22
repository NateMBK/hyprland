#!/bin/bash
# @file ArchSetup
# @brief Entrance script that launches children scripts for each phase of installation.

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
    ( bash $SCRIPT_DIR/scripts/startup.sh )
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )
    ( arch-chroot /mnt $HOME/ArchSetup/scripts/1-setup.sh )
    ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/ArchSetup/scripts/2-user.sh )
    ( arch-chroot /mnt $HOME/ArchSetup/scripts/3-post-setup.sh )
clear

echo -ne "
Install Complete!"
sleep 1
echo -ne "
Rebooting in 3"
sleep 1
echo -ne "
Rebooting in 2"
sleep 1
echo -ne "
Rebooting in 1"
sleep 1
reboot