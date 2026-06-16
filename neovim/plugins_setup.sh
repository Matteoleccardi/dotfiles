#! /bin/bash

# download this file with:
# cd ~/Downloads
# curl -sL -o "./plugins_setup.sh" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/plugins_setup.sh

cd ~

# make folders
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config

BASEURL="https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main"
BASECONFIG="$BASEURL/neovim/lua/config"
BASEPLUGINS="$BASEURL/neovim/lua/plugins"

# download your init
curl -sL -o ~/.config/nvim/init.lua "$BASEURL/neovim/init.lua"

# install Plugin Manager
curl -sL -o ~/.config/nvim/lua/config/lazy.lua "$BASECONFIG/lazy.lua"

# install Language Server Manager
curl -sL -o ~/.config/nvim/lua/plugins/mason.lua "$BASEPLUGINS/mason.lua"

# install plugins
# (
#   this might be useful:
#   
#   cd ~/.config/nvim/lua/plugins/
#   a=""; for f in *; do a="$a ${f%.*}"; done; echo $a; unset a;
# )
for plugin in catppuccin lspconfig lualine mason mini-pairs telescope tokionight treesitter undotree yazi; do
    curl -sL -o ~/.config/nvim/lua/plugins/${plugin}.lua "$BASEPLUGINS/${plugin}.lua" || echo "Failed: ${plugin}.lua"
done

# done
echo "Setup completed. now open neovim with 'nvim' and follow instructions."
