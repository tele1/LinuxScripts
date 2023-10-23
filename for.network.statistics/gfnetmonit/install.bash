#!/bin/bash


######################################################}
# Description: Install script for gfnetmonit.
# Destiny: 
#          For install gfnetmonit to /opt/gfnetmonit
#
	VERSION="1"
#	Licence:	GNU GPL v3
# 	Script use:
#               bash ./script --help
#
######################################################}


###########################}
# Check Dependecies - List created automatically by find.bash.dep.sh version=8 
# source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P realpath) ]] && DEP="$DEP"$'\n'"realpath"
[[ -z $(type -P uname) ]] && DEP="$DEP"$'\n'"uname"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
##      coreutils: /usr/bin/realpath
###########################}




##  Relative Path needed for read other files from other place
Relativ_Path="$(dirname "$(realpath $0)")"


#============================================================={
function_install() {

echo " "
echo "--> Installation In Progress ..."
# Copy folder name to /opt/name
# Create symlink /opt/name to /usr/bin/name
# Install script for XDG_Autostart      https://wiki.archlinux.org/title/XDG_Autostart
# Enter appropriate permissions

if uname -a | grep -iq ubuntu ; then
    # set -x ## For debug
    sudo bash -c "cp -vr ${Relativ_Path} /opt/ ; ln -vs /opt/gfnetmonit/gfnetmonit /usr/bin/gfnetmonit ; install -vm644 ${Relativ_Path}/data/gfnetmonit.desktop /etc/xdg/autostart ; chmod -R 755 /opt/gfnetmonit"
else
    su root -c "cp -vr ${Relativ_Path} /opt/ ; ln -vs /opt/gfnetmonit/gfnetmonit /usr/bin/gfnetmonit ; install -vm644 ${Relativ_Path}/data/gfnetmonit.desktop /etc/xdg/autostart ; chmod -R 755 /opt/gfnetmonit"
fi

echo "--> Installation Finished."
}
#=============================================================}


#=================================================={
function_uninstall() {
    echo "--> Uninstallation:"
    # Symlink
    # Script for XDG_Autostart
    # Folder /opt/name
    
    if uname -a | grep -iq ubuntu ; then
        sudo bash -c 'rm -fv /usr/bin/gfnetmonit ; rm -fv /etc/xdg/autostart/gfnetmonit.desktop ; rm -rfv /opt/gfnetmonit'
    else
        su root -c 'rm -fv /usr/bin/gfnetmonit ; rm -fv /etc/xdg/autostart/gfnetmonit.desktop ; rm -rfv /opt/gfnetmonit'
    fi
    echo "--> Uninstallation Finished."
}
#==================================================}


##========================================={
## Options
case $1 in
	"--help"|"-h"|"")
	    echo " --install           -i        Install script."
	    echo " --uninstall         -u        Uninstall script."
	    echo " --help              -h        Show this help."
	    exit 0
	;;
	"--install"|"-i")
	    function_install
	;;
	"--uninstall"|"-u")
	    function_uninstall
	;;
	*)
	    echo "Error: Wrong option: $1"
	    exit 1
	;; 
esac
##=========================================}









