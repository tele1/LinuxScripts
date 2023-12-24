#!/bin/bash


# Licence: GNU GPL v3  https://www.gnu.org/licenses/gpl-3.0.html
  VERSION="1"
  SOURCE=""
# Destiny:      Script to show bandwidth
# Script use:	Name_of_script  -option  network_interface


###########################}
# Check Dependecies - List created automatically by find.bash.dep.sh version=8 
# source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P cat) ]] && DEP="$DEP"$'\n'"cat"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P expr) ]] && DEP="$DEP"$'\n'"expr"
[[ -z $(type -P sleep) ]] && DEP="$DEP"$'\n'"sleep"
[[ -z $(type -P true) ]] && DEP="$DEP"$'\n'"true"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
###########################}


HELP() {
	echo "Options:"
	echo "	-j		just print bandwidth"
	echo "	-l		in loop print bandwidth"
	echo "	-h		show this help"
}


JUST() {
        R1=`cat /sys/class/net/$1/statistics/rx_bytes`
        T1=`cat /sys/class/net/$1/statistics/tx_bytes`
        sleep 1
        R2=`cat /sys/class/net/$1/statistics/rx_bytes`
        T2=`cat /sys/class/net/$1/statistics/tx_bytes`
        TBPS=`expr $T2 - $T1`
        RBPS=`expr $R2 - $R1`

		#	https://en.wikipedia.org/wiki/Units_of_information
		#	**		The power operator
		DBYTE=$[ $RBPS / (1024**2) ]
		UBYTE=$[ $TBPS / (1024**2) ]
		DBIT=$[ $DBYTE * 8 ]
		UBIT=$[ $UBYTE * 8 ]
		echo -e " $1 Sent tx: $TBPS ; $UBYTE MiB/s ; $UBIT Mib/s \n $1 Rec. rx: $RBPS ; $DBYTE MiB/s ; $DBIT Mib/s "
}


LOOP() {
while true ; do
	JUST "$1"
done
}


if [ -z "$2" ]; then
        echo
        echo usage: $0 -option network-interface
        echo
        echo e.g. $0 -j eth0
        echo
		HELP
        exit
fi
 

case "$1" in
	"-j")
		JUST "$2"
	;;
	"-l")
		LOOP "$2"
	;;
	"-h"|"--help")
		HELP
	;;
	*)
		echo "	Error: unknown option $1"		
		echo "  "
		HELP
	;;
esac
