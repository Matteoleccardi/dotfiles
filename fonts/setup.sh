#!/bin/bash

# Setup fonts downloading on linux.

# NerdFonts
# https://github.com/ryanoasis/nerd-fonts/
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts || exit 1

for f in FiraMono Mononoki NerdFontsSymbolsOnly UbuntuMono; do
  curl -sLO "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$f.zip"
  mkdir -p "$f"
  unzip -qo "$f.zip" -d "$f/"
  rm "$f.zip"
done

fc-cache -fv

echo "Check installation:"
fc-list : family | grep -i "fira"
fc-list : family | grep -i "mononoki"
fc-list : family | grep -i "symbol"
fc-list : family | grep -i "ubuntu"




