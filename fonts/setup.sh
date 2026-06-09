#!/bin/bash

# Setup fonts downloading on linux.

# NerdFonts
# https://github.com
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

for f in Hack FiraCode FiraMono UbuntuMono JetBrainsMono; do
  curl -sLO "https://github.comreleases/download/v3.4.0/$f.zip"
  unzip "$f.zip" -d ~/.local/share/fonts/
  rm "$f.zip"
done

fc-cache -fv
