#!/bin/bash
# tor_watchdog.sh - Checks if Tor is running; if not, starts it.

# Path to log file (optional)
LOGFILE="$HOME/tor_watchdog.log"

active_services="$(service --status-all | grep "+")"


if [[ "$active_services" =~ \[\ \+\ \]\ +tor[[:space:]]* ]]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Tor is already running."
else
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Tor is NOT running. Starting Tor..."
    # Start Tor in the background
    sudo service tor start
    # tor &> /dev/null &
    sleep 2
    if pgrep -x "tor" > /dev/null; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Tor started successfully." >> "$LOGFILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Failed to start Tor!" >> "$LOGFILE"
    fi
fi

# echo $active_services