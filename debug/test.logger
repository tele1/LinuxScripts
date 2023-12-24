#!/bin/bash


# Licence:      GNU GPL v3
Version=2
# Script use:	bash  name_of_script
# Destiny:      Testing system logging with logger , systemd-cat.


#======================{
: << 'Longer_COMMENT'
Version=2
- Attempts were made to increase the speed of the script.
- Added more conditions to notify you if there are missing dependencies.
Longer_COMMENT
#======================{


NC='\e[0m'    # Reset Color
GC='\e[0;32m' # Green ECHO
RC='\e[0;31m' # Red Color

echo "-----------------------------------------------------"
echo "Test of message logging programs , version = $Version"
echo "-----------------------------------------------------"
echo " "


echo "========================================={"
echo "      Checking dependencies:"
echo " "

Func_STATUS() {
    if [[ "$2" == "1" ]] ; then
        echo -e "$1 = ${RC} Not installed ${NC}"
    elif [[ "$2" == "0" ]] ; then
        echo -e "$1 = ${GC} Installed ${NC}"
    else
        echo -e "   Error in the script: State or name unrecognized of variable = ${RC} $1 ${NC}"
    fi
}

##      0 = Installed
##      1 = Not installed

[[ ! -f "/var/log/syslog" ]]      && Syslog=1     || Syslog=0
[[ -z $(type -P journalctl) ]]    && Journalctl=1 || Journalctl=0

[[ -z $(type -P logger) ]]        && Logger=1     || Logger=0
[[ -z $(type -P "systemd-cat") ]] && SystemdCat=1 || SystemdCat=0

    Func_STATUS "/var/log/syslog" "$Syslog"
    Func_STATUS "journalctl" "$Journalctl"
    Func_STATUS "logger" "$Logger"
    Func_STATUS "systemd-cat" "$SystemdCat"

echo "=========================================}"
echo " "

#----------------------{
##      Info
if [[ "$Syslog" == "0" ]] ; then
    echo " "
    echo -e "${RC}      Info: ${NC}"
    echo -e "${GC}  Note that not all objects have to be in one /var/log/syslog log, ${NC}"
    echo -e "${GC}  some may be recorded in other system logs. ${NC}"
    echo " "
fi
#----------------------}


#==================================================================={
if [[ "$Logger" == "0" ]] ; then
    echo "Checking the command: logger"
    echo " "
    
##  Useful information:
##      man logger
##      Example:        logger -p auth.alert "Linux Mint test 1"
##      Example:        logger -p authpriv.alert "Linux Mint test 2"
##      You can find also on internet about logging, type in a search engine for example "Linux Logging Complete Guide"

Func_LOOP() {
    #  Example script rebuilded for Linux Mint Mate 20
    for K in {auth,authpriv,cron,daemon,ftp,kern,lpr,mail,news,syslog,user,uucp,local0,local1,local2,local3,local4,local5,local6,local7,security} ; do
    
        for L in {emerg,alert,crit,err,warning,notice,info,debug,panic,error,warn} ; do
        #        From " man logger " 
        #              kern       cannot be generated from userspace process, automatically converted to user
        #              security   deprecated synonym for auth
        
            Func_COMMAND 
        done
    done
}

#------------------------------------------------{
    echo "  Saving the message to the system log."
    
    ## test for Func_LOOP = for debug
#    Func_COMMAND() { echo "${K}.${L}" ;}

    Func_COMMAND() { logger -p $K.$L "Test logger message, facility $K priority $L" ;}
    
#           From " man logger " 
#              panic     deprecated synonym for emerg
#              error     deprecated synonym for err
#              warn      deprecated synonym for warning

    # Start Loop with above " Func_COMMAND "
    Func_LOOP
#------------------------------------------------}

#------------------{
    echo " "
    echo "  Pause for 2 seconds"
    echo " "
    sleep 2s
#------------------}

#-------------------------------{
    if [[ "$Syslog" == "0" ]] ; then
        
        echo " "
        echo "  Checking the /var/log/syslog log:"
        echo " "
        List_syslog="$(grep -i "Test logger message, facility" /var/log/syslog)"

        Func_COMMAND() {
            grep -q "Test logger message, facility $K priority $L" <<< "$List_syslog" ; Test="$?"
            Good_new="   logger /var/log/syslog ${GC}Supported: facility $K priority $L ${NC}"
            Bad_new="    logger /var/log/syslog ${RC}Not supported: facility $K priority $L ${NC}"
            
            [[ "$Test" == "0" ]] && echo -e "$Good_new" || echo -e "$Bad_new"
        }
        Func_LOOP
        
    else
        echo " "
        echo "  The file /var/log/syslog check was skipped."
        echo " "
    fi
