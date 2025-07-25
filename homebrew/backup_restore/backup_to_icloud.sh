#!/bin/bash
# backup_to_icloud.sh - Backup full $HOME to iCloud with minimal exclusions
# Target: macOS with iCloud Drive enabled and sufficient space

set -euo pipefail

### SETTINGS ###
# BACKUP_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MacDowngradeBackup"
BACKUP_ROOT="/Volumes/OWC Mercury/MacDowngradeBackup"
BACKUP_DIR="$BACKUP_ROOT/HomeBackup"
BREWFILE="$BACKUP_ROOT/Brewfile"
NONBREW_APPS="$BACKUP_ROOT/NonBrewApps.txt"
KEEP_LIST="MustKeepApps.txt"
UPLOAD_LOG="$BACKUP_ROOT/iCloudUploadStatus.log"
OWNERSHIP_LOG="$BACKUP_ROOT/SystemBackup/ownership_records.txt"
RSYNC=/usr/local/bin/rsync

### CREATE BACKUP FOLDER ###
echo "Creating backup folder at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

### DUMP HOMEBREW APPS LIST ###
echo "Dumping Homebrew apps to $BREWFILE..."
brew bundle dump --file="$BREWFILE" --force

### LIST NON-BREW GUI APPS (recursive for Setapp etc.) ###
echo "Listing non-Homebrew apps to $NONBREW_APPS..."
find /Applications -type d -name "*.app" |
	grep -v "/Cellar/" |
	sort >"$NONBREW_APPS"

### ADD MUST-KEEP APP PLACEHOLDER ###
# echo "Creating editable list of apps to preserve fully..."
# echo "# List full .app names (e.g., Obsidian.app) one per line" >"$KEEP_LIST"
# echo "# These will be preserved as-is from /Applications during backup" >>"$KEEP_LIST"
# echo >>"$KEEP_LIST"

### COPY MUST-KEEP .apps ###
echo "Copying must-keep apps (if any)..."
mkdir -p "$BACKUP_ROOT/Applications"
while read -r app; do
	[[ "$app" == "" || "$app" =~ ^# ]] && continue
	if [[ -d "/Applications/$app" ]]; then
		echo "Preserving: $app"
		sudo $RSYNC -aH --progress --numeric-ids -l "/Applications/$app/" "$BACKUP_ROOT/Applications/$app"
	else
		echo "Warning: $app not found in /Applications" >&2
	fi
done <"$KEEP_LIST"

### BACKUP HOME TO Users_chris SUBFOLDER ###
echo "Backing up $HOME to $BACKUP_DIR/Users_chris..."
sudo $RSYNC -aHv --progress --numeric-ids -l \
	--exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' \
	--exclude '.Trash' \
	--exclude 'Library/Mobile Documents' \
	--exclude 'Library/CloudStorage' \
	--exclude 'Library/Application Support/CloudDocs' \
	--exclude 'Library/SyncedPreferences' \
	--exclude 'Library/Group Containers/*.icloud*' \
	"$HOME/" "$BACKUP_DIR/Users_chris/"

### BACKUP /Users/Shared TO Users_Shared ###
echo "Backing up /Users/Shared to $BACKUP_DIR/Users_Shared..."
sudo $RSYNC -aH --progress --numeric-ids -l /Users/Shared/ "$BACKUP_DIR/Users_Shared/"

### BACKUP SYSTEM-LEVEL FILES ###
echo "Backing up system-level global folders..."
mkdir -p "$BACKUP_ROOT/SystemBackup"

# Save ownership metadata
echo "Recording ownership for critical system folders..."
find /Library /opt /usr/local /etc -exec stat -f "%u %g %N" {} + >"$OWNERSHIP_LOG" 2>/dev/null || true

# Save additional environment and system info
id -u >"$BACKUP_ROOT/SystemBackup/user_uid.txt"
id -g >"$BACKUP_ROOT/SystemBackup/user_gid.txt"
env >"$BACKUP_ROOT/SystemBackup/env_snapshot.txt"
crontab -l >"$BACKUP_ROOT/SystemBackup/user_crontab.txt" 2>/dev/null || echo "No crontab set."
system_profiler -detailLevel mini >"$BACKUP_ROOT/SystemBackup/system_profile.txt"
pkgutil --pkgs >"$BACKUP_ROOT/SystemBackup/pkg_list.txt"

# /Library/Application Support (filtered manually later)
sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/Application\ Support/ "$BACKUP_ROOT/SystemBackup/ApplicationSupport/"

# Fonts
sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/Fonts/ "$BACKUP_ROOT/SystemBackup/Fonts/"

# LaunchDaemons
sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/LaunchDaemons/ "$BACKUP_ROOT/SystemBackup/LaunchDaemons/"

# Scripts
[ -d /Library/Scripts ] && sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/Scripts/ "$BACKUP_ROOT/SystemBackup/Scripts/"

# QuickLook plugins
[ -d /Library/QuickLook ] && sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/QuickLook/ "$BACKUP_ROOT/SystemBackup/QuickLook/"

# Audio plugins
[ -d /Library/Audio ] && sudo $RSYNC -aH --progress --numeric-ids --exclude='*.sock' --exclude='/private/tmp/' --exclude='/var/run/' --exclude='.*/.*.sock' -l /Library/Audio/ "$BACKUP_ROOT/SystemBackup/Audio/"

# /opt
[ -d /opt ] && sudo tar --numeric-owner -czf "$BACKUP_ROOT/SystemBackup/opt.tar.gz" /opt

# /usr/local
[ -d /usr/local ] && sudo tar --numeric-owner -czf "$BACKUP_ROOT/SystemBackup/usr_local.tar.gz" /usr/local

# selected /etc configs
sudo tar --numeric-owner -czf "$BACKUP_ROOT/SystemBackup/etc_config.tar.gz" /etc/hosts /etc/ssh 2>/dev/null || echo "No /etc/ssh or /etc/hosts to archive."
