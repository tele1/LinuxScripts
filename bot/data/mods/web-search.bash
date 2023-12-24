#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#============================================================================={	    
Func_main_help_web.search.bash() {
		    echo " "
		    echo "      web  Your_Sentence     - Find in web browser."
}


Func_main_case_web.search.bash() {
    if [[ $1 == "web" ]] ; then
        Sentence="${@:2}"
        FuncWebSearch "$Sentence"
        Status_Break=break
    fi
}
#=============================================================================}




#======================================================{
FuncWebSearch() {
#    ddgr --np -n5 "$Sentence" | egrep -i --color "\b(${Sentence})\b|$"

##   With color searched word
    Result=$( ddgr -x --np -n10 --noua "$Sentence" )
    
    
    if [[ -z "$Result" ]]; then
        FuncRED_ECHO "      No suitable result found: $Sentence"
    else 
        ##      grep is used for add color to Sentence
        ##      color not working from variable
        echo "$Result" | grep -E --color -i "\b($Sentence)\b|$" 
    fi


#   w3m  -dump "link"
#   lynx -dump "link"
#   curl / wget
}
#======================================================}
