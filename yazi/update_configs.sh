mkdir -p ~/.config/yazi
cd ~/.config/yazi

# get theme from github catpuccin color theme (mocha-peach)
# (https://github.com/catppuccin/yazi/tree/main/themes/mocha)
# curl -sL -o ./theme.toml https://raw.githubusercontent.com/catppuccin/yazi/refs/heads/main/themes/mocha/catppuccin-mocha-peach.toml

for f in yazi theme keymap vfs; do
  curl -sLO "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/yazi/$f.toml"
done
