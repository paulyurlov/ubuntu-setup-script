#!/bin/bash

user=$(whoami)
echo "Hi, $user!"

SCRIPTPATH="$(
  cd -- "$(dirname "$0")" >/dev/null 2>&1
  pwd -P
)"

# Update and upgrade
sudo apt update
sudo apt upgrade

# Remove snap-store and install gnome-software with flatpak

echo "Remove snap-store and install gnome-software with flatpak"
sudo snap remove --purge snap-store
sudo apt install flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Setup fish shell as default

echo "Setup fish shell as default"
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
chsh -s /usr/bin/fish

# Install roboto fonts
sudo apt install fonts-roboto

# Install oh-my-posh and theme

echo "Install oh-my-posh and theme"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
mkdir ~/.poshthemes
wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip -O ~/.poshthemes/themes.zip
unzip ~/.poshthemes/themes.zip -d ~/.poshthemes
chmod u+rw ~/.poshthemes/*.omp.*
rm ~/.poshthemes/themes.zip
oh-my-posh font install RobotoMono
sudo oh-my-posh font install RobotoMono
sudo cp -a ~/.local/share/fonts/robotomono-nerd-font-mono/. ~/.local/share/fonts/

# Prepare for theme installation
sudo apt install curl git unzip wget jq gnome-tweaks
flatpak install flathub org.gnome.Extensions

rm -f $SCRIPTPATH/install-gnome-extensions.sh
wget -N -q "https://raw.githubusercontent.com/cyfrost/install-gnome-extensions/master/install-gnome-extensions.sh" -O $SCRIPTPATH/install-gnome-extensions.sh && chmod +x $SCRIPTPATH/install-gnome-extensions.sh
bash $SCRIPTPATH/install-gnome-extensions.sh --enable --file $SCRIPTPATH/extensions.txt

# Clone Orchis theme for user shell
git clone https://github.com/vinceliuice/Orchis-theme.git $SCRIPTPATH/Orchis-theme

# Clone WhiteSur theme for main theme
git clone https://github.com/EliverLara/WhiteSur-gtk-theme.git $SCRIPTPATH/WhiteSur-gtk-theme

# Clone Vimix cursor theme
git clone https://github.com/vinceliuice/Vimix-cursors.git $SCRIPTPATH/Vimix-cursors

# Clone Reversal theme for icons
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git $SCRIPTPATH/Reversal-icon-theme

# Install Orchis theme

echo "Install Orchis theme"
bash $SCRIPTPATH/Orchis-theme/install.sh -t orange --tweaks compact

# Install WhiteSur theme

echo "Install WhiteSur theme"
bash $SCRIPTPATH/WhiteSur-gtk-theme/install.sh -t orange

# Connect WhiteSur theme to flatpak

echo "Connect WhiteSur theme to flatpak"
bash $SCRIPTPATH/WhiteSur-gtk-theme/tweak.sh -F

# Install Reversal theme

echo "Install Reversal theme"
bash $SCRIPTPATH/Reversal-icon-theme/install.sh -orange

# Install Vimix theme

echo "Install Vimix theme"
sudo bash $SCRIPTPATH/Vimix-cursors/install.sh

# Enable WhiteSur as main theme
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark-solid-orange"
gsettings set org.gnome.desktop.wm.preferences theme "WhiteSur-Dark-solid-orange"

# Enable Reversal as icon theme
gsettings set org.gnome.desktop.interface icon-theme "Reversal-orange-dark"

# Load dconf settings
dconf load / <$SCRIPTPATH/my-dconf-settings.ini

printf "\n\n"
# Install Anaconda
read -n 1 -p "Do uou want to install Anaconda (y/n)? " answer
printf "\n\n"
if [[ $answer == "y" ]]; then
  echo "Starting anaconda installation"
  printf "\n\n"
  wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
  sudo chmod +x Anaconda3-2022.10-Linux-x86_64.sh
  bash Anaconda3-2022.10-Linux-x86_64.sh
else
  echo "Skiping anaconda installation"
fi

# Install VS-code
sudo snap install code --classic

# Install Telegram
flatpak install flathub org.telegram.desktop

# Install Discord
flatpak install flathub com.discordapp.Discord

# Install Zoom
flatpak install flathub us.zoom.Zoom

# Install Steam
sudo apt install steam

# Install Termius
sudo snap install termius-app

# Install MarkText
flatpak install flathub com.github.marktext.marktext

# Install Synaptic
sudo apt install synaptic

# Install WPS office
flatpak install flathub com.wps.Office

# Install GitHub CLI
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
  sudo apt update &&
  sudo apt install gh -y

conda init fish
conda config --set auto_activate_base false
sudo apt autoremove
dconf load / <$SCRIPTPATH/my-dconf-settings.ini

# Reboot part
read -n 1 -p "Do uou want to reboot to apply settings (y/n)? " answer
printf "\n\n"
if [[ $answer == "y" ]]; then
  echo "Rebooting in 3 seconds"
  sudo reboot -f
else
  echo "No reboot"
fi
