#!/bin/bash


function choose_from_menu() {
    local prompt="$1" outvar="$2"
    shift
    shift
    ## count = options + additional lines below
    local options=("$@")  count=$(( ${#options[@]} + 3 )) index=0 
    cur=0
    local esc=$(echo -en "\e") # cache ESC as test doesn't allow esc codes
    printf "$prompt\n"
    print_selected()   { echo -e " >\e[7m$opt\e[0m"; } # mark & highlight the current option

    
    while true ; do
        # clear window screen
        clear
        TOTAL_OF_OPTIONS="$((${#options[@]}+1))"
    
        # list all options (option list is zero-based)
        index=0 
        for opt in "${options[@]}" ; do
        
            if [ $index -eq $cur ]; then
                print_selected "$opt"

            # We will limit displaying lines to 10   
            else
                # At the beginning - Print up to 10 if selected is to 5
                if [ $index -le 10  ] && [ $cur -le 5 ] ; then
                    echo "$opt"
                    
                # At the end - Print up to 10 if ...
                elif  [ $cur -ge $(($TOTAL_OF_OPTIONS-7)) ] && [ $index -ge $(($TOTAL_OF_OPTIONS-12)) ] ; then
                    echo "$opt"
                else

                    LIMIT=5
                    limit_upper=$(($cur-$LIMIT))
                    limit_bellow=$(($cur+$LIMIT))
                    
                    
                    # limit upper to 5
                    if [ $index -ge $limit_upper ] && [ $index -lt $cur ] ; then
                        echo "$opt"
                        
                    # limit bellow to 5
                    elif [ $index -le $limit_bellow ] && [ $index -gt $cur ] ; then
                        echo "$opt"
                    fi    
                fi
            fi  
            index=$(( $index + 1 ))
        done
       
        
        echo " "
        echo  "-------------------"
        echo  "$(($cur+1))/ ${#options[@]}" #  current line number / total number of lines
        
        
        read -s -n3 key # wait for user to key in arrows or ENTER
        ## Info:
        ## key [a-z] + Enter is uncomfortable, you can try build 
        ## with function below " get_pressed_key "
        

        if [[ $key == $esc[A ]] ; then # up arrow
            cur=$(( $cur - 1 ))
            [ "$cur" -lt 0 ] && cur=0

        elif [[ $key == $esc[B ]] ; then # down arrow
            cur=$(( $cur + 1 ))
            [ "$cur" -ge ${#options[@]} ] && cur=$(( ${#options[@]} - 1 )) 
  
        elif [[ $key == "" ]] ; then # nothing, i.e the read delimiter - ENTER
            break
        fi
        
        echo -en "\e[${count}A" # go up to the beginning to re-render
    done
    
    # export the selection to the requested output variable
    printf -v $outvar "${options[$cur]}"
}

#=========================================
selections=($(seq 1 42))

choose_from_menu "Please make a choice4:" selected_choice "${selections[@]}"
echo "Selected choice: $selected_choice"
    
#=========================================

exit 0

#================={
    get_pressed_key() {
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

                            'a') key=add ;; 
                            'd') key=delete ;;
                            'e') key=edit_file ;;
                            'h') key=help_menu ;;

                            
                        esac
                        echo "$key"  ;}
#=================}
