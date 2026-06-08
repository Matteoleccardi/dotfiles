#! /bin/bash

# download this file with:
# cd ~/Downloads
# curl -sL -o "./plugins_setup.sh" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/plugins_setup.sh

cd ~

# make folders
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config

# download your init
curl -sL -o ~/.config/nvim/init.lua https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/init.lua

# install Plugin Manager
curl -sL -o ~/.config/nvim/lua/config/lazy.lua https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/lua/config/lazy.lua

# install Language Server Manager
curl -sL -o ~/.config/nvim/lua/plugins/mason.lua "$BASEURL/neovim/lua/plugins/mason.lua"

# install plugins
curl -sL -o ~/.config/nvim/lua/plugins/treesitter.lua "$BASEURL/neovim/lua/plugins/treesitter.lua"
curl -sL -o ~/.config/nvim/lua/plugins/lspconfig.lua "$BASEURL/neovim/lua/plugins/lspconfig.lua"
curl -sL -o ~/.config/nvim/lua/plugins/telescope.lua "$BASEURL/neovim/lua/plugins/telescope.lua"
curl -sL -o ~/.config/nvim/lua/plugins/yazi.lua "$BASEURL/neovim/lua/plugins/yazi.lua"
curl -sL -o ~/.config/nvim/lua/plugins/mini-pairs.lua "$BASEURL/neovim/lua/plugins/mini-pairs.lua"

# done
echo "Setup completed. now open neovim with 'nvim' and follow instructions."
