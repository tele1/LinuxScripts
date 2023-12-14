#!/bin/bash


#=============================================================================={
##    Destiny:  This will create your basic text message.
##    Version="1" 
##    Date:       2023.11.30 (Year.Month.Day) 
##    License:    GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
##    Source:     https://github.com/tele1/LinuxScripts
##    Script usage: Each function below has a guide how to use it.
#==============================================================================}


#---------------------------------------------------------{
# Example:  F_Info "Your_Text"

F_Info() {
    echo "  Info: $1"
}
#---------------------------------------------------------}

#---------------------------------------------------------{
#   This function will only work if you add a variable in the script
#       Debug="ON"
#   If you change to Debug="OFF" then this function will disabled.

# Example:  F_Debug "lib-own-func.bash" "Additional_Information" 

F_Debug() {
    if [[ "$Debug" == "ON" ]] ; then
        echo "  DEBUG: $1: $2 "
    fi
}
#---------------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Warning "Your_Text"

F_Warning() {
    echo "  Warning: $1"
}
#---------------------------------------------------------}

#-------------------------------------------------------{
# Example:  F_Error "lib-colors.bash" "An incorrect argument was provided." 
#   Explanation:
#   "lib-colors.bash" = is name script where "F_Error" is used  
#   "An incorrect argument was provided" = Your text message

F_Error() {
    echo "  Error: ${1}: ${2}" 1>&2
    echo "  Exit." 1>&2
    exit 1
}
#-------------------------------------------------------{

#-----------------------------------------------{
# Example:  F_Error_Arg "lib-colors.bash" "$#" "3" 
#   Explanation:
#   "lib-colors.bash" = is name script where "F_Error_Arg" is used
#   "$#"     = sum arguments 
#   "3"      = number of arguments which should be.

F_Error_Arg() {
    if [[ ! "$2" == "$3" ]] ; then
        echo "  Error: ${1}: The sum of the arguments is $2 ." 1>&2 
        echo "          Your function should have $3 arguments." 1>&2 
        exit 1  
    fi
}
#-----------------------------------------------}


