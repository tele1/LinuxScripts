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

##  Doc.
##  https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html

    Func_GetPos() {
                                IFS=';' read -sdR -p $'\E[6n' ROW COL
                                
                                # When the script runs slower than the keyboard, "read" returns invalid values
                                # So I used "if" to detect number
                                if ! [[ "${ROW#*[}" =~ ^[0-9]+$ ]] ; then
                                    Row="$Row" 
                                else
                                    Row=$(( ${ROW#*[} -1 )) 
                                fi
                                      
                                Col=$(( ${COL#*[} -1 ))
    }
    
    Func_Hide()  {
                                #------------------{
                                ## THIS IS FOR HIDING DEFECTS like ^[[C when script is slower
                                # move to begin
                                tput cup "$Row" "$Count_Prompt" 
                                # clear line
                                tput ed
                                # Print variable again
                                #printf "%s" "$Word"
                                echo -n "$Word"
                                #tput cup "$Row" "$Col"
                                #------------------}
    }

    Func_cursor_to_left()  { 
                                Func_GetPos ; 
                                # The column must be a positive number. ( greater than -1 )
                                # Otherwise, "tput" will return an error
                                if [[ "Col" -gt 0  ]] ; then
                                    Func_Hide
                                    
                                    # Option with time
                                    # If Clear screen is not enough to remove ^[[C 
                                    # and You can not move to left, you can try
                                    # move faster than number of  ^[[C  characters
#                                    End_Time=$(echo "$(date +%s%N) - $Start_Time" | bc)
                                                        
#                                    # move according to changes
#                                    if [[ "$End_Time" -gt "127233244" ]] ; then 

                                        # move to left
                                        tput cup "$Row" "$(( $Col - 1 ))" 
                                        
#                                    else
#                                        # The column must be a positive number. ( greater than -1 )
#                                        # Otherwise, "tput" will return an error
#                                       if [[ "Col" -gt 20  ]] ; then
#                                           tput cup "$Row" "$(( $Col - 20 ))"
#                                            echo "$Old_Col $Col"
#                                        fi
#                                    fi
                                fi 
    }

    Func_cursor_to_right() { Func_GetPos ; Func_Hide ; tput cup "$Row" "$(( $Col + 1 ))" ;}
    
    #-----------------------{
    ## tput ed will remove text "from" to "end".
    Func_Clear_text() { tput ed ;}
    Func_History() {    
                        if [[ -f "$Path_Of_Script"/data/memory/History.txt ]] ; then
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
                                # It may not be possible to read the content from the screen
                                # But you can,
                                # 1. Save each letter you typed into a variable,
                                # 2. Edit a variable
                                Func_GetPos
                                Char_Pos=$(( "${Col}" - "$Count_Prompt" ))
                                Word=$( fold -w1 <<< "${Word}" | sed ${Char_Pos}d | tr -d "\n" )
                                # 3. Move cursor to the beginning
                                tput cup "$Row" "$Count_Prompt" ; 
                                # 4. Clear the screen
                                tput ed ;
                                # 5. Print the variable again
                                echo -n "${Word}" ;
                                # 6. Move cursor one to the left
                                tput cup "$Row" $(( "$Col" -1 ))
     }

    Func_Any_Other_Character()    {
                                Func_GetPos
                                # Count Word Col
                                Word_Col=$(( "$Col" - "$Count_Prompt" ))
                                # First part
                                P1_Word=${Word::$Word_Col}
                                # Rest
                                P2_Word=${Word:$Word_Col}
                                # Whole Word
                                Word="${P1_Word}${Key1}${P2_Word}" 
                                #  Move cursor to the beginning
                                tput cup "$Row" "$Count_Prompt"
                                #  Clear the screen from cursor to end
                                tput ed ; 
                                #  Print
                                printf "%s" "${Word}" ;
                                #  Move Cursor
                                tput cup "$Row" "$(($Col + 1))"                     
    }                    
                        
#----------------------------------------------------------------{                       
    Word=""
    Prompt_VALUE=0 ; 
    while true; do
    
        ## For Func_up Func_down
        if [[ "$Prompt_VALUE" == "0" ]] ; then
            Count_Prompt=$(( $(echo -n "$Prompt" | wc -c) - 11 ))
            Func_GetPos 
            Starting_cursor_position="$Row $(( $Col + "$Count_Prompt" ))"  
        fi  

    
        #----------------------------
        # user key control
        # " read -N " istead n because here for "n" spacebar = Enter key .
        read -rsN1 -p "$Prompt" Key1

        case "${Key1}" in
            $'\x1b')    # Handle ESC sequence.
       
                read -rsn1 -t 1 Key2
                if [[ "$Key2" == "[" ]]; then
                    read -rsn1 -t 0.1 Key3
                    case "$Key3" in   
                        "A") Func_up ;;
                        "B") Func_down ;;
                        "C") Func_cursor_to_right ;; # Forward
                        "D") Func_cursor_to_left  ;; # Backward
                    esac
#                else
#                    echo "$Key2"
                fi
                
                # Probably the sequence for the Fx keys should be flush.
                # I won't do it, because flushing creates redundant characters when I hold down the key.
                # Flush "stdin" with 0.1  sec timeout.    
#               read -rsn5 -t 0.1
            ;;    
            
            # Other one byte (char) cases.
            # command:  showkey -a
            
            # Enter = LF from ASCII = showkey is not helpful here / 12 = LF in Oct 
            $'\12') printf "\n%s" "${Word}" >> "$Path_Of_Script"/data/memory/History.txt ; break  ;;
            
            # Backspace
            $'\177')  Func_Backspace ;;

            # Spacebar - I added this because with "read -N" not worked / with "read -n" spacebar = Enter
            $'\40')   Func_Any_Other_Character  ;;

            # Any other key
            *)        Func_Any_Other_Character  ;;
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




