#!/bin/bash

user=$(whoami)
echo "Hi, $user! Please enter your password on the next step =)"

# Update and upgrade
sudo apt update
sudo apt upgrade

# Remove snap-store and install gnome-software with flatpak
sudo snap remove --purge snap-store
sudo apt install flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Setup fish shell as default
sudo apt install fish
chsh -s /usr/bin/fish

# Prepare for theme installation
sudo apt install curl gnome-shell-extensions git unzip gnome-tweaks

# Clone Orchis theme for user shell
git clone https://github.com/vinceliuice/Orchis-theme.git

# Clone WhiteSur theme for main theme
git clone https://github.com/EliverLara/WhiteSur-gtk-theme.git

# Clone Vimix cursor theme
git clone https://github.com/vinceliuice/Vimix-cursors.git

# Clone Reversal theme for icons
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git

# Install Orchis theme
./Orchis-theme/install.sh -t orange --tweaks compact

# Install WhiteSur theme
./WhiteSur-gtk-theme/install.sh -t orange

# Connect WhiteSur theme to flatpak
./WhiteSur-gtk-theme/tweak.sh -F

# Install Reversal theme
./Reversal-icon-theme/install.sh -orange

# Install Vimix theme
cd Vimix-cursors
sudo ./install.sh
cd ~

# Enable WhiteSur as main theme
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark-solid-orange"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark-solid-orange"

# Enable Reversal as icon theme
gsettings set org.gnome.desktop.interface icon-theme "Reversal-orange-dark"

# Load dconf settings
dconf load / <my-dconf-settings.ini

# Install Conky
sudo apt install conky-all curl jq imagemagick

# Setup Conky Theme #f26d0a ff8c00
mkdir ~/.config/conky
cp -R Graffias_custom ~/.config/conky/
cp start_conky.desktop ~/.config/autostart/
cd ~/.config/conky/Graffias_custom/
chmod +x change-color.sh
./change-color.sh ff8c00
cd ~

# Clear installation files
rm -rf Orchis-theme
rm -rf WhiteSur-gtk-theme
rm -rf Reversal-icon-theme
rm -rf Vimix-cursors
rm -rf my-dconf-settings.ini

# Reboot part
read -n 1 -p "Do uou want to reboot to apply settings (y/n)? " answer
printf "\n\n"
if [[ $answer == "y" ]]; then
  echo "Rebooting in 3 seconds"
  sudo reboot -f
else
  echo "No reboot"
fi
