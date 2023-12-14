#!/bin/bash


#=============================================================================={
##    Destiny:    A script designed to save text message to system log.
##    VERSION="1" 
##    Date:       2023.12.01 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                  lib-1-basic-messages.bash
##
##      I suggest test system logs, try use script = test.logger.bash
##      and "man logger"
#==============================================================================}

#   https://stackoverflow.com/questions/48086633/simple-logging-levels-in-bash
#   https://github.com/Zordrak/bashlog


#=============================================================================={
#------------------------------------------------{
# Checking whether necessary dependencies exist.
# This is not function.

##      0 = Installed
##      1 = Not installed

[[ ! -f "/var/log/syslog" ]]      && Syslog=1     || Syslog=0
[[ -z $(type -P journalctl) ]]    && Journalctl=1 || Journalctl=0
[[ -z $(type -P logger) ]]        && Logger=1     || Logger=0


if [[ "$Journalctl" == 1 ]] && [[ "$Syslog" == 1 ]] ; then
    F_Error "lib-3-log.bash" "journalctl and syslog file not detected / not installed."
fi

if [[ "$Logger" == 1 ]] ; then
    F_Error "lib-3-log.bash" "logger app is not installed, try find bsdutils package."
    # logger is part of bsdutils package
fi
#------------------------------------------------}


#-----------------------------------------------------{
#   Example:  Write_To_Log "err" "Package A is not installed."
#   Priotity list from "man logger" :
#      emerg , alert , crit , err , warning , notice , info , debug .

F_Write_To_Log() {
    F_Error_Arg "lib-3-log.bash" "$#" "2"
#   Example: logger -sp ${Facility}.${Priority} "app_name: ${Priority}: $Text"
#   Priority occurs twice because I didn't see it in the log "/var/log/syslog".
    logger -sp syslog.${1} "${0}: ${1}: ${2}"
}
#-----------------------------------------------------}


#----------------------------------------------------------{
#   Example: F_Read_Log "Your_Text"

F_Read_Log() {
    if [[ "$Journalctl" == 0 ]] ; then
        journalctl --no-pager -b0 -g "$1"
    elif [[ "$Syslog" == 0 ]] ; then
        grep -i "$1" /var/log/syslog
    else
        F_Error "lib-3-log.bash" "Not found installed systemd and syslog in F_Read_Log function."
    fi
}
#----------------------------------------------------------}
#==============================================================================}
