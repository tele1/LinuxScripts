#!/bin/bash


# Developed for Linux
# License: GNU GPL v.3
# Version 5
# Destiny: Script for check DDNS
# Script usage: bash script name.freedns.com


###########################}
# Check Dependecies - List created automatically by find.bash.dep.sh version=7 
# source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P awk) ]] && DEP="$DEP"$'\n'"awk"
[[ -z $(type -P dig) ]] && DEP="$DEP"$'\n'"dig"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P grep) ]] && DEP="$DEP"$'\n'"grep"
[[ -z $(type -P host) ]] && DEP="$DEP"$'\n'"host"
[[ -z $(type -P mtr) ]] && DEP="$DEP"$'\n'"mtr"
[[ -z $(type -P ping) ]] && DEP="$DEP"$'\n'"ping"
[[ -z $(type -P printf) ]] && DEP="$DEP"$'\n'"printf"
[[ -z $(type -P sed) ]] && DEP="$DEP"$'\n'"sed"
[[ -z $(type -P tail) ]] && DEP="$DEP"$'\n'"tail"
[[ -z $(type -P traceroute) ]] && DEP="$DEP"$'\n'"traceroute"
[[ -z $(type -P wc) ]] && DEP="$DEP"$'\n'"wc"
[[ -z $(type -P whois) ]] && DEP="$DEP"$'\n'"whois"

 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
###########################}



[ -z "$1" ] && { echo "No address www was given" ; exit 1 ;}


# Kolory
NC='\e[0m'    # Reset Color
BL='\e[0;36m' # Cyan ECHO
GN='\e[0;32m' # Green ECHO
YW='\e[0;33m' # Yellow ECHO
RD='\e[0;31m' # Red ECHO


PRINT_DIG_MTR_TRACE() {
# Wydobądź wszystkie adresy | wyświetl jesli 4 kolumna zawiera NS
LISTA_ADRESOW=$(dig +trace +dnssec "$1" |  awk '$4 ~ /NS$/' |  awk '{ print $5 }')


echo "LISTA_ADRESOW dig +trace +dnssec $1"
echo "$LISTA_ADRESOW"
echo "==============="


while read WEB ; do
    echo "ping ${WEB}"
    # Pingowanie x10 strone | pokazanie tylko liczby utraconych pakietow
    LOSS=$(ping -c 100 "$WEB" | grep -oP '\d+(?=% packet loss)')

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
    echo "mtr --report-wide --show-ips $WEB"
    # Raport rozciagniety, z adresem IP, testowany x razy | bez hostname
    RAPORT=$(mtr --report-wide --show-ips -c 100 "$WEB"  | sed "s/HOST: `hostname`/            /g")

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
    ##done
    echo "=================="
done <<< "$LISTA_NIEPRAWIDLOWOSCI"


while read WEB ; do
    echo "=================="
    #echo "traceroute $WEB"
    RAPORT_2=$(traceroute "$WEB")
    NR_LINII="0"
    while read LINIA ; do
        echo -e "${GN}$LINIA${NC}"
        NR_LINII=$[$NR_LINII+1]
        # Poniżej 3 linii
        if [ "$NR_LINII" -gt "3" ] ; then
            WEB=$(awk '{ print $2 }' <<< "$LINIA")
            if [[ ! "$WEB" == '*' ]] ;then
                KONTAKT=$(whois -IHM "$WEB" | grep  "@\|contact")
                # Wyświetl kontakt w kolorze Cyan
                echo -e "${BL}${KONTAKT}${NC}"  
            fi
        fi
    done <<< "$RAPORT_2"
    echo "=================="
done <<< "$LISTA_NIEPRAWIDLOWOSCI"
}


PRINT_HOST() {
echo "=================="
NR_LINII="0"
echo "host -t a $1 " 
while [ "$NR_LINII" -lt 20 ] ; do
    HOST_1=$(host -t a "$1")
    # Wynik host na zielono
    echo -e "${GN}${HOST_1}${NC}"
    NR_LINII=$[$NR_LINII+1]
done
echo "=================="
}


PRINT_DIGHOST() {
echo "=================="
NR_LINII="0"
echo 'dig $1 | grep  "ANSWER:"'
while [ "$NR_LINII" -lt 20 ] ; do
    HOST_1=$(dig $1 | grep  "ANSWER:")
    # Wynik host na zielono
    echo -e "${GN}${HOST_1}${NC}"
    NR_LINII=$[$NR_LINII+1]
done
echo "=================="
}


