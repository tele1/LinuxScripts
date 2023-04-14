#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#============================================================================={	    
Func_main_help_translate.bash() {
		    echo "  "
		    echo "      trans  Your_Sentence   - Translate."
}


Func_main_case_translate.bash() {
    if [[ $1 == "trans" ]] ; then
        Sentence="${@:2}"
        FuncTranslate "$Sentence"
        Status_Break=break
    fi
}
#=============================================================================}




#======================================================{
FuncTranslate() {
    trans "$Sentence"
}
#======================================================}


