#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html


#===={
FUNC_IMPORT_BOOKMARKS_HTML() {

#    Errors=0
    if [[ -z "$2" ]] ; then
        echo "Error: You must enter a path." 
        exit 1
    elif [ ! -f "$2" ] ; then
        echo "Error: File not exist: $2" 
        exit 1
    fi
    
    
    echo "Trying import file $2 ... " 
    echo " " 
    
        #============================================{
        FOLDER="" ; Degree=0 ; unset Folder_array ; COUNT=0 ; while  read -r COL1 ; do
        
#           echo "$COL1"

# <DT><A HREF="place:
#---------------------------------------{
# Example what we want parse from html file:
#   new Degree / Level:  <DL><p>
#   link + title: 	        <DT><A HREF="http://distrowatch.com" ADD_DATE="1417382567804000">DistroWatch.com</A>
#   but we don't want:      <DT><A HREF="place:
#   folder name:            <DT><H3 ADD_DATE="1514841527" LAST_MODIFIED="1521836884">Folder_name</H3>
#---------------------------------------}

            ## redundant condition for now: if [[ "$COUNT"
            if [[ "$COUNT" == "0" ]] ; then
            
                ##      if folder name
                if $(grep -q  '<DT><H3' <<< "$COL1")  ; then
                    #echo "$COL1"
                    
                    ## Default for firefox
                    if $(grep -q  'PERSONAL_TOOLBAR_FOLDER="true">' <<< "$COL1")  ; then
                        Ignore=yes
                    else
                        FOLDER=$(sed -e 's/<[^>]*>//g' <<< "$COL1")
                        
                            ## == This will remove space from name == {
                                FOLDER=$(tr ' ' '_' <<< "$FOLDER")
                            ## == This will remove space from name == }
                            
                            ## == This will remove carriage return from name == {
                            ##  https://en.wikipedia.org/wiki/Byte_order_mark
                            ##      echo "name name" | cat -v 
                            ##              name M-BM- name
                                FOLDER=$(sed  's/[^[:alnum:]_]/_/g' <<< "$FOLDER")
                            ## == This will remove carriage return from name == }
                            
                            ## I tried remove unnecessary degree
                            ## == Ignore name of folder == {
                                FOLDER="${FOLDER//Pasek_zakładek}"
                                FOLDER="${FOLDER//Menu_Zakładki}"
                                FOLDER="${FOLDER//menu}"
                                FOLDER="${FOLDER//toolbar}"
                                FOLDER="${FOLDER//Bookmarks_Toolbar}"
                                FOLDER="${FOLDER//Zakładki_z_urządzeń_przenośnych}"
                            ## == Ignore name of folder == }
                        
                        ## Save Folder name to Path in array    
                        Folder_array[$Degree]="$FOLDER"
                        
                        Part_Of_Path=$(tr ' ' '/' <<< "${Folder_array[*]}")
                        
                        ## if variable is empty
                        if [[ -z "$Part_Of_Path" ]] ; then
                            Part_Of_Path=/tmp
                        fi
                        
                        ## == Fix: add " / " if not exist == {
                            if [[ ! "${Part_Of_Path:0:1}" == "/" ]] ; then
                                Part_Of_Path="/${Part_Of_Path}"
                            fi
                        ## == Fix: add " / " if not exist == }
                        
                        echo "Part of Path = ${Part_Of_Path} "
                    fi
                
                ##  Degree / level where now "$FOLDER" is
                elif $(grep -q  '<DL><p>' <<< "$COL1")  ; then
                    Degree=$(("$Degree"+1))
                    #echo "Degree = $Degree"
                    
                ##  Degree / level where now "$FOLDER" is
                elif $(grep -q  '</DL><p>' <<< "$COL1")  ; then

                    ## Remove Folder name from array
                    unset Folder_array[$Degree]
                    
                    Degree=$(("$Degree"-1))
                    #echo "Degree = $Degree"
                
                ## if  link + title   
                elif $(grep -q  '<DT><A HREF=' <<< "$COL1")  ; then
                    ## Default for firefox
                    if $(grep -q  '<DT><A HREF="place:' <<< "$COL1")  ; then
                        Ignore=yes
                    else
                        LINK=$(grep -o  "HREF=.*"  <<< "$COL1" | awk '{print $1}' | sed -e 's/HREF="//g' -e 's/"$//g')
                        ##  It may contain spaces
                        TITLE=$(sed -e 's/<[^>]*>//g' <<< "$COL1")
                        
                        
                        #echo "$LINK \"$TITLE\""
                        # echo " ./linki/${Part_Of_Path} : Link \"Title\""
                        
                        
                        ## == Save ================================================{
                        
                        ## if variable is empty
                        if [[ -z "$Part_Of_Path" ]] ; then
                            Part_Of_Path=/tmp
                            
                        ##  if folder exist = move to new folder
                        elif [[ -d "./linki${Part_Of_Path}" ]] ; then
                            Part_Of_Path="${Part_Of_Path}/tmp"
                            ## done by default below
                            
                        else
                            ## Create tree of folders ( instead mkdir -p )
                            #==========================================={
                            PARTS=$(tr '/' '\n' <<< "$Part_Of_Path")
                            COUNTS_2=$(wc -l <<< "$PARTS")
                            #echo "PARTS ~~ $Part_Of_Path"
                            
                            
                            MPath2="" ; COUNT_2=0 ; while read -r LINE_2 ; do

                                COUNT_2=$(("$COUNT_2" + 1))

                                ## If equal then this is file
                                if [[ "$COUNT_2" == "$COUNTS_2" ]] ; then
                                    #echo "END = file = $LINE_2"
                                    Ignore=yes
                                
                                ## If not equal this is folder
                                else
                                    #echo "$LINE_2"
                                    
                                    if [[ ! -z "$LINE_2" ]] ; then 
                                        ## with each loop adding a new folder to the path
                                        MPath2="${MPath2}/${LINE_2}"
                                        #echo  "MPath2 = $MPath2"
                                        
                                        #==================================={
                                        ## if folder exist = ignore
                                        if [[ -d "./linki${MPath2}" ]] ; then
                                            Ignore=yes
                                        ## if file exist = move to new folder
                                        elif [[ -f "./linki${MPath2}" ]] ; then
                                            mv "./linki${MPath2}" "./linki${MPath2}.tmp"
                                            mkdir -v "./linki${MPath2}" ; TEST="$?"
                                                if [[ ! "$TEST" == "0" ]] ; then
                                                    echo "Error when we tried created folder:" 
                                                    echo "MPath2 = ${MPath2}" ; exit 1
                                                fi
                                            mv "./linki${MPath2}.tmp" "./linki${MPath2}"
                                        ## there is no folder and file = create folder
                                        else
                                            mkdir -v "./linki${MPath2}" ; TEST="$?"
                                                if [[ ! "$TEST" == "0" ]] ; then
                                                    echo "Error when we tried created folder:" 
                                                    echo "MPath2 = ${MPath2}" ; exit 1
                                                fi
                                        fi
                                        #===================================}
                                    fi 
                                fi
                            done <<< "$PARTS"
                            #===========================================} 
                            
                            
                            
                        fi
                        #--------------------------

 
                        ##  if file exist = the file will be overwritten
                        

                        ## Save to file
                        echo "$LINK \"$TITLE\"" >> ./linki${Part_Of_Path} ; TEST="$?"
                            if [[ ! "$TEST" == "0" ]] ; then
                                echo "Error when we tried save links to file." 
                                    if [[ -d "./linki${Part_Of_Path}" ]] ; then
                                        echo "  This is folder."
                                    elif [[ -f "./linki${Part_Of_Path}" ]] ; then
                                        echo "  This is file."
                                    fi
                                echo "Path = ./linki${Part_Of_Path}" ; 
                                exit 1
                            fi
                        ## == Save ================================================}
                        
                    fi
                fi
            fi
        done < "$2"
        #============================================}
    
    if [[ ! "$Degree" == "0" ]] ; then
        echo " "
        echo "  Error: Degree in script is not equal 0. Degree = $Degree"
        echo "      This means that the sum of the searched lines is an odd number."
        echo "      So the imported html file is probably corrupted. Or this script can not find."
        echo "      We tried force import. Finished."
        echo " "
    elif [[ -z "$LINK" ]] ; then
        echo " "
        echo "  Error: I suspect the file was not imported. Try check link to html file."
        echo " "
    else
        echo " "
        echo "  The bookmarks were imported successfully."
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
