#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#============================================================================={	    
Func_main_help_run.command.bash() {
		    echo " "
		    echo "      com: Your_Command      - Command."
}


Func_main_case_run.command.bash() {
    if [[ $1 == "com:" ]] ; then
        Sentence="${@:2}"
        FuncRunCommand "$Sentence"
        Status_Break=break
    fi
}
#=============================================================================}




#======================================================{
FuncRunCommand() {
    
    ## Change grep to  grep='grep --color=always'
    Sentence=$(sed "s/ grep / grep --color=always /g" <<< "${Sentence}")
    
    
    ## eval to run like command
    echo "${Sentence}"
    echo " "
    eval "${Sentence}"
}
#======================================================}
