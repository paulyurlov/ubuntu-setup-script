#!/bin/bash

user=$(whoami)
echo "Hi, $user!"

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
cp my-posh-config.json ~/.config/fish/
echo "oh-my-posh init fish --config ~/.config/fish/my-posh-config.json | source" >~/.config/fish/config.fish
exec fish
oh-my-posh font install RobotoMono
sudo oh-my-posh font install RobotoMono
sudo cp ~/.local/share/fonts/robotomono-nerd-font-mono/Roboto\ Mono\ Nerd\ Font\ Complete\ Mono.ttf /usr/share/fonts/

# Prepare for theme installation
sudo apt install curl git unzip gnome-tweaks
flatpak install flathub org.gnome.Extensions

# Clone Orchis theme for user shell
git clone https://github.com/vinceliuice/Orchis-theme.git

# Clone WhiteSur theme for main theme
git clone https://github.com/EliverLara/WhiteSur-gtk-theme.git

# Clone Vimix cursor theme
git clone https://github.com/vinceliuice/Vimix-cursors.git

# Clone Reversal theme for icons
git clone https://github.com/yeyushengfan258/Reversal-icon-theme.git

# Install Orchis theme

echo "Install Orchis theme"
./Orchis-theme/install.sh -t orange --tweaks compact

# Install WhiteSur theme

echo "Install WhiteSur theme"
./WhiteSur-gtk-theme/install.sh -t orange

# Connect WhiteSur theme to flatpak

echo "Connect WhiteSur theme to flatpak"
./WhiteSur-gtk-theme/tweak.sh -F

# Install Reversal theme

echo "Install Reversal theme"
./Reversal-icon-theme/install.sh -orange

# Install Vimix theme

echo "Install Vimix theme"
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
echo "Setup conky"
sudo apt install conky-all curl jq imagemagick python3-pip
pip install geocoder yaweather geopy

# Setup Conky Theme #f26d0a ff8c00
mkdir ~/.config/conky
cp -R Graffias ~/.config/conky/
cp start_conky.desktop ~/.config/autostart/
cd ~/.config/conky/Graffias/
chmod +x change-color.sh
./change-color.sh ff8c00
cd ~

# Clear installation files
rm -rf Orchis-theme
rm -rf WhiteSur-gtk-theme
rm -rf Reversal-icon-theme
rm -rf Vimix-cursors
rm -rf my-dconf-settings.ini

printf "\n\n"
# Install Anaconda
read -n 1 -p "Do uou want to install Anaconda (y/n)? " answer
printf "\n\n"
if [[ $answer == "y" ]]; then
  echo "Starting anaconda installation"
  printf "\n\n"
  wget https://repo.anaconda.com/archive/Anaconda3-2022.10-Linux-x86_64.sh
  sudo chmod +x Anaconda3-2022.10-Linux-x86_64.sh
  ./Anaconda3-2022.10-Linux-x86_64.sh
  conda init fish
  conda config --set auto_activate_base false
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

# Install Yandex Browser
# sudo add-apt-repository "deb https://repo.yandex.ru/yandex-browser/deb stable main"
# curl https://repo.yandex.ru/yandex-browser/YANDEX-BROWSER-KEY.GPG --output YANDEX-BROWSER-KEY.GPG
# sudo apt-key add YANDEX-BROWSER-KEY.GPG

sudo apt autoremove

# Reboot part
read -n 1 -p "Do uou want to reboot to apply settings (y/n)? " answer
printf "\n\n"
if [[ $answer == "y" ]]; then
  echo "Rebooting in 3 seconds"
  sudo reboot -f
else
  echo "No reboot"
fi
