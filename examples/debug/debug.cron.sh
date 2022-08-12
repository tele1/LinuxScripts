#!/bin/bash


##      Developed for Linux
##      License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
        VERSION='1'
##      Destiny: To test if cron working and if notify-send working from cron
##      Script usage: bash script_name


##==================================={

##  Info:


## Edit " YOUR_NAME "  in line  38 ( " export XAUTHORITY=/home/YOUR_NAME/.Xauthority " )


## You can add two entries to cron
##      ***** first not working script >> /var/log/mydebug.cron.log 2>&1
##      ***** second debug script
## 
##  EXAMPLE Second cron entry / inscription 
##  * * * * *       bash /YOUR/PATH/TO/debug.cron.sh >> /var/log/mydebug.cron.log 2>&1
##
## You will get a notification every minute (notify-send) about error.
## To stop, edit cron ( for example with # -> "# code" ).


##  When file log    /var/log/mydebug.cron.log
##  will redundant / useless, You should remove it
##
##      rm /var/log/mydebug.cron.log


##===================================}


TIME=$(date +"%Y/%m/%d-%H:%M")
echo "$TIME" >> /var/log/mydebug.cron.log 2>&1


#   to display the message from notify-send
export DISPLAY=:0.0 
export XAUTHORITY=/home/YOUR_NAME/.Xauthority 

#   message
# 1000 = 1s
/usr/bin/notify-send -u normal -t 20000 -i "info" 'Boss !!' "Cron Debug 
log = /var/log/mydebug.cron.log
pwd = $(pwd) 
REAL_PATH = $(realpath $0)
id = $(id)
PID = $$

the process tree of this script :
$(pstree -ps $$)


mydebug.cron.log : 
$(cat /var/log/mydebug.cron.log)"









