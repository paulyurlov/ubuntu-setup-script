#!/bin/bash

SCRIPTPATH="$(
    cd -- "$(dirname "$0")" >/dev/null 2>&1
    pwd -P
)"

cp $SCRIPTPATH/my-posh-config.json ~/.config/fish/
echo "oh-my-posh init fish --config ~/.config/fish/my-posh-config.json | source" >~/.config/fish/config.fish

conda init fish
conda config --set auto_activate_base false
sudo apt autoremove
dconf load / <$SCRIPTPATH/my-dconf-settings.ini
