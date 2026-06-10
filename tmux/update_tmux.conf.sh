#! /bin/bash

# download the current .timux.conf file
cd ~
curl -sL -o "./.tmux.conf" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/tmux/.tmux.conf

# install catpuccin stuyle plugin
mkdir -p ~/.config/tmux/plugins/catppuccin
git clone -b v2.3.0 https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
# all styles specifications are already in the .tmux.conf file, no need to do anything else here
