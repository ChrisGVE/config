#!/bin/sh

# Extracts the list installed brew formulae/casks to a file
#

brew leaves >~/.config/homebrew/brew-leaves.txt
brew list --cask >~/.config/homebrew/brew-casks.txt
brew list --formula >~/.config/homebrew/brew-formulas.txt
