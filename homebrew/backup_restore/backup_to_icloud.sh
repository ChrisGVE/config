#!/bin/bash
# backup_to_icloud.sh - Backup full $HOME to iCloud with minimal exclusions
# Target: macOS with iCloud Drive enabled and sufficient space

set -euo pipefail

### SETTINGS ###
BACKUP_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MacDowngradeBackup"
BACKUP_DIR="$BACKUP_ROOT/HomeBackup"
BREWFILE="$BACKUP_ROOT/Brewfile"
NONBREW_APPS="$BACKUP_ROOT/NonBrewApps.txt"
KEEP_LIST="$BACKUP_ROOT/MustKeepApps.txt"
UPLOAD_LOG="$BACKUP_ROOT/iCloudUploadStatus.log"

### CREATE BACKUP FOLDER ###
echo "Creating backup folder at $BACKUP_DIR..."
mkdir -p "$BACKUP_DIR"

### DUMP HOMEBREW APPS LIST ###
echo "Dumping Homebrew apps to $BREWFILE..."
brew bundle dump --file="$BREWFILE" --force

### LIST NON-BREW GUI APPS ###
find /Applications -type d -name "*.app" -print |
	grep -v "/Cellar/" |
	sort >"$NONBREW_APPS"

### ADD MUST-KEEP APP PLACEHOLDER ###
echo "Creating editable list of apps to preserve fully..."
echo "# List full .app names (e.g., Obsidian.app) one per line" >"$KEEP_LIST"
echo "# These will be preserved as-is from /Applications during backup" >>"$KEEP_LIST"
echo >>"$KEEP_LIST"

### COPY MUST-KEEP .apps ###
echo "Copying must-keep apps (if any)..."
mkdir -p "$BACKUP_ROOT/Applications"
while read -r app; do
	[[ "$app" == "" || "$app" =~ ^# ]] && continue
	if [[ -d "/Applications/$app" ]]; then
		echo "Preserving: $app"
		cp -R "/Applications/$app" "$BACKUP_ROOT/Applications/"
	else
		echo "Warning: $app not found in /Applications" >&2
	fi
done <"$KEEP_LIST"

### RSYNC HOME (excluding iCloud system data only) ###
echo "Starting rsync of $HOME to $BACKUP_DIR..."
rsync -avh \
	--exclude '.Trash' \
	--exclude 'Library/Mobile Documents' \
	--exclude 'Library/CloudStorage' \
	--exclude 'Library/Application Support/CloudDocs' \
	--exclude 'Library/SyncedPreferences' \
	--exclude 'Library/Group Containers/*.icloud*' \
	"$HOME/" "$BACKUP_DIR/"

### CHECK ICLOUD SYNC STATUS ###
echo "Checking iCloud upload progress (this may take time)..."
find "$BACKUP_ROOT" -type f | while read -r file; do
	status=$(mdls -name kMDItemFSIsUbiquitous -name kMDItemUbiquitousItemIsUploading "$file" 2>/dev/null || true)
	echo "$file -> $status" >>"$UPLOAD_LOG"
done

### TAIL THE LOG FOR LIVE MONITORING ###
echo "Tailing upload log to monitor sync progress..."
echo "Use Ctrl+C to stop watching when uploads are done."
echo "Look for files with 'kMDItemUbiquitousItemIsUploading = 1' to identify what's still uploading."
tail -f "$UPLOAD_LOG"