PRINT_DNS() {
LISTA_ADRESOW=$(dig +trace +dnssec "$1" |  awk '$4 ~ /NS$/' |  awk '{ print $5 }')
RESOLVCONF=$(grep -v '^#' /etc/resolv.conf | grep nameserver | awk '{print $2}')
for DNS in "$RESOLVCONF" "1.1.1.1" "8.8.8.8"  ; do

echo "Addresses which not give answer: dig @${DNS} +norec $WEB"
echo " + answer dig @${DNS} $WEB"
echo "======================={"
while read WEB ; do
    ODPOWIEDZ=$(dig @${DNS}  "$WEB" +norec | grep  "ANSWER:")
    #ODPOWIEDZ=$(dig "$WEB" +norec )

    ANSWER=$(  awk '{ print $8 }' <<< "$ODPOWIEDZ")
    if [[ $ANSWER == "0," ]] ; then
        echo -e "${GN} dig @${DNS} $WEB ${NC}"
        #echo -e "${GN} ${ODPOWIEDZ} ${NC}"
        ANSWER_2=$(dig @${DNS} $1 | grep  "ANSWER:" |   awk '{ print $8 , $9 }')
        echo -e "${BL} $ANSWER_2 ${NC}"
    fi
done <<< "$LISTA_ADRESOW"
echo "=======================}"

done
}


PRINT_TEST_DNS() {
LISTA_ADRESOW=$(dig +trace +dnssec "$1" |  awk '$4 ~ /NS$/' |  awk '{ print $5 }')
while read WEB ; do
    echo -e "$GN dig @$WEB $1 $NC"
    OUTPUT=$(dig @"$WEB" $1)
    STATUS=$(grep status <<< "$OUTPUT" |  awk '{ print $6 }')
    ANSWER=$(grep "ANSWER:" <<< "$OUTPUT" | awk -F',' '{ print $2 }')
    echo -e "$BL $STATUS , $ANSWER $NC"
done <<< "$LISTA_ADRESOW"
}


PRINT_FASTER() {
RESOLVCONF=$(grep -v '^#' /etc/resolv.conf | grep nameserver | awk '{print $2}')
for DNS in "$RESOLVCONF" "1.1.1.1" "8.8.8.8"  ; do
    echo "dig @${DNS} $1"
    dig @${DNS} $1 | grep "time"
done
}


case "$1" in
	"--help"|"-h")
		echo "---------------------------------------------------------"
		echo " Script for DNS testing. "
		echo " "
		echo " Usage:   $0 --option your_DDNS"
		echo " Usage:   $0 your_DDNS"
		echo " "
		echo " Options:"
		echo "                      No options --> Trace DDNS + whois --> main script task"
		echo "       --answer       Test answer with a few DNS"
		echo "       --digtest      Test dns or your server availability with dig commmand"
		echo "       --hosttest     Test dns or your server availability with host commmand"
		echo "       --fasterdns    Speed test with a few DNS"
		echo "   -h  --help         Show this help."
		echo "---------------------------------------------------------"
    ;;
    "--hosttest")
        [ -z "$2" ] && { echo "No address DNS was given" ; exit 1 ;}
        PRINT_HOST "$2"
    ;;
    "--digtest")
        [ -z "$2" ] && { echo "No address DNS was given" ; exit 1 ;}
        PRINT_DIGHOST "$2"
    ;;
    "--answer")
        [ -z "$2" ] && { echo "No address DNS was given" ; exit 1 ;}
        PRINT_DNS "$2"
    ;;
    "--testdns")
        [ -z "$2" ] && { echo "No address DNS was given" ; exit 1 ;}
        # Not working for debug DDNS = output is always the same
        PRINT_TEST_DNS "$2"
    ;;
    "--fasterdns")
        [ -z "$2" ] && { echo "No address DNS was given" ; exit 1 ;}
        PRINT_FASTER "$2"
    ;;
    *)
        [ ! -z "$2" ] && { echo "Option not found: $1" ; exit 1 ;}
        PRINT_DIG_MTR_TRACE "$1"
        PRINT_HOST "$1"
    ;;
esac


##  ==== interesting links ====
##  about EDNS
##  https://kb.isc.org/v1/docs/en/edns-compatibility-dig-queries
##  https://securitytrails.com/blog/dns-flag-day
##
##  Debugging nameservers
##  https://nsrc.org/wrc/workshops/2005/pre-SANOG-VI/bc/dns/dns2-02-dig-debug.html
##
##  Troubleshooting DNSSEC 
##  https://support.cloudflare.com/hc/en-us/articles/360021111972-Troubleshooting-DNSSEC
##
##  Using dig command
##  https://meterpreter.org/using-the-dig-command-to-query-dns-records-in-linux/
##  https://www.howtogeek.com/663056/how-to-use-the-dig-command-on-linux/
##  https://www.networkworld.com/article/3568488/digging-for-dns-answers-on-linux.html
##  https://phoenixnap.com/kb/linux-dig-command-examples





