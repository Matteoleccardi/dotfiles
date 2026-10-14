#! /bin/bash

# download this file with:
# cd ~/Downloads
# curl -sL -o "./plugins_setup.sh" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/plugins_setup.sh
#
# or better (onel liner):
# curl -sL -o- https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/plugins_setup.sh | bash

curr_wd=$(pwd)

cd ~

# make folders
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config

BASEURL="https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main"
BASECONFIG="$BASEURL/neovim/lua/config"
BASEPLUGINS="$BASEURL/neovim/lua/plugins"

fetch() {  # fetch <url> <dest>
    local tmp
    tmp=$(mktemp) || return 1
    if curl -fsSL --retry 3 --retry-delay 2 -o "$tmp" "$1"; then
        mv "$tmp" "$2"
    else
        rm -f "$tmp"
        echo "Failed: $2"
        return 1
    fi
}

fetch "$BASEURL/neovim/init.lua" ~/.config/nvim/init.lua
fetch "$BASECONFIG/lazy.lua" ~/.config/nvim/lua/config/lazy.lua

for plugin in alpha catppuccin completions lspconfig lualine mason mini-pairs none-ls telescope tokionight treesitter undotree yazi; do
    fetch "$BASEPLUGINS/${plugin}.lua" ~/.config/nvim/lua/plugins/${plugin}.lua
done

# done
echo "Setup completed. now open neovim with 'nvim' and follow instructions."

cd "$curr_wd"
