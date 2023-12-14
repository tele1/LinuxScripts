#!/bin/bash


#=============================================================================={
##    Destiny:    A script designed to detect the base Linux distribution
##    VERSION="1" 
##    Date:       2023.12.01 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Try use in your own bash script: 
#                   source lib-detect-base-linux-distro.bash
#                   echo "$Base_Linux_Distro"
#   Info: 
#       Expect a distribution name on output, eg. Ubuntu, Arch.
#==============================================================================}


#============================================================================{

#   To get output you need add in your script
#       echo "$Base_Linux_Distro"

if grep -riq "Ubuntu" /etc/*release ; then
    Base_Linux_Distro="Ubuntu"
    
elif grep -riq "Arch Linux" /etc/*release; then
    Base_Linux_Distro="Arch"
    
else
    Base_Linux_Distro="Other Linux Distro"
fi

#============================================================================}
