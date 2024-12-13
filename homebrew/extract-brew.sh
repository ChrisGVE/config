#!/bin/sh

# Extracts the list installed brew formulae/casks to a file
#

/usr/local/bin/brew leaves >~/.config/homebrew/brew-leaves.txt
/usr/local/bin/brew list --cask >~/.config/homebrew/brew-casks.txt
/usr/local/bin/brew list --formula >~/.config/homebrew/brew-formulas.txt
