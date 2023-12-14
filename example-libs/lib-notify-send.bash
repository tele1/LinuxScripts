#!/bin/bash


#=============================================================================={
##    Destiny:    To send the message with notify-send from root to user account.
##    Version="1" 
##    Date:       2023.12.01 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Try use in your own bash script: 
##                      source lib-detect-base-linux-distro.bash 
##                      source lib-notify-send.bash 
##                      Notify_Send 'title' 'text' 
#==============================================================================}


#============================================================================{
#---------------------------------------------------------{
# How it use:          Notify_Send "Topic:" "Your_Text"
# Example:             Notify_Send "Info:" "It's tea time."
# or for cron
# Example for Ubuntu:  Notify_Send "Info:" "It's tea time." "cron" "my_user_name"
# Example for Ubuntu:  Notify_Send "Info:" "It's tea time." "root" "my_user_name"

Notify_Send() {
    #   I can not  use " && \ " to split the line below, so I created variable 
    Send_Message() { notify-send "${1}" "${2}"  -u normal -t 999000 -i info ;}
    User_Name="$4"

    if [[ "$Base_Linux_Distro" == "Ubuntu" ]] ; then

        if [[ "$3" == "cron" ]] ; then
            ##  I added variables also for cron jobs from root
            export DISPLAY=:0.0 && export XAUTHORITY="/home/${User_Name}/.Xauthority" && Send_Message "${1}" "${2}"
        
        elif [[ "$3" == "root" ]] ; then
            # From root in terminal
            #export $(dbus-launch) && Send_Message "${1}" "${2}"
            Send_Message "${1}" "${2}"
        else
            Send_Message "${1}" "${2}"
        fi
        
    elif [[ "$Base_Linux_Distro" == "Arch" ]] ; then
        #   https://wiki.archlinux.org/title/Desktop_notifications#Bash
        sudo -u "$User_Name" DISPLAY=:0 DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus notify-send "${1}" "${2}"  -u normal -t 999000 -i info
        
    else
        echo "Warning:  notify-send may not work on your system."
        echo "I need your help / notification to improve this script."
        Send_Message "${1}" "${2}"
    fi
}
#---------------------------------------------------------}


#============================================================================}










