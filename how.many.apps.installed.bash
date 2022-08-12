#!/bin/bash


##      Developed for Linux
##      License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
        VERSION='beta 1'
##      Destiny: To show how many packages do you have installed
##      Script usage: bash script_name


##==================================={

echo "Installed packages:"
echo "=================="



[[ ! -z $(type -P dnf) ]] && DNF=$(dnf list installed | wc -l) && echo "dnf = $DNF"

[[ ! -z $(type -P flatpac) ]] && FLAT=$(flatpak list --runtime | wc -l) && echo "flatpak = $FLAT"

[[ ! -z $(type -P snap) ]] && SNAP=$(snap list | sed '1d' | wc -l) && echo "snap = $SNAP"

[[ ! -z $(type -P apt) ]] && APT=$(apt list --installed 2>/dev/null | sed '1d' | wc -l) && echo "apt = $APT"

[[ ! -z $(type -P pacman) ]] && PAC=$(pacman -Qn | wc -l) && echo "pacman = $PAC"

[[ ! -z $(type -P pacman) ]] && AUR=$(pacman -Qm | wc -l) && echo "AUR = $AUR"









