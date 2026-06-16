# setup wezterm congis
#
# INSTALL
# (Fedora)
#   sudo dnf copr enable wezfurlong/wezterm-nightly
#   sudo dnf install wezterm

mkdir -p ~/.config/wezterm
cd ~/.config/wezterm

curl -sLO https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/wezterm/wezterm.lua


echo "Add this to your SSH config (important):"
echo "nvim .ssh/config"
echo "Host *"
echo "    SetEnv TERM=xterm-256color"



