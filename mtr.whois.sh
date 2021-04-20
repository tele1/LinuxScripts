#!/bin/bash


# Developed for Linux
# License: GNU GPL v.3
# Version 1
# Destiny: Script for use "mtr" + "whois"
# Script usage: bash script name.freedns.com


[ -z "$1" ] && { echo "No address was given www" ; exit 1 ;}


###########################}
# Check Dependecies - List created automatically by find.bash.dep.sh version=7 source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P awk) ]] && DEP="$DEP"$'\n'"awk"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P mtr) ]] && DEP="$DEP"$'\n'"mtr"
[[ -z $(type -P sed) ]] && DEP="$DEP"$'\n'"sed"
[[ -z $(type -P tail) ]] && DEP="$DEP"$'\n'"tail"
[[ -z $(type -P wc) ]] && DEP="$DEP"$'\n'"wc"
[[ -z $(type -P whois) ]] && DEP="$DEP"$'\n'"whois"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
###########################}


# Kolory
NC='\e[0m'    # Reset Color
BL='\e[0;36m' # Cyan ECHO
GN='\e[0;32m' # Green ECHO
YW='\e[0;33m' # Yellow ECHO
RD='\e[0;31m' # Red ECHO


    echo "mtr $1"
    # Raport rozciagniety, z adresem IP, testowany x razy | bez hostname
    RAPORT=$(mtr --report-wide --show-ips -c 10 "$1"  | sed "s/HOST: `hostname`/            /g")

    # Usuniecie pustych linii i policzenie
    #LICZBA_LINII_RAPORTU=$(grep "\S" <<< "$RAPORT" |  wc -l)

    OSTATNIA_LINIA=$(tail -n 1 <<< "$RAPORT")
    NR_LINII="0"

    ##for LINIA in `seq 1 $LICZBA_LINII_RAPORTU` ; do
    while read LINIA ; do
        #  Wyświetl linie na zielono
        echo -e "${GN}$LINIA${NC}"
        NR_LINII=$[$NR_LINII+1]
        
        # Poniżej 3 linii
        if [ "$NR_LINII" -gt "3" ] ; then
            WEB=$( awk '{ print $2 }' <<< "$LINIA")

            # Policzenie slow jako sposob czy podano IP
            LICZBA_SLOW=$(echo "$LINIA" | wc -w)
            if [ "$LICZBA_SLOW" -eq "10" ] ; then
                # Kolumna LOSS bez procentu i bez liczb dziesietnych
                LOSS=$(awk '{ print $4 }' <<< "$LINIA" | sed -e "s/%//g" -e "s/\.[0-9]//g")
            else
                LOSS=$(awk '{ print $3 }' <<< "$LINIA" | sed -e "s/%//g" -e "s/\.[0-9]//g")
            fi


            if [ "$LOSS" -lt "100" ] ; then
                # Alternatywa:  https://www.whois.com/whois/
                ##echo "Debug: $WEB = $LOSS"
                KONTAKT=$(whois -IHM "$WEB" | grep  "@\|contact")
                # Wyświetl kontakt w kolorze Cyan
                echo -e "${BL}${KONTAKT}${NC}"
            fi
        fi
    done <<< "$RAPORT"
