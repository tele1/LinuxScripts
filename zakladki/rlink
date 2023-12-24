#!/bin/bash


#   License:        GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
#   Destiny:        For managing links from the web browser, like Firefox.
    VERSION="Beta 12"
#   Date:       11.2022
#   Source:     https://github.com/tele1/LinuxScripts

#   Script usage:       bash script_name


#--------------------------------------------------------------------------
#========{
##  Safeguard
SOURCE_IF_EXIST() 
{
    if [[ -f "$1" ]] ; then
        source "$1"
    else
        echo "Error: Source not found: $1" ; exit 1
    fi
}
#========}


## "realpath" is good advice instead "./" https://forums.linuxmint.com/viewtopic.php?p=2208260#p2208260
PATH_OF_SCRIPT="$(dirname "$(realpath $0)")"
SOURCE_IF_EXIST "$PATH_OF_SCRIPT"/link.data/function.select.option.bash
SOURCE_IF_EXIST "$PATH_OF_SCRIPT"/link.data/functions.keyboard.shortcuts.bash
SOURCE_IF_EXIST "$PATH_OF_SCRIPT"/link.data/functions.options.of.script.bash
SOURCE_IF_EXIST "$PATH_OF_SCRIPT"/link.data/splash.bash
PATH_OF_LINKS="./linki"
BACK=0
#OPEN_LINK=0
# You can change: ON / OFF
DEBUG_1="OFF"

# if options are enabled
if [[ ! -z "$1" ]] ; then
case "$1" in
	"--help"|"-h")
        FUNC_HELP 
    ;;
    "--version")
        echo "$VERSION" 
    ;;
    "-i.html")
        ## I used while to read all html files
        ## if you added more than 1 file like this:  command -i.html file file file.
        while  read -r ARG ; do
            #echo "$ARG"
            FUNC_IMPORT_BOOKMARKS_HTML "$1" "$ARG"
        done <<< $(tr ' ' '\n' <<< "${@:2}")
    ;;
    "-i.tabs")
        FUNC_IMPORT_TABS_URL "$1" "$2"
    ;;
    *)
        echo "Error: Unknown option $1."
esac
exit 0
fi 


#========{
DEBUG_1()
{
    if [[ "$DEBUG_1" == "ON" ]] ; then
        echo -e " DEBUG: $1 "
    fi
}
#========}


#========{
FUNC_OPEN() {
    DEBUG_1 "#====== FUNC_OPEN ======={"
    DEBUG_1 "PATH_OF_LINKS = $PATH_OF_LINKS"
    DEBUG_1 "Choosen index CHOICE = $CHOICE"
    DEBUG_1 "        value = ${TITLE[$CHOICE]}"
    DEBUG_1 "  Link = ${LINK[$CHOICE]}"
    DEBUG_1 " "
    
    # Update PATH_OF_LINKS for next menu
    IF_EXIST=$(readlink -e "${TITLE[$CHOICE]}")
    if [ ! -z "$IF_EXIST" ] ; then
        # Path exist
        DEBUG_1 "This is file = ${TITLE[$CHOICE]}" 
        PATH_OF_LINKS="${TITLE[$CHOICE]}"
        DEBUG_1 "PATH_OF_LINKS updated."
        EDIT_FILE_PATH="$PATH_OF_LINKS"
    else
        # Path not exist
        DEBUG_1 "This is title = ${TITLE[$CHOICE]}"
    fi
    DEBUG_1 "#====== FUNC_OPEN =======}"
} 
#========}

#============{
FUNC_SAVE_FILE_TO_ARRAYS(){
    NUMB=0 ; while read -r COL1 COL2 ; do
        TITLE[${NUMB}]="$COL2"
        LINK[${NUMB}]="$COL1"
        NUMB=$((${NUMB}+1))
    done < "$PATH_OF_LINKS"
}
#============}


