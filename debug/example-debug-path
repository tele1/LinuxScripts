#!/bin/bash

##      Developed for Linux
##      License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
        VERSION='1'
##      Destiny: To test relative and absolute paths.
##      Script usage: bash script_name


SCRIPT_NAME="$(basename $0)"
echo "NAME of script = $SCRIPT_NAME"
echo " "

##      We will create the paths to the directories
PATH_NAME_1="$(pwd)"
    echo "pwd PATH_NAME_1 = $PATH_NAME_1/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_1}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "
    
PATH_NAME_2="$(dirname "$(which $0)")"
    echo "which PATH_NAME_2 = $PATH_NAME_2/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_2}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "
      
PATH_NAME_3="$(dirname "$(realpath $0)")"
    echo "realpath PATH_NAME_3 = $PATH_NAME_3/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_3}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "
    
PATH_NAME_4="$(dirname "$0")"
    echo "bash parameter \$0 PATH_NAME_4 = $(dirname "$0")/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_4}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "
    
PATH_NAME_5="$(readlink -f "$(dirname "$0")")"
    echo "bash parameter \$0 PATH_NAME_5 = $PATH_NAME_5/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_5}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "

PATH_NAME_6="$(readlink -f "$0")"
    echo "bash parameter \$0 PATH_NAME_6 = $PATH_NAME_6/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_6}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "

PATH_NAME_7="$(dirname "$(readlink -f "$0")")"
    echo "bash parameter \$0 PATH_NAME_7 = $PATH_NAME_7/${SCRIPT_NAME}"
    [[ -f "${PATH_NAME_7}/${SCRIPT_NAME}" ]] && echo "    Script exist in this dir :)" || echo "     Script in this dir not exist!"
    echo " "
    
    
echo " "
