#!/bin/bash
cd $(dirname $0) || exit 1

git stash
git pull
git stash pop

# Save packages to file
dpkg --get-selections >packages.txt

# Update packages - delete/install
sudo dpkg --clear-selections
sudo dpkg --set-selections <packages.txt
sudo apt-get dselect-upgrade

exit 0
