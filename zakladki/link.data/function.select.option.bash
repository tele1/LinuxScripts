#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
# Destiny:      Function for create menu in terminal

#-----------------------------------------------------------------------
##  https://unix.stackexchange.com/questions/146570/arrow-key-enter-menu


# Renders a text based list of options that can be selected by the
# user using up, down and enter keys and returns the chosen option.
#
#   Arguments   : list of options, maximum of 256
#                 "opt1" "opt2" ...
#   Return value: selected index (0 for opt1, 1 for opt2 ...)
FUNCTION_select_option() {

    ESC=$( printf "\033")
    cursor_blink_on()  { printf "${ESC}[?25h"; }
    cursor_blink_off() { printf "${ESC}[?25l"; }
    cursor_to()        { printf "${ESC}[$1;${2:-1}H"; }
    print_option()     { printf "%s\n" "   $1 "; }
    print_selected()   { printf "%s\n" "  ${ESC}[7m $1 ${ESC}[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }            
    get_pressed_key()  {
                        IFS= read -sn1 key 2>/dev/null >&2

                        read -sn1 -t 0.0001 k1
                        read -sn1 -t 0.0001 k2
                        read -sn1 -t 0.0001 k3
                        key+="$k1$k2$k3"

                        case $key in
                        
                            ##    TIP: put command in terminal to get key number
                            ##    stdbuf -o0 showkey -a | cat -
                    
                            $'\x1b') key=quit ;;    # "esc" key
                            $'\x71') key=quit ;;    # "q" key

                            $'\x1b\x5b\x41') key=up ;;
                            $'\x1b\x5b\x42') key=down ;;
                            $'\x1b\x5b\x44') key=left ;;
                            $'\x1b\x5b\x43') key=right ;;

#                            'a') key=add ;; 
                            'd') key=delete ;;
                            'e') key=edit_file ;;
                            'g') key=grep_text ;; 
                            'h') key=help_menu ;;
#                           'i') key=import_html ;; 
                            'm') key=mc ;;
                            'x') key=find_identical ;; 
                            
                        esac
                        echo "$key"  ;}

    # initially print empty new lines (scroll down if at bottom of screen)
    # idx is for count TOTAL_OF_OPTIONS
    # opt here is declared automatically
    local idx=0
    for opt; do printf "\n"; ((idx++)) ; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    
#   causes problems when key is pressed longer and I don't know why
#    local startrow=$(("$lastrow" - "$#"))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
#    trap "cursor_blink_on; stty echo; printf '\n'; exit" 2
    cursor_blink_off


    if [[ $RemoveFromLinePath == 1 ]] ; then
        if [[ ! -z "$Line_Path" ]] ; then
            # Show last number
            selected=$( awk -F ';' '{print $NF}'  <<< "$Line_Path" )
        fi
    else
        local selected=0
    fi
    
    
    while true; do
        # Clear screen
        [[ "$DEBUG_1" == "OFF" ]] && clear
        
        TOTAL_OF_OPTIONS="$((${idx}+1))"
    
        # print options by overwriting the last lines
        local idx=0
        for opt; do

            if [ $idx -eq $selected ] ; then
                print_selected "$opt" ; 
                
                if grep -q ^"./linki" <<< "$opt"  ; then
                    File_Path="$opt"
                    Old_File_Path="$File_Path"
                else 
                    File_Path="$Old_File_Path"
                fi
                
            else
            # We will limit displaying lines for example to 12
                LIMIT=12
                HALF_OF_LIMIT=$(($LIMIT/2))  
            
                # At the beginning - Print up to 10 if selected is to 5
                if [ $idx -le $LIMIT  ] && [ $selected -le $HALF_OF_LIMIT ] ; then
                    print_option "$opt"
                    
                # At the end - Print up to 10 if ...
                elif  [ $selected -ge $(($TOTAL_OF_OPTIONS-$(($HALF_OF_LIMIT+2)))) ] && [ $idx -ge $(($TOTAL_OF_OPTIONS-$(($LIMIT+2)))) ] ; then
                    print_option "$opt"
                    
                else          
            
                    limit_upper=$(($selected-$HALF_OF_LIMIT))
                    limit_bellow=$(($selected+$HALF_OF_LIMIT))
                
                    # limit upper to 5
                    if [ $idx -ge $limit_upper ] && [ $idx -lt $selected ] ; then
                        print_option "$opt"
                        
                    # limit bellow to 5
                    elif [ $idx -le $limit_bellow ] && [ $idx -gt $selected ] ; then
                        print_option "$opt"
                    fi
                fi
            fi
            
            ((idx++))
        done
        
        ALL_OPTIONS="$idx"
        #---------------------------------------------------{
        echo " "
        echo  "-------------------"
        Selected_Line=$(($selected+1))
        echo  "  Line:    $Selected_Line / $ALL_OPTIONS"
        echo  "  File path: $File_Path "
        
        if [[ ! -z $Done_Line ]] ; then 
            Line_Path=$(tr -d " " <<< "${Old_Line_Path};${Done_Line}")
        fi 
           
        if [[ "$RemoveFromLinePath" == 1 ]] ; then
            RemoveFromLinePath=0
            # show all except last
            if [[ ! -z ${Old_Line_Path} ]] ; then
                Line_Path=$( awk 'BEGIN{FS=OFS=";"}{NF--; print}' <<< ${Old_Line_Path} )
            fi
        fi
        
        Old_Line_Path="$Line_Path"
        Done_Line=""
        ## This line for debug
        #echo  "  Line path: $Line_Path "
        #---------------------------------------------------}

        if [[ "$MOVE_LINK_LOCK" -eq 1 ]] ;then
            echo " "
            echo "$NOTE"
        else
            echo " "
            echo "$NOTE"
            NOTE=""
        fi

        
#       ----------------------------------------------
        # user key control
        case $(get_pressed_key) in
            quit) echo -e "\n Exitting..." ; exit 0 ;;
            
            up)    ((selected--)) ; if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi ;;
            down)  ((selected++)) ; if [ $selected -ge $# ]; then selected=0; fi ;;
            right)     OPEN_LINK=1 ; Done_Line=$selected ; break ;;  # Forward
            left)      BACK=1      ; RemoveFromLinePath="1" ; break ;;  # Backward
           
#            add) ADD=1 ; break ;;
            delete)  DELETE_LINK=1  ; break ;;
            edit_file) EDIT_FILE=1 ; BACK=1 ; break ;;
            grep_text) SEARCH_WITH_GREP=1 ; break ;;
            help_menu) HELP_MENU=1 ; BACK=1 ; break ;;
#            import_html) IMPORT_HTML=1 ; BACK=1 ; break ;;
            mc)        OPEN_MC=1 ; BACK=1 ; break ;;
            find_identical) FIND_IDENTICAL=1 ; break ;;

        esac
        

    done


#    sleep 0.1
    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}
