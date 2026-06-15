cd
# create playlists dir if not exists
mkdir -p ~/.config/mpd/playlists

# register service to start automatically at every startup
systemctl --user enable --now mpd
