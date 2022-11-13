#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html


#===={
FUNC_IMPORT_BOOKMARKS_HTML() {

    Errors=0
    if [[ -z "$2" ]] ; then
        echo "Error: You must enter a path."
    elif [ ! -f "$2" ] ; then
        echo "Error: File not exist: $2"
    else
        COUNT=0 ; while  read -r COL1 ; do
        
            if [[ "$COUNT" == "0" ]] ; then
                if $(grep -q  '>Mozilla Firefox</H3>'$ <<< "$COL1")  ; then
                    COUNT=1 ; continue
                fi
            elif [[ "$COUNT" == "1" ]] ; then
                if $(grep -q  ^'<DT><H3 ' <<< "$COL1")  ; then
                    COUNT=2 ; continue
                fi
            fi
            
            if [[ "$COUNT" == "2" ]] ; then
                COL1=$(sed "s:\":\n:g" <<< "$COL1" | grep 'http\|^>' | grep -v favicon.ico)
                
                if [ -z "$COL1" ] ; then
                    continue
                fi
                
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
        done < "$2"
    fi
    
    if [[ "$Errors" == "0" ]] ; then
        echo " "
        echo "The bookmarks were imported successfully."
        echo " "
    fi
}


FUNC_IMPORT_TABS_URL() {
    if [[ -z "$2" ]] ; then
        echo "Error: You must enter a path."
        exit 1
    elif [ ! -f "$2" ] ; then
        echo "Error: File not exist: $2" 
        exit 1
    fi
    
    #========================================{
    ## Check if file contains bugs. We will use for it "$ROTATE" "$ROTATE_OLD"
    echo "Verification of file ..."
    ROTATE=0 ; while read -r L1 ; do
#       echo "$L1"
        ROTATE_OLD="$ROTATE"
        
        if [[ -z "$L1" ]] ; then
            ## Line is empty
            ROTATE=0
        else
            ## Line have link
            if grep -q ^"http" <<< "$L1" ; then
                 ROTATE=2
            else
            ## Line have something
                 ROTATE=1
            fi
        fi
        
        : " My Comment: My rules of logic
                
        One link creates three lines in the file:

        0 - empty line , interruption / pause
        1 - name of link
        2 - link

        Possible roads:

        0 | 1 | 1 | 2 | 2 | 0 | 1 | 2 | 0 | - this line contains previous value = "$ROTATE_OLD"
        1 | 0 | 2 | 1 | 0 | 2 | 1 | 2 | 0 | - this line contains new value = "$ROTATE"
        ==================================
        W | m | W | m | m | W | equal     
        D | Z | D | Z | D | Z | Z | Z | D |

        W=Bigger ; m=smaller
        D=good ; Z=wrong
        "

        if [ "$ROTATE" -lt "$ROTATE_OLD" ] ; then
            if [[ "$ROTATE" -eq "0" && "$ROTATE_OLD" -eq "2" ]] ; then
                VALUE=ok
            else
                echo "Error: Detected wrong value: $L1"
                exit 1
            fi
        elif [ "$ROTATE" -gt "$ROTATE_OLD" ] ; then
            if [[ "$ROTATE" -eq "2" && "$ROTATE_OLD" -eq "0" ]] ; then
                echo "Error: Detected wrong value: $L1"
                exit 1
            else
                VALUE=ok
            fi
        else
            # is -eq
            if [[ "$ROTATE" -eq "0" && "$ROTATE_OLD" -eq "0" ]] ; then
                VALUE=ok
            else
                echo "Error: Detected wrong value: $L1"
                exit 1
            fi
        fi

    done < "$2"
    #========================================}
    
    
    # Save links to tmp file
    echo "Importing links from file ..."
    while read -r L1 ; do

        if [[ ! -z "$L1" ]] ; then
            ## Line have link
            if grep -q ^"http" <<< "$L1" ; then
                 LINK="$L1"
                 echo "$LINK \"$TITLE\"" >> ./linki/tmp
            else
            ## Line have something
                 TITLE="$L1"
            fi
        fi
        
    done < "$2"
    
        echo " "
        echo "The bookmarks were imported successfully."
        echo " "
}
#====}
