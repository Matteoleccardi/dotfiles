cd ~/.bashrc.d/
for f in aliases aliases-ethz custom fzf paths paths-ethz yazi zoxide; do
  curl -sL -O  "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/bashrc.d/$f" || echo "Falied: $f"
done
cd
