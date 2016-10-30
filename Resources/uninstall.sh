#!/bin/bash
cd "$(dirname "$0")" || exit

# Quit System Preferences
osascript -e 'tell application "System Preferences" to quit'

# Stop the daemon
launchctl unload "$HOME/Library/LaunchAgents/com.cyberic.smoothmouse.plist"
/usr/bin/killall "smoothmoused"
/usr/bin/killall "SmoothMouseDaemon"

# Crash if the daemon is still alive
DAEMON_SIG="Contents/MacOS/SmoothMouse"
DAEMON_PID=$(/bin/ps -A | /usr/bin/grep -i "$DAEMON_SIG" | /usr/bin/grep -v grep | /usr/bin/awk '{print $1}')
if [ -n "$DAEMON_PID" ]; then
    echo "Failed to stop the daemon."
    exit 1
fi

# Unload the kernel extension
KEXT_SIG="com.cyberic.SmoothMouse"
/sbin/kextunload -b "$KEXT_SIG"

# Crash if the kext is still loaded
if [[ $(kextstat -lb "$KEXT_SIG") ]]; then
	echo "Failed to unload the kernel extension."
	exit 1
fi

# Remove files listed in paths.txt
while read path; do
	path=$(eval "echo $path")
	if [ -e "$path" ]; then
		rm -r "$path" || exit 126
	fi
done <paths.txt

# Forget receipts
pkgutil --forget "com.cyberic.pkg.SmoothMouseKext"
pkgutil --forget "com.cyberic.pkg.SmoothMouseKext2"
pkgutil --forget "com.cyberic.pkg.SmoothMousePrefPane"

exit 0
