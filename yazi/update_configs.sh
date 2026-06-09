mkdir -p ~/.config/yazi
cd ~/.config/yazi

for f in yazi theme keymap vfs; do
  curl -sLO "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/yazi/$f.toml"
done
