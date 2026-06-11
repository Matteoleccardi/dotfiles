#! /bin/bash

echo "Updating all configs from"
echo "https://github.com/Matteoleccardi/dotfiles/"

MYCURRDIR="$PWD"

# vim
cd
curl -sLO "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/Vim/.vimrc"

# bashrc.d
cd
mkdir -p ./.bashrc.d
curl -sL -o ./__upd.sh "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/bashrc.d/update.sh"
bash ./__upd.sh
echo "If it is the first time on this machine updating the bashrc.d, then have a look here, second section:"
echo "https://github.com/Matteoleccardi/dotfiles/tree/main/bashrc.d"

# fonts
cd
curl -sL -o ./__upd.sh "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/fonts/setup.sh"
bash ./__upd.sh

# nvim
cd
curl -sL -o ./__upd.sh "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/plugins_setup.sh"
bash ./__upd.sh

# tmux
cd
curl -sL -o ./__upd.sh "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/tmux/update_tmux.conf.sh"
bash ./__upd.sh

# yazi
cd
curl -sL -o ./__upd.sh "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/yazi/update_configs.sh"
bash ./__upd.sh

# condardc
echo "check out your ~/.condarc file. I cannot update it manually, but you can look at this:"
echo "https://github.com/Matteoleccardi/dotfiles/blob/main/miniconda3/.condarc"





# list of packages to install manually
echo "Please install the following yourself:"
echo "htop btop fastfetch mpv vlc"     # instead of fastfetch you can use hostnameclt
echo "miniconda nvm"                   # version managers for python and node.js that install in $HOME
                                       # both required
echo "tmuxffmpeg  7z fzf zoxide yazi neovim"


# cleanup
cd
rm -f ./__upd.sh

cd "$MYCURRDIR"
