#!/bin/bash


# Developed for Linux
# License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
# Version 1
# Destiny: Network connection statistics 
# Script usage: bash script --help

##	LINKS:
##      https://serverfault.com/questions/192893/how-i-can-identify-which-process-is-making-udp-traffic-on-linux
#============================================================================{


case $1 in
	"--help"|"-h")
		echo "  The script was created to "
		echo " 1. Filter some information from the system log - audit"
		echo " 2. create an alternative tool for searching the system log - audit"
		echo " "
		echo " Options:"
		echo " "
		echo " --list | -l                        Show a list of audit logs."
		echo " "
		echo " --file | -f  file_name             Display the contents of a audit log."
		echo " "
		echo " --file-human | -fh file_name       The same as -f but unix time "
		echo "                                    is converted to UTC time -> more readable."
		echo " "
		echo " --file-short | -fs file_name       View condensed content of audit log."
		echo " "
		echo " --show-log | -sl                   It use ausearch app to display condensed of audit log."
		echo " "
		echo " --show-log-full-time | -sl-ft      The same as -sl but contains all time related entries."
		echo " "
		echo " --search | -s your_phrase          Search for the phrase in all audit logs."
		echo "                                    For example:"
		echo "                                    Each entry in audit log contains id number."
		echo "                                    2022/08/21 16:04:46:3013887) /usr/bin/lsof"
		echo "                                    3013887 = id"
		echo "                                    The -s option allows you to find specific lines."
		echo " "
		echo " Info:"
		echo " App audit needs a special entry to save internet connections"
		echo " For example line in file /etc/audit/rules.d/audit.rules" 
		echo ' -a exit,always -F arch=b64 -F a0=2 -F a1&=2 -S socket -k SOCKET '
		echo " You can test temporarily:"
		echo ' auditctl -a exit,always -F arch=b64 -F a0=2 -F a1\&=2 -S socket -k SOCKET'
		echo " "
		
	;;
	"--list"|"-l")
	    #ls /var/log/audit/
	    echo "FILE , TIME , SIZE"
	    stat -c "%n,%y,%s" /var/log/audit/* | sed -e 's/\.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] +[0-9][0-9][0-9][0-9]//g' | column -t -s,


	;;
	"--file"|"-f")
	    if [[ -z "$2" ]] ; then
	        echo "  You have to enter a file name" ; exit 1
		elif [[ -f "$(pwd)/${2}" ]] ; then
	        echo "1. File $(pwd) : ${2}"
	        cat "$(pwd)/${2}"
	    elif [[ -f "/var/log/audit/$2" ]] ; then
	        echo "2. File: /var/log/audit/$2"
	        cat /var/log/audit/"$2"
	    elif [[ -f "$2" ]] ; then
	    	echo "3. File: $2"
	    	cat "$2"
	    else
	        echo "Error: File not found: ${2}"
	    fi
	    
	    
	;;
	"--file-human"|"-fh")
	    
	    if [[ -z "$2" ]] ; then
	        echo "  You have to enter a file name" ; exit 1
	    elif [[ ! -f "/var/log/audit/$2"  ]] ; then
	        echo "Error: Enter only the filename instead $2"
	    else
	    
    while  read -r A B C D; do
        ALL=$(echo "$A $B $C $D")

        DATE=$(date '+%Y/%m/%d %H:%M:%S' -d @$(sed -e 's/msg=audit(\(.*\))/\1/' -e  's/:.*//g' <<< "$B"))        
        NR=$(awk -F ':' '{print $2}' <<< "$B")
        PART1=$(echo "$A $DATE $NR $C $D")
    #echo ----{
    #    echo "$ALL"
    #echo --- 
	    echo "$PART1"   
    #echo ----} 
    done <<< $( cat /var/log/audit/"$2" )
    
        fi


	;;
	"--file-short"|"-fs")
	
	    if [[ -z "$2" ]] ; then
	        echo "  You have to enter a file name" ; exit 1
	    elif [[ ! -f "/var/log/audit/$2"  ]] ; then
	        echo "Error: Enter only the filename instead $2"
	    else
	    
	        WITH_UNIX_TIME=$(awk -F= '/exe/{print $3 , $27}' /var/log/audit/"$2" | sed -e 's/audit(//g' -e 's/: arch//g'  -e 's/subj//g')
	    
	        while  read -r A B; do
	            #TIME=$(date '+%Y/%m/%d %H:%M:%S' -d @$(awk -F':' '{print $1}' <<< "$A"))
	        
	            while  IFS=":" read -r AA AB; do
	                TIME="$(date '+%Y/%m/%d %H:%M:%S' -d @"${AA}")"
	                LINE="$AB"
	            done <<< "$A"
	        
	            echo "${TIME}:${LINE} ${B}"
	    
	        done <<< "$WITH_UNIX_TIME"
	    
	    fi
	      
	;;
	"--show-log"|"-sl")
	
	    [[ -z $(type -P ausearch) ]] && { echo "Error: ausearch is not installed" ; exit 1 ;}
	
	##      sorted and unique every hour
	    echo "DATE , HOUR , PROCESS"
        echo "====================="
        ausearch -i  -k SOCKET | awk -F= '/exe/{print $3 , $27}' | \
        sed -e 's/audit(//g' -e 's/: arch//g' -e 's/:.*)//g' \
        | sort | uniq
        
	;;
	"--show-log-full-time"|"-sl-ft")
	
	    [[ -z $(type -P ausearch) ]] && { echo "Error: ausearch is not installed" ; exit 1 ;}
	
	    echo "DATE , HOUR , PROCESS"
        echo "====================="
        ausearch -i  -k SOCKET | awk -F= '/exe/{print $3 , $27}' | awk '{print $1 , $2 , $5}'
        
    ;;
	"--search"|"-s")
        grep --color -rin "$2" /var/log/audit/
        
	;;
	*)
		echo "Unknown option: $1"
		echo "	Try use: $0 --help"
	;; 
esac
