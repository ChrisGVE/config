#!/bin/sh

# Extracts the list installed brew formulae/casks to a file
#

/usr/local/bin/brew leaves >~/.config/homebrew/brew-leaves.txt
/usr/local/bin/brew list --cask >~/.config/homebrew/brew-casks.txt
/usr/local/bin/brew list --formula >~/.config/homebrew/brew-formulas.txt

# Update git repo with these changes
cd ~/.config/homebrew || exit
git add ./*glob*
git commit -am "chore(brew): automatic update of the homebrew lists"
git push
