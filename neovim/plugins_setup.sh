cd ~

# make folders
mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config

# download your init
curl -sL -o "~/.config/nvim/init.lua" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/init.lua

# install plugin manager
curl -sL -o "~/.config/nvim/lua/config/lazy.lua" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/lua/config/lazy.lua

# setup yazi
curl -sL -o "~/.config/nvim/lua/plugins/yazi.lua" https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/neovim/lua/plugins/yazi.lua


