#!/bin/zsh

# Extracts the list installed brew formulae/casks to a file
#

/usr/local/bin/brew bundle dump --all --describe --quiet --force --file ~/.config/homebrew/Brewfile
/usr/local/bin/brew leaves >~/.config/homebrew/brew-leaves.txt
/usr/local/bin/brew list --cask >~/.config/homebrew/brew-casks.txt
/usr/local/bin/brew list --formula >~/.config/homebrew/brew-formulas.txt
/usr/local/bin/mas list >~/.config/homebrew/mas-list.txt

# Update git repo with these changes
cd ~/.config/homebrew || exit
git add ~/.config/homebrew/*
git commit -am "chore(brew): automatic update of the homebrew lists"
git push
