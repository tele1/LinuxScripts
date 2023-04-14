#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#============================================================================={
Func_main_help_check.ort.bash() {
		    echo " "
		    echo "      check  Your_Sentence   - Check in dictionary."
}


Func_main_case_check.ort.bash() {
    if [[ $1 == "check" ]] ; then
        Sentence="${@:2}"
        Func_Dictionary_Ort "$Sentence"
        Status_Break=break
    fi
}
#=============================================================================}




#======================================================{
Func_Dictionary_Ort() {

#echo $@

# save to array
Words=($@)

#-----------------------------------------{
FuncPartCheckWord() {
    if [[ ${Word} =~ ^[0-9]+$ ]] ; then
        Answer=$(FuncGREEN_ECHO "[Numer]")
        echo "$Word $Answer"


    elif [[ ${Word} =~ ^[a-Zążźćśęó]+$ ]] ; then
    
        if grep -qi ^${Word}$ /usr/share/dict/polish ; then
            Answer=$(FuncGREEN_ECHO "[Poprawne]")
            echo "$Word $Answer"
        else
            Answer=$(FuncRED_ECHO "[Nie znam]")
            echo "$Word $Answer"
        fi
        
 
    else
        # True=1 ; False=0
        Mixed=1
    fi
}
#-----------------------------------------}


for Word in "${Words[@]}" ; do

    ## Idea:
    ## Instead  repeat twice " FuncPartCheckWord " ,
    ## maybe better will execute " while " loop two times.
    ## However it works fine too.

    ##      Reset variable
    Mixed=0
    ##      Start function
    FuncPartCheckWord
      
        
    if [[ "${Mixed}" == 1 ]] ; then

        LastCharacter=${Word: -1}
        if [[ "${LastCharacter}" =~ [\.\,\!\?\:] ]] ; then

            ## Word without last character
            Word=${Word::-1}
            
            ##      Reset variable
            Mixed=0
            ##      Start function
            FuncPartCheckWord
            
            if [[ "${Mixed}" == 1 ]] ; then
                Answer=$(FuncGREEN_ECHO "[Mieszany]")
                echo "$Word $LastCharacter $Answer"
            fi
            
        else
            Answer=$(FuncGREEN_ECHO "[Mieszany]")
            echo "$Word $Answer"
        fi
    fi
done
}
#======================================================}
