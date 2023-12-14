#!/bin/bash


#=============================================================================={
##    Destiny:  This will color your text message.
##    Version="1" 
##    Date:       2023.11.30 (Year.Month.Day) 
##    License:    GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
##    Source:     https://github.com/tele1/LinuxScripts
##    Script usage: Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                  source lib-1-basic-messages.bash
#==============================================================================}


#============================================================================{
##      https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
##      https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux
##      https://misc.flogisoft.com/bash/tip_colors_and_formatting

#-----------------------------------------------------{
##  Only for functions with 8/16 Colors
# Color list:

# Reset Color and Format
readonly Reset_Color='\e[0m'    

# Format
readonly Norma='0'
readonly Bold='1'
readonly Dim='2'
readonly Italic='3'
readonly Underlined='4'
readonly Blink_Slow='5'
readonly Blink_Fast='6'
readonly Reverse='7'
readonly Hidden='8'
readonly Strikethrough='9'

# Colors
readonly Black='30'
readonly Red='31'  
readonly Green='32' 
readonly Yellow='33' 
readonly Blue='34'  
readonly Magenta='35' 
readonly Cyan='36'  
readonly Light_Gray='37' 

readonly Dark_Gray='90' 
readonly Light_Red='91'
readonly Light_Green='92' 
readonly Light_Yellow='93'
readonly Light_Blue='94' 
readonly Light_Magenta='95'
readonly Light_Cyan='96'   
readonly White='97'       

# Background
readonly Bkgd_Black='40'
readonly Bkgd_Red='41'  
readonly Bkgd_Green='42' 
readonly Bkgd_Yellow='43' 
readonly Bkgd_Blue='44'  
readonly Bkgd_Magenta='45' 
readonly Bkgd_Cyan='46' 
readonly Bkgd_White='47' 

# Light Background
readonly Lt_Bkgd_Black='100'
readonly Lt_Bkgd_Red='101'  
readonly Lt_Bkgd_Green='102' 
readonly Lt_Bkgd_Yellow='103' 
readonly Lt_Bkgd_Blue='104'  
readonly Lt_Bkgd_Magenta='105' 
readonly Lt_Bkgd_Cyan='106' 
readonly Lt_Bkgd_White='107' 

#---------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Cl_Info "Your_Text"
F_Green_Info() {
    echo -e "\e[1;32m  Info: ${1} ${Reset_Color}"
}
#---------------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Cyan_Debug1 "your_script_name" "Additional_Information" 

F_Cyan_Debug1() {
    if [[ "$Debug1" == "ON" ]] ; then
        echo -e "\e[1;36m  DEBUG: ${1}: ${2} ${Reset_Color}"
    fi
}
#---------------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Blue_Debug2 "your_script_name" "Additional_Information" 

F_Blue_Debug2() {
    if [[ "$Debug2" == "ON" ]] ; then
        echo -e "\e[1;34m  DEBUG: ${1}: ${2} ${Reset_Color}"
    fi
}
#---------------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Yellow_Warning "Your_Text"
F_Yellow_Warning() {
    echo -e "\e[1;33m  Warning: ${1} ${Reset_Color}"
}
#---------------------------------------------------------}

#---------------------------------------------------------{
# Example:  F_Red_Error "your_script_name" "Your_Text"
F_Red_Error() {
    echo -e "\e[1;31m  Error: ${1}: ${2} ${Reset_Color}" 1>&2
    echo "  Exit." 1>&2
    exit 1
}
#---------------------------------------------------------}

#-----------------------------------------------------{
##  8/16 Colors
#   $1=Format $2=Color/Background/Light_Background $3=Text
#   For example:
#   F_8_Echo ${Italic} ${Green} "Hello World!"
#   or
#   F_8_Echo 3 32 "Hello World!"
F_8_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "3"
    echo -e "\e[${1};${2}m${3}${Reset_Color}"
}
#-----------------------------------------------------}

#-------------------------------------------------------{
##  8/16 Colors
# Mixed color text and Background
# Example:
# Blink 5 | Italic 3 | Green Text 32 | Yellow Background 43
# echo -e "\033[5;3;32;43m Text \e[0m"

# For example blink + italic + green text + yellow background:
#   F_Mix_Echo 5 3 32 43 "Your Text"
# or
#   F_Mix_Echo ${Blink_Slow} ${Italic} ${Green} ${Bkgd_Yellow} "Your Text"
F_Mix_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "5"
    echo -e "\e[${1};${2};${3};${4}m${5}${Reset_Color}"
}
#-------------------------------------------------------}

#---------------------------------------------------------{
# 8 bit / 0-255 Colors
# Color of Foreground (text): echo -e "\e[38;5;${Color}m ${Text} \e[0m"
# Color of Background:        echo -e "\e[48;5;${Color}m ${Text} \e[0m"

# Color of Foreground
#   For example yellow foreground:  F_255_Fd_Echo 220 "Hello World!"
F_255_Fd_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "2"
    echo -e "\e[38;5;${1}m${2}${Reset_Color}"
}

# Color of Background:
#   For example yellow background:  F_255_Bd_Echo 220 "Hello World!"
F_255_Bd_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "2"
    echo -e "\e[48;5;${1}m${2}${Reset_Color}"
}
#---------------------------------------------------------}

#-------------------------------------------------------------{
# 24 bit / 255*255*255 = 16.581.375 Colors
# Color=${R};${G};${B}
# Color of Foreground (text): echo -e "\e[38;2;${R};${G};${B}m ${Text} \e[0m"
# Color of Background:        echo -e "\e[48;2;${R};${G};${B}m ${Text} \e[0m"

# Color of Foreground
#   For example blue text:  F_RGB_Fd_Echo 0 128 220 "Text"
F_RGB_Fd_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "4"
    echo -e "\e[38;2;${1};${2};${3}m${4}${Reset_Color}"
}

# Color of Foreground
#   For example blue foreground:  F_RGB_Bd_Echo 0 128 220 "Text"
F_RGB_Bd_Echo() {
    F_Error_Arg "lib-colors.bash" "$#" "4"
    echo -e "\e[48;2;${1};${2};${3}m${4}${Reset_Color}"
}
#-------------------------------------------------------------}

#---------------------------------------------------------------{
##      This is useful when you are trying
##      to save text to a file, but without special characters - colors.
##      For example:   
##      F_Green_Echo "Some text." |  F_Reset_Color_From_Pipe > file.log
##      Other way is switch colors to off, if you use a switch.
F_Reset_Color_From_Pipe() {
    #sed 's/\x1B\[[0-9;]*[JKmsu]//g' "${1}"
    sed 's/\x1B\[[0-9;]*[JKmsu]//g' <<<"$(</dev/stdin)"
}
#---------------------------------------------------------------}

#============================================================================}