FUNC_BACK_FROM_FILE() {
    if [[ "$BACK" == 1 ]] ; then
        # Clear link
        LINK=()
        # Cut last part of the path = for move up / higher path
        PATH_OF_LINKS="${PATH_OF_LINKS%/*}"
#        PATH_OF_LINKS="${PATH_OF_LINKS%/*}"
        # forbidden path "./"
        if [[ "$PATH_OF_LINKS" == '.' ]] ; then 
            PATH_OF_LINKS='./linki'
        fi
        DEBUG_1 "FUNC_BACK -> PATH_OF_LINKS = $PATH_OF_LINKS"
        BACK=0
#        DEBUG_1 "  Link22 = ${LINK[$CHOICE]}"
    fi
}


FUNC_BACK_FROM_PATHS() {
    # Back to path above
    PATH_OF_LINKS="${PATH_OF_LINKS%/*}"
    if [[ "$PATH_OF_LINKS" == '.' ]] ; then 
        PATH_OF_LINKS='./linki'
    fi
    DEBUG_1 "FUNC_BACK_FROM_PATHS : PATH_OF_LINKS updated"
    DEBUG_1 "FUNC_BACK_FROM_PATHS : PATH_OF_LINKS = $PATH_OF_LINKS"
    ## clear CHOICE array
    #CHOICE=()
}

#========{
FUNC_OPEN_PATHS() {
    ##  My files
    TITLE=(${PATH_OF_LINKS}/*)

    FUNCTION_select_option "${TITLE[@]}"
    CHOICE=$?
    
    if [[ "$BACK" == 1 ]] ; then
        FUNC_BACK_FROM_PATHS
    else
        FUNC_OPEN
    fi
}
#========}
#--------------------------------------------------------------------------




#[[ "$DEBUG_1" == "OFF" ]] && FUNC_SPLASH
while true ; do
   [[ "$DEBUG_1" == "OFF" ]] && clear
    DEBUG_1 "Start of the loop: while true"
    DEBUG_1 "PATH_OF_LINKS = $PATH_OF_LINKS"
    if [[ "$HELP_MENU" == "1" ]] ; then
        FUNC_HELP
        echo "Press spacebar to continue."
        read -rN 1
        HELP_MENU=0
    fi

    
    if [[ -d "$PATH_OF_LINKS" ]] ; then
        DEBUG_1 "$PATH_OF_LINKS is a directory"
        FUNC_OPEN_PATHS
        [[ "$EDIT_FILE" == "1" ]] && NOTE="  Error: Before press e key, You need open file to edit. " && EDIT_FILE=0
#        [[ "$MOVE_LINK" == "1" ]] && NOTE="  Error: Before press m key, You need select link in file. " && MOVE_LINK=0
        [[ "$DELETE_LINK" == "1" ]] && NOTE="  Error: Before press m key, You need select link in file. " && DELETE_LINK=0
        Remember_Title=""
    elif [[ -f "$PATH_OF_LINKS" ]]; then
        DEBUG_1 "$PATH_OF_LINKS is a file"
        FUNC_OPEN_LINK 
        [[ "$EDIT_FILE" == "1" ]] && FUNC_EDIT_FILE && EDIT_FILE=0
#        [[ "$MOVE_LINK" == "1" ]] && FUNC_MOVE_LINK && MOVE_LINK=0
        [[ "$DELETE_LINK" == "1" ]] && FUNC_DELETE_LINK && DELETE_LINK=0
    else
        DEBUG_1 "$PATH_OF_LINKS is not valid"
        exit 1
    fi


    if [[ "$OPEN_MC" == "1" ]] ; then
        OPEN_MC=0
        mc "$PATH_OF_SCRIPT"/linki/  "$PATH_OF_SCRIPT"/linki/
    fi


    if [[ "$SEARCH_WITH_GREP" == "1" ]] ; then
        SEARCH_WITH_GREP=0
        reset
        read -p "Write searched word with grep:  "  Searched_Word
        echo " "
        grep -rin --color "$Searched_Word" "$PATH_OF_SCRIPT"/linki/
        echo " "
        echo "Press spacebar to continue."
        read -rN 1
    fi

    if [[ "$FIND_IDENTICAL" == "1" ]] ; then
        FIND_IDENTICAL=0
        FUNC_FIND_IDENTICAL
        echo " "
        echo "Press spacebar to continue."
        read -rN 1
    fi

    ## reset back
    BACK=0
done

echo "Error: End of script."





