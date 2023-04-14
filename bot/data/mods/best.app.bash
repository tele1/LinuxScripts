#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#============================================================================={
Func_main_help_best.app.bash() {
		    echo " "
		    echo "      best                   - Best app."
}


Func_main_case_best.app.bash() {
    if [[ $1 == "best" ]] ; then
        FuncBest_App
        Status_Break="break"
    fi
}
#=============================================================================}




FuncBest_App() { echo "  Let's go together and you will do it  " \!\!\! ;}


