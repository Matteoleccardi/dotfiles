cd
# create dirs if not exist
mkdir -p ~/.config/mpd/playlists

# cd ~/.config/mpd
curl -sLO 

# register service to start automatically at every startup
systemctl --user enable --now mpd
