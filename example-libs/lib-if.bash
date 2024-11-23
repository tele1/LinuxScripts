#!/bin/bash


#=============================================================================={
##    Destiny:    A script designed to detect the base Linux distribution
##    VERSION="1" 
##    Date:       2024.11.22 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                 
#==============================================================================}

#============================================================================{
##       If you want execute command:
#                   Var1=1 
#                   F_If "Var1" Your-Command
##       If you do not want execute command:
#                   Var1=0 
#                   F_If "Var1" Your-Command

F_If() 
{
    if [[ "$1" == 1 ]] ; then
        # Execute arguments from 2 to end
        "${@:2}"
    fi
}
#============================================================================}


#============================================================================{
##   Example:
#
#       Var1=0
#       Var4=0
#       Var5=1 
#       Var6=0
#       F_If_2 "$Var1" "$Var2" "$Var3" "$Var4" "$Var5" "$Var6" "then" echo "Hello World"
#
#   If any variable is equal to 1, 
#   then the function executes the command after the word "then"
#   In this example this is: echo "Hello World"
#   All arguments before the word "then" are treated as a variable.
#   The number of variables can be any, but remember that it may be limited by Bash.

F_If_2()
{
    ##  List all arguments
    for Arg in "$@" ; do
        Count_Arg=$(("$Count_Arg"+1))
        
    ##    For debug Arg
    #    echo "$Arg : $Count_Arg"

        ##  Save arguments to array
        Arg[$Count_Arg]="$Arg"
        
            if [[ "$Arg" == "then" ]] ; then
                break
            fi
    done

    ##  List all arguments from 1 to "then" argument.
    for Arg_2 in ${Arg[@]} ; do

        # If $Arg_2 = "then" then then go to the next argument Arg_2
        [[ "$Arg_2" == "then" ]] && continue

        if [[ $Arg_2 == 1 ]] ; then
            # Execute command
            "${@: ${#Arg[@]} }"
            break
        fi
    done
}
#============================================================================}
