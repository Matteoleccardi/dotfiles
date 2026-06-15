cd

# create dirs if not exist
mkdir -p ~/.config/mpd/playlists

# download the conf file
cd ~/.config/mpd
curl -sLO https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/mpd/mpd.conf

# register service to start automatically at every startup
systemctl --user enable --now mpd

echo "[ACTION REQUIRED] Go to the conf file and change the default music folder(s):"
echo "~/.config/mpd/mpd.conf"
