# INSTRUUCTIONS

Copy-paste these following lines in your bashrc file to import all the files 
in the `~/.bashrc.d/` folder into the `.bashrc` file.
 
```bash
if [ -d ~/.bashrc.d ]; then
    # Using 'extglob' for pattern matching to exclude files with a dot:
    shopt -s extglob # Enable extended pattern matching
    
    for rc in ~/.bashrc.d/!(*.*); do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
    
    shopt -u extglob # Disable extended pattern matching (optional, but good practice)
fi
unset rc
```

