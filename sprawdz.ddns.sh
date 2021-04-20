#!/bin/bash


# Developed for Linux
# License: GNU GPL v.3
# Version 1
# Destiny: Script for check DDNS
# Script usage: bash script name.freedns.com


# Check Dependecies
# List created automatically by find.bash.dep.sh version=7 source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P awk) ]] && DEP="$DEP"$'\n'"awk"
[[ -z $(type -P dig) ]] && DEP="$DEP"$'\n'"dig"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P grep) ]] && DEP="$DEP"$'\n'"grep"
[[ -z $(type -P mtr) ]] && DEP="$DEP"$'\n'"mtr"
[[ -z $(type -P ping) ]] && DEP="$DEP"$'\n'"ping"
[[ -z $(type -P printf) ]] && DEP="$DEP"$'\n'"printf"
[[ -z $(type -P sed) ]] && DEP="$DEP"$'\n'"sed"
[[ -z $(type -P tail) ]] && DEP="$DEP"$'\n'"tail"
[[ -z $(type -P wc) ]] && DEP="$DEP"$'\n'"wc"
[[ -z $(type -P whois) ]] && DEP="$DEP"$'\n'"whois"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}


[ -z "$1" ] && { echo "Nie podano adresu www" ; exit 1 ;}


# Wydobądź wszystkie adresy | wyświetl jesli 4 kolumna zawiera NS
LISTA_ADRESOW=$(dig +trace +dnssec "$1" |  awk '$4 ~ /NS$/' |  awk '{ print $5 }')


echo "LISTA_ADRESOW:"
echo "$LISTA_ADRESOW"
echo "==============="


while read WEB ; do
    echo "ping ${WEB}"
    # Pingowanie x10 strone | pokazanie tylko liczby utraconych pakietow
    LOSS=$(ping -c 10 "$WEB" | grep -oP '\d+(?=% packet loss)')

    if [[ ! $LOSS -eq "0" ]]; then
        printf "==>  ${WEB} = ${LOSS} %%\n"
        # Printf ma czasem problem i nie wiem czemu ": printf: `\': nieprawidłowy znak formatujący"
        # LISTA_NIEPRAWIDLOWOSCI=$(printf "${LISTA_NIEPRAWIDLOWOSCI}\n${WEB} ${LOSS} %%")
        LISTA_NIEPRAWIDLOWOSCI="$LISTA_NIEPRAWIDLOWOSCI"$'\n'"${WEB} ${LOSS} %"
    fi
done <<< "$LISTA_ADRESOW"


# Usuniecie pustej linii
LISTA_NIEPRAWIDLOWOSCI=$(grep -v -e '^$' <<< "$LISTA_NIEPRAWIDLOWOSCI")


echo "==============="
echo "LISTA_NIEPRAWIDLOWOSCI PING:"
echo "$LISTA_NIEPRAWIDLOWOSCI"


[ -z "$1" ] && { echo "Nie znaleziono wadliwego DNS" ; exit 0 ;}


# Wyswietlenie tylko pierwszej kolumny
LISTA_NIEPRAWIDLOWOSCI=$(awk '{ print $1 }' <<< "$LISTA_NIEPRAWIDLOWOSCI")

while read WEB ; do
    echo "=================="
    # Raport rozciagniety, z adresem IP, testowany x razy | bez hostname
    RAPORT=$(mtr --report-wide --show-ips -c 10 "$WEB"  | sed "s/HOST: `hostname`/            /g")

    # Usuniecie pustych linii i policzenie
    #LICZBA_LINII_RAPORTU=$(grep "\S" <<< "$RAPORT" |  wc -l)

    OSTATNIA_LINIA=$(tail -n 1 <<< "$RAPORT")
    NR_LINII="0"

    ##for LINIA in `seq 1 $LICZBA_LINII_RAPORTU` ; do
    while read LINIA ; do
        echo "$LINIA"
        NR_LINII=$[$NR_LINII+1]
        
        # Poniżej 3 linii
        if [ "$NR_LINII" -gt "3" ] ; then
            WEB=$( awk '{ print $2 }' <<< "$LINIA")

            # Policzenie slow jako sposob czy podano IP
            LICZBA_SLOW=$(echo "$LINIA" | wc -w)
            if [ "$LICZBA_SLOW" -eq "10" ] ; then
                LOSS=$(awk '{ print $4 }' <<< "$LINIA" | sed "s/%//g")
            else
                LOSS=$(awk '{ print $3 }' <<< "$LINIA" | sed "s/%//g")
            fi


            if [[ "$LOSS" == "0.0" ]] ; then
                # Alternatywa:  https://www.whois.com/whois/
                ##echo "Debug: $WEB = $LOSS"
                whois -IHM "$WEB" | grep  "@\|contact"
            fi
        fi
    done <<< "$RAPORT"
    ##done

    echo "=================="
done <<< "$LISTA_NIEPRAWIDLOWOSCI"






