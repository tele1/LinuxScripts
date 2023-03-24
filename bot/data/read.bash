#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#======================================================{
FuncREAD() {
    # echo "$1 $2"

    #read -r -p "$1 $2"
    Prompt="$1"


    Func_get_cursor_column()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${COL#*[} ;}            
    Func_get_cursor_row()      { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[} ;}   
    Func_cursor_to_left()      { tput cup $(( $(Func_get_cursor_row) -1 )) $(( $(Func_get_cursor_column) -2 )) ;}   
    Func_cursor_to_right()     { tput cup $(( $(Func_get_cursor_row) -1 )) $(( $(Func_get_cursor_column) )) ;}   
    
    #-----------------------{
    Func_Number_of_columns() { echo $(( tput cols  - $Count_Prompt )) ;}
    ##      https://stackoverflow.com/questions/5723935/echoing-a-backspace
    ##      https://unix.stackexchange.com/questions/297502/clear-half-of-the-screen-from-the-command-line
    ## tput ed will remove text "from" to "end".
    Func_Clear_text() { tput ed ;}
    Func_History() {    if [[ -f "$Path_Of_Script"/data/memory/History.txt ]] ; then
                            if [[ -z "$Number_History" ]] ; then
                                Number_History=1
                            fi                            
                            if [[ "$1" == "up" ]] ; then
                                Number_History=$(( "$Number_History" + 1 ))
                                Word=$(sed -n "$Number_History"p "$Path_Of_Script"/data/memory/History.txt  | tr -d '\n')
                                    if [[ -z "$Word" ]] ; then
                                        Number_History=$(( "$Number_History" - 1 ))
                                        Word=$(sed -n "$Number_History"p "$Path_Of_Script"/data/memory/History.txt  | tr -d '\n')
                                    fi
                                echo -n "${Word}"
                            elif [[ "$1" == "down" ]] ;then
                                Number_History=$(( "$Number_History" - 1 ))
                                [[ "$Number_History" == "0" ]] && Number_History=1
                                Word=$(sed -n "$Number_History"p "$Path_Of_Script"/data/memory/History.txt  | tr -d '\n')
                                echo -n "${Word}"
                            fi
                        else
                            echo -n "File History not exist: $Path_Of_Script"
                        fi  ;}

    Func_up()   {  tput cup $Starting_cursor_position ; Func_Clear_text ; Func_History up    ;}
    Func_down() {  tput cup $Starting_cursor_position ; Func_Clear_text ; Func_History down  ;}
    #-----------------------}
    Func_Backspace()    { 
        
        ## Word Fragment Length = Current Location - promt
        ## Characters are counted from 0
        ## The function is stored in a variable because I can't measure with "echo" because the cursor will already be on a new line
        Current_Column=$(( $(Func_get_cursor_column) -1 ))
#           echo $Current_Column                               # For Debug
#           echo $(( "$Count_Prompt" - 1 ))                    # For Debug
#           echo $(( $Current_Column - "$Count_Prompt" ))      # For Debug
        ## Word_Column = Char to remove
        Word_Column=$(( $Current_Column - "$Count_Prompt" ))
        Word=$( fold -w1 <<< "${Word}" | sed ${Word_Column}d | tr -d "\n" )
        ## How Backspace working
        tput cup $Starting_cursor_position ; Func_Clear_text ; echo -n "${Word}" ; tput cup "$(( $(Func_get_cursor_row) -1 ))" $(( "$Current_Column" -1 ))
     }

    
    
    Func_get_pressed_key() {

                        IFS= read -sn1 -p "$Prompt" key  

                        read -sn1 -t 0.0001 k1 
                        read -sn1 -t 0.0001 k2
                        read -sn1 -t 0.0001 k3
                        key+="$k1$k2$k3"

                        case $key in
                        
                            ##    TIP: Put command in terminal to get key number
                            ##          showkey -a 
                    
#                            $'\x1b') key=quit ;;    ## "esc"   key  - may be useful in other script
#                            $'\x71') key=quit ;;    ## "q"     key  - may be useful in other script
                            "")      key=enter ;;
                            $'\177') key=backspace ;;

                            $'\x1b\x5b\x41') key=up ;;
                            $'\x1b\x5b\x42') key=down ;;
                            $'\x1b\x5b\x44') key=left ;;
                            $'\x1b\x5b\x43') key=right ;;
                            
                        esac

                        echo "$key"  ;}
                        
                        
                        
#----------------------------------------------------------------{                       
    Word=""
    Prompt_VALUE=0 ; 
    while true; do
    
        ## For Func_up Func_down
        if [[ "$Prompt_VALUE" == "0" ]] ; then
            Count_Prompt=$(( $(echo -n "$Prompt" | wc -c) - 11 ))
            #echo $Count_Prompt
            Starting_cursor_position="$(( $(Func_get_cursor_row) -1 )) $(( $(Func_get_cursor_column) -1 + "$Count_Prompt" ))"  
            ##  for Func_Backspace
            Starting_column_position=$(Func_get_cursor_column)
        fi  

    
    
        #----------------------------
        # user key control
        Key=$(Func_get_pressed_key)

        case  "${Key}" in
            up)   Func_up    ;;
            down) Func_down  ;;
            right) Func_cursor_to_right  ;; # Forward
            left)  Func_cursor_to_left   ;; # Backward
            enter) printf "\n%s" "${Word}" >> "$Path_Of_Script"/data/memory/History.txt ; break  ;;
            backspace)  Func_Backspace ;;
            *) printf "%s" "${Key}" ; Word="${Word}${Key}"  ;;
        esac
        #----------------------------
        
        if [[ "$Prompt_VALUE" == "0" ]] ; then
            Prompt=""
            Prompt_VALUE=1
        fi
        
    done
#----------------------------------------------------------------}
}
#======================================================}




