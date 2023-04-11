#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


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
