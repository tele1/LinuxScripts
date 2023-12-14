#!/bin/bash


#=============================================================================={
##    Destiny:    Sample functions containing questions.
##    VERSION="1" 
##    Date:       2023.12.01 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                  lib-1-basic-messages.bash
##
#==============================================================================}

#---------------------------------------------------------{
# Example: F_User
# Output: $User_Name 

F_User() {
    echo "Enter your user name:"
    read -r User_Name
        if ! grep -q "$User_Name" <<< "$(ls /home/)" ; then
            F_Error "Error: User name not found in /home/ folder."
        fi
}
#---------------------------------------------------------}

#-------------------------------------------------------------{
# Example: F_Question_yn "Your_Question."
# Output: echo "$Answer1"

F_Question_yn() {
    echo "$1"
    echo "You have 5 seconds to answer: y/n "
    read -r -t6 -n1 Answer1
#    echo "  "
#    if [[ "$Answer1" == y ]] || [[ "$Answer1" == "" ]] ; then
#        echo "I confirm you click y"
#    else
#        echo "I confirm you click n"
#    fi
}
#-------------------------------------------------------------}

#---------------------------------------------------------------{
# Example: F_Question1 "Your_Question."
# Output: echo "$Answer2"

F_Question() {
    echo "$1"
    echo "You have 5 seconds to answer:"
    read -r -t6 Answer2
}
#---------------------------------------------------------------}


