#!/bin/bash

# Set the primary monitor
export PRIMARY_MONITOR=$(~/.config/polybar/scripts/get_primary_monitor.sh)

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Detect the current window manager and launch the appropriate Polybar configuration
if pgrep -x "i3" >/dev/null; then
    polybar mainbar-i3 &
elif pgrep -x "sway" >/dev/null; then
    polybar mainbar-sway &
elif pgrep -x "openbox" >/dev/null; then
    polybar mainbar-openbox &
elif pgrep -x "bspwm" >/dev/null; then
    polybar mainbar-bspwm &
elif pgrep -x "herbstluftwm" >/dev/null; then
    polybar mainbar-herbstluftwm &
# ... add more conditions for other window managers as needed
else
    echo "No recognized window manager is running!"
    exit 1
fi

echo "Polybar launched..."
