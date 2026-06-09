# How To

## Update the content of .bashrc.d/ folder content

You have to use `curl` to download from GitHub raw content:

```bash
cd ~/.bashrc.d/
for f in aliases aliases-ethz custom paths paths-ethz yazi zoxide; do
  curl -sL -O  "https://raw.githubusercontent.com/Matteoleccardi/dotfiles/refs/heads/main/bashrc.d/$f" || echo "Falied: $f"
done
cd
```



## Setup the .bashrc or .bash_profile file
Copy-paste these following lines in your bashrc file to import all the files 
in the `~/.bashrc.d/` folder into the `.bashrc` file.
 
```bash
if [ -d ~/.bashrc.d ]; then
    # Use find to list files that contain NO dots in their filename, printing with a null terminator
    # This prevents issues with spaces or special characters in filenames
    while IFS= read -r -d '' rc; do
        # Source the file in the CURRENT shell context
        . "$rc"
    done < <(find ~/.bashrc.d -maxdepth 1 -type f -not -name '*.*' -print0)
fi
unset rc # Clean up
```
