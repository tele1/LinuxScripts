#!/bin/bash


#=============================================================================={
##    Destiny:    To add or remove job from cron.
##    VERSION="1" 
##    Date:       2023.12.01 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                 lib-1-basic-messages.bash  
#==============================================================================}


#=============================================================================={
#-------------------------------------------------------{
##      F_Add.To.Cron "time frame" "task"
##      For example:     F_Add.To.Cron "0 10 * * 1,3" 'echo "Start every Monday and Wednesday at 10:00"'

F_Add.To.Cron() {
    [[ -z "$1" ]] && { F_Error "Error: lib-cron: First argument \$1 is empty."  ;}
    [[ -z "$2" ]] && { F_Error "Error: lib-cron: Second argument \$2 is empty."  ;}    

    crontab -l | { cat ; echo "${1}      ${2}"  ; } | crontab - 

    if [ ! "$?" == 0 ] ; then
        F_Error "Error: lib-cron: Probably an incorrect argument was given to crontab."
    fi
}
#-------------------------------------------------------}

#----------------------------------------------------------------{
##      F_Remove.From.Cron "a line or part of text that will remove lines containing that text"
##      For example:     F_Remove.From.Cron 'Start every Monday'
##      For example:     F_Remove.From.Cron '0 10 \* \* 1,3'

F_Remove.From.Cron() {
    [[ -z "$1" ]]   && { F_Error "Error: lib-cron: First argument \$1 is empty" ;}
    [[ ! -z "$2" ]] && { F_Error "Error: lib-cron: Too many arguments, \$2 is unnecessary" ;}

    crontab -l | grep -v "${1}" | crontab -
    
    if [ ! "$?" == 0 ] ; then
        F_Error "Error: lib-cron: Probably an incorrect argument was given to crontab."
    fi
}
#----------------------------------------------------------------}

#---------------------------------------------------------{
# Read from Cron:   crontab -l 
#                   crontab -l | grep "Your_Text"
#---------------------------------------------------------}
#==============================================================================}
