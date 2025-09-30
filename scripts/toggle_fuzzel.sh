#!/bin/bash

# Check if fuzzel is already running
if pgrep -x "fuzzel" > /dev/null; then
    # Kill all instances of fuzzel
    pkill -x fuzzel
else
    # Launch fuzzel (you can customize options here)
    fuzzel
fi

