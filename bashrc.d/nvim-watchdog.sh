#!/bin/bash
# Kill runaway nvim / Mason LSP servers owned by the current user.
ME=$(id -un)                         # $USER is not always set under cron
NVIM_LIMIT_KB=$((2 * 1024 * 1024))   # 2 GB for nvim itself
LSP_LIMIT_KB=$((3 * 1024 * 1024))    # 3 GB for LSP servers (pyright, clangd, ...)
LOG="$HOME/.local/state/nvim-watchdog.log"
mkdir -p "$(dirname "$LOG")"

# don't let overlapping runs pile up
exec 9>"/tmp/nvim-watchdog.$ME.lock"
flock -n 9 || exit 0

ps -u "$ME" -o pid=,rss=,comm=,args= | while read -r pid rss comm args; do
    if [ "$comm" = "nvim" ]; then
        limit=$NVIM_LIMIT_KB
    elif [[ "$args" == *"/nvim/mason/"* ]]; then
        limit=$LSP_LIMIT_KB
    else
        continue
    fi

    if [ "$rss" -gt "$limit" ]; then
        echo "$(date '+%F %T') killing pid=$pid rss=$((rss/1024))MB cmd=${args:0:120}" >> "$LOG"
        kill -TERM "$pid"
        sleep 5
        kill -0 "$pid" 2>/dev/null && kill -KILL "$pid"
    fi
done
