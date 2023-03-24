#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


#======================================================{
FuncCursorPosition() {
##      https://stackoverflow.com/questions/2575037/how-to-get-the-cursor-position-in-bash
while true; do 
    xdotool getmouselocation
    ActiveWindowID=$(xdotool getactivewindow)
    echo "Active Window = $ActiveWindowID"
    FirefoxWindowID=$(xdotool search --sync --onlyvisible --class "firefox")
    echo "Firefox Window ID = $FirefoxWindowID"
    
##      Move window
#     xdotool windowmove $id 0 0
    read -r -t 1 -p "q + Enter = Exit  " Key
    
    if [[ "$Key" == q ]] ; then
        break
    fi
    
    clear; 
    
    
    
done

}
#======================================================}