#-------------------------------}

#-------------------------------{
    if  [[ "$Journalctl" == "0" ]] ; then
        echo " "
        echo " "
        echo "  Checking journalctl log: "
        echo " "
        
        ##  --since "1 hour ago" --> List limited to the last hour
        List_journalctl="$(journalctl --since "1 hour ago" | grep -i "Test logger message, facility")"

        Func_COMMAND() {
            grep -q "Test logger message, facility $K priority $L" <<< "$List_journalctl" ; Test="$?"
            Good_new="   logger journalctl ${GC}Supported: facility $K priority $L ${NC}"
            Bad_new="    logger journalctl ${RC}Not supported: facility $K priority $L ${NC}"
            
            [[ "$Test" == "0" ]] && echo -e "$Good_new" || echo -e "$Bad_new"
        }
        Func_LOOP
        
    else
        echo " "
        echo "  The journalctl log check was skipped."
        echo " "
    fi
#-------------------------------}
fi
#===================================================================}


#=================================================={
if [[ "$SystemdCat" == "0" ]] ; then
    echo " "
    echo " "
    echo "Checking the command: systemd-cat"
    echo " "
    
##  Useful information:
##      man systemd-cat
##      Example:     echo "example message" | systemd-cat -p notice
##      Example:     echo "example message" | systemd-cat -level-prefix=5
##      https://wiki.archlinux.org/index.php/Systemd/Journal
##      https://www.freedesktop.org/software/systemd/man/systemd-cat.html
    
    Func_LOOP() {
        ## for --level-prefix from " man systemd-cat "
        #for N in {0,1,2,3,4,5,6,7} ; do

        ## for --priority
        for N in {emerg,alert,crit,err,warning,notice,info,debug,panic,error,warn} ; do
            Func_COMMAND
        done
    }

#-------------------------------------------{
    echo "  Saving the message to the system log."
    Func_COMMAND() { 
        echo "Test systemd-cat message, priority $N" | systemd-cat  --priority="$N" ; Catch_Error="$?"
        [[ ! "$Catch_Error" == 0 ]] && echo "       Error while sending priority $N"
    }  
    Func_LOOP
    
    ##      Info:
    ##  If the priority name is not supported, you will get a message:    " Failed to parse priority value. "
    ##  Priority catching has been added to the script because the error message doesn't give enough information.
    ##  Bug: in systemd-cat (249.11-0ubuntu3.6) value " warn " working / supported, but you will see bug.
#-------------------------------------------{
    
#------------------{
    echo " "
    echo "  Pause for 2 seconds"
    echo " "
    sleep 2s
#------------------}

#----------------------------------{
    if [[ "$Syslog" == "0" ]] ; then
        echo " "
        echo "  Checking the /var/log/syslog log:"
        echo " "
        List_syslog="$(grep -i "Test systemd-cat message, priority" /var/log/syslog)"

        Func_COMMAND() {
            grep -q "Test systemd-cat message, priority $N" <<< "$List_syslog" ; Test="$?"
            Good_new="   systemd-cat /var/log/syslog ${GC}Supported: priority $N ${NC}"
            Bad_new="    systemd-cat /var/log/syslog ${RC}Not supported: priority $N ${NC}"
            
            [[ "$Test" == "0" ]] && echo -e "$Good_new" || echo -e "$Bad_new"
        }
        Func_LOOP
        
    else
        echo " "
        echo "  The file /var/log/syslog check was skipped."
        echo " "
    fi
#----------------------------------}


#---------------------------------------{
    if [[ "$Journalctl" == "0" ]] ; then
        echo " "
        echo "  Checking journalctl log:"
        echo " "
        
        ##  --since "1 hour ago" --> List limited to the last hour
        List_journalctl="$(journalctl --since "1 hour ago" | grep -i "Test systemd-cat message, priority")"
        
        Func_COMMAND() {
            grep -q "Test systemd-cat message, priority $N" <<< "$List_journalctl" ; Test="$?"
            Good_new="   systemd-cat journalctl ${GC}Supported: priority $N  ${NC}"
            Bad_new="    systemd-cat journalctl ${RC}Not supported: priority $N  ${NC}"
            
            [[ "$Test" == "0" ]] && echo -e "$Good_new" || echo -e "$Bad_new"
        }
        Func_LOOP
        
    else
        echo " "
        echo "  The journalctl log check was skipped."
        echo " "
    fi
#---------------------------------------}
fi
#==================================================}


