#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html


#===={
FUNC_EDIT_FILE() {
    DEBUG_1 "FUNC_EDIT_FILE: EDIT_FILE_PATH = $EDIT_FILE_PATH"
    xdg-open "$EDIT_FILE_PATH"
    EDIT_FILE_PATH=""
}
#====}

#====={
FUNC_HELP() {
    echo " "
    echo "Keyboard Shortcuts: "
    echo " "
    echo " esc = quit"
    echo " q   = quit"
    echo " "
    echo " up arrow    = Select option above from menu"
    echo " down arrow  = Select option below from menu"
    echo " right arrow = Confirm the selected option"
    echo " left arrow  = Go back a level higher"
    echo " "
#    echo " a = add line"
    echo " d = delete line"
    echo " e = edit file"
#    echo " g = grep  " 
    echo " h = help"
#    echo " i = import file (firefox plugin: Export Tabs URLs)"
#    echo " m = select line to move and next m + Enter select line to paste."
#    echo " x = find identical links.  "
    echo " "
}
#=====}

#===={
FUNC_MOVE_LINK() {
    #notify-send "Dinner ready!"
    DEBUG_1 "==== FUNC_MOVE_LINK ===={"
    if [[ "$MOVE_LINK_LOCK" == 1 ]] ; then
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_TITLE_FROM: $MOVE_TITLE_FROM"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_LINK_FROM: $MOVE_LINK_FROM"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_FROM_FILE: $MOVE_FROM_FILE"
        DEBUG_1 "====" 
        MOVE_TITLE_TO="${TITLE[$CHOICE]}"
        MOVE_LINK_TO="${LINK[$CHOICE]}"
        MOVE_TO_FILE="$PATH_OF_LINKS"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_TITLE_TO: $MOVE_TITLE_TO"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_LINK_TO: $MOVE_LINK_TO"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_TO_FILE: $MOVE_TO_FILE"
        MOVE_LINK_LOCK=0
        # create new file
        CREATE_NEW_FILE="" ; while read -r COL1 COL2 ; do
            CREATE_NEW_FILE=$(echo -e "${CREATE_NEW_FILE}\n${COL1} ${COL2}")
            if [[ "$MOVE_LINK_TO" == "$COL1" ]] ; then
                if [[ "$MOVE_TITLE_TO" == "$COL2" ]] ; then
                    CREATE_NEW_FILE=$(echo -e "${CREATE_NEW_FILE}\n${MOVE_LINK_FROM} ${MOVE_TITLE_FROM}")
                fi
            fi
        done < "$MOVE_TO_FILE"
        # remove empty line from new file
        CREATE_NEW_FILE=$(grep -v '^[[:space:]]*$' <<<  "$CREATE_NEW_FILE")
        # save to file
        echo "$CREATE_NEW_FILE" > "$MOVE_TO_FILE"
        # remove from old file
        echo "$(grep -v "$MOVE_LINK_FROM" "$MOVE_FROM_FILE")" > "$MOVE_FROM_FILE"
    else
        MOVE_TITLE_FROM="${TITLE[$CHOICE]}"
        MOVE_LINK_FROM="${LINK[$CHOICE]}"
        MOVE_FROM_FILE="$PATH_OF_LINKS"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_TITLE_FROM: $MOVE_TITLE_FROM"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_LINK_FROM: $MOVE_LINK_FROM"
        DEBUG_1 "FUNC_MOVE_LINK: MOVE_FROM_FILE: $MOVE_FROM_FILE"
        if [[ -z "$MOVE_TITLE_FROM" ]] ; then
            echo "Error: Selected link is empty = $MOVE_TITLE_FROM"
        else
            MOVE_LINK_LOCK=1
        fi
        NOTE="Selected move: $MOVE_FROM_FILE : $MOVE_TITLE_FROM"
    fi
    DEBUG_1 "FUNC_MOVE_LINK: MOVE_LINK_LOCK = $MOVE_LINK_LOCK"
    DEBUG_1 "==== FUNC_MOVE_LINK ====}"
}
#====}

#======{
FUNC_DELETE_LINK() {
        DELETE_TITLE_FROM="${TITLE[$CHOICE]}"
        DELETE_LINK_FROM="${LINK[$CHOICE]}"
        DELETE_FROM_FILE="$PATH_OF_LINKS"
        DEBUG_1 "FUNC_DELETE_LINK: DELETE_TITLE_FROM: $DELETE_TITLE_FROM"
        DEBUG_1 "FUNC_DELETE_LINK: DELETE_LINK_FROM: $DELETE_LINK_FROM"
        DEBUG_1 "FUNC_DELETE_LINK: DELETE_FROM_FILE: $DELETE_FROM_FILE"
        
        echo "Title: $DELETE_TITLE_FROM"
        echo "From file: $DELETE_FROM_FILE"
        echo "Do you want delete link? (y/n) "
        read -r -n1  yn

        case $yn in 
	        "y"|"Y") NOTE="ok, we will proceed"
                # remove from file
                echo "$(grep -v "$DELETE_LINK_FROM" "$DELETE_FROM_FILE")" > "$DELETE_FROM_FILE"
                NOTE="Deleted from file : $DELETE_FROM_FILE"$'\n'"Line: $DELETE_TITLE_FROM"
		    ;;
	        "n"|"N") NOTE="Deletion canceled."
		    ;;
	        *) NOTE="Invalid answer."
	        ;;
        esac
        



            
}
#======}

#============{
FUNC_OPEN_LINK() {
    # Clear array
    TITLE=()
    FUNC_INFO
    FUNC_SAVE_FILE_TO_ARRAYS 
#    echo "${TITLE[@]}"

    FUNCTION_select_option "${TITLE[@]}"
    CHOICE=$?
    # FUNC_BACK working only if you want back
    FUNC_BACK_FROM_FILE
    FUNC_OPEN
    
    if [[ "$OPEN_LINK" == "1" ]] ; then
    # avoid the bug from menu (FUNCTION_select_option)
    if [[ ! "$MOVE_LINK" == "1" ]] ; then
    if [[ ! "$DELETE_LINK" == "1" ]] ; then
        if [[ ! -z ${LINK[$CHOICE]} ]] ; then
            ##  Warning: We will remove errors from output of browser ( /dev/null )
            xdg-open "${LINK[$CHOICE]}" 2>/dev/null
            DEBUG_1 "FUNC_OPEN_LINK: xdg-open"
            DEBUG_1 "FUNC_OPEN_LINK: OPEN_LINK = $OPEN_LINK"
        fi
        # reset
        OPEN_LINK=0
    fi
    fi
    fi
}
#============}

#======{
FUNC_STATUS_CAPS_LOCK() {
    # Output: on / off
    STATUS_CAPS_LOCK=$(xset q | grep Caps | awk '{ print $4 }')
}
#======}
