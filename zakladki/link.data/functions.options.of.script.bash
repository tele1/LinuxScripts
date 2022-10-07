#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html


#===={
FUNC_IMPORT_BOOKMARKS_HTML() {
    Errors=0
    if [[ -z "$2" ]] ; then
        echo "Error: You must enter a path."
    fi
    
    IF_EXIST=$(readlink -e "$2")
    if [ -z "$IF_EXIST" ] ; then
        echo "Error: Path not exist: $2"
    else
        RESET=0 ; while  read -r COL1 ; do
            if [[ '>Pasek zakładek</H3>' == "$COL1" ]] ; then
                RESET=1 ; continue
            fi
            if [[ "$RESET" == "1" ]] ; then
                echo $COL1
                ## If line have http at begin
                if grep -q ^"http" <<< "$COL1" ; then
                    LINK="$COL1"

                ## If line have </A> at end
                elif grep -q $'</A>' <<< "$COL1" ; then
                    TITLE=$(sed -e 's/<[^>]*>//g' -e 's/^>//g' <<< "$COL1")
                    echo "$LINK \"$TITLE\"" >> ./linki/"$FOLDER"
                    
                ## If line this is name of folder
                elif grep -q $'</H3>' <<< "$COL1" ; then
                    FOLDER=$(sed -e 's/<[^>]*>//g' -e 's/^>//g' <<< "$COL1")

                else
                    echo "Error: Line not identified"
                    echo "$COL1"
                    Errors=1 
                fi
            fi
        done <<< $(sed "s:\":\n:g" $2 | grep 'http\|^>' | grep -v favicon.ico)
    fi
    
    if [[ "$Errors" == "0" ]] ; then
        echo " "
        echo "The bookmarks were imported successfully."
        echo " "
    fi
}
#====}
