cd

# create dirs if not exist
mkdir -p ~/.config/mpd/playlists

# download the conf file
cd ~/.config/mpd
curl -sLO https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/mpd/mpd.conf

echo "[ACTION REQUIRED] Go to the conf file and change the default music folder(s):"
echo "~/.config/mpd/mpd.conf"

echo "[START IT] To start it, run the following command:"
echo "sudo systemctl enable --now mpd"
