#!/bin/bash
# restore_from_icloud.sh - Restore user data from iCloud backup after macOS downgrade

set -euo pipefail

### SETTINGS ###
BACKUP_ROOT="$HOME/Library/Mobile Documents/com~apple~CloudDocs/MacDowngradeBackup"
BACKUP_DIR="$BACKUP_ROOT/HomeBackup"
BREWFILE="$BACKUP_ROOT/Brewfile"
NONBREW_APPS="$BACKUP_ROOT/NonBrewApps.txt"
KEEP_APPS="$BACKUP_ROOT/Applications"
KEEP_LIST="$BACKUP_ROOT/MustKeepApps.txt"
OWNERSHIP_LOG="$BACKUP_ROOT/SystemBackup/ownership_records.txt"

### RESTORE HOME DATA ###
echo "Restoring home directory from $BACKUP_DIR/Users_chris to $HOME..."
rsync -aH --progress --numeric-ids -l "$BACKUP_DIR/Users_chris/" "$HOME/"

### RESTORE /Users/Shared ###
echo "Restoring /Users/Shared from backup..."
sudo rsync -aH --progress --numeric-ids -l "$BACKUP_DIR/Users_Shared/" /Users/Shared/

### RESTORE MUST-KEEP .apps ###
echo "Restoring preserved applications (if any)..."
if [[ -d "$KEEP_APPS" ]]; then
	for app in "$KEEP_APPS"/*.app; do
		echo "Restoring: $(basename "$app")"
		sudo cp -R "$app" /Applications/
	done
else
	echo "No manually preserved apps to restore."
fi

### RESTORE HOMEBREW APPS ###
echo "Checking for Homebrew installation..."
if ! command -v brew &>/dev/null; then
	echo "Homebrew not found. Installing..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "Restoring Homebrew packages from Brewfile..."
brew bundle --file="$BREWFILE"

### REAPPLY OWNERSHIP (automated) ###
echo "Reapplying ownership for system files (automated)..."
if [[ -f "$OWNERSHIP_LOG" ]]; then
	while read -r uid gid path; do
		if [[ -e "$path" ]]; then
			echo "sudo chown $uid:$gid \"$path\""
			sudo chown $uid:$gid "$path"
		else
			echo "Warning: Path not found, skipping: $path"
		fi
	done <"$OWNERSHIP_LOG"
else
	echo "No ownership log found; skipping ownership restoration."
fi

### FINAL REMINDER ###
echo "\nManual steps remaining:"
echo "- Review $NONBREW_APPS to reinstall non-Homebrew apps manually."
echo "- Review and restore any specific app data in ~/Library/Application Support."
