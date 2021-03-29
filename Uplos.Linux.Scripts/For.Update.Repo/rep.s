#!/bin/bash

# Developed for UPLOS
# License: GNU GPL v.3
# Destiny: For sort kde4, kde5, mate, xfce
# Version 1

# Warnig: This script is not perfect like rpm"


#########################
# Edit path to packages
#DOPACZEK=`pwd`/packages/
DOPACZEK=/UPLOS/32bit/RPMS.test/

# debugging, set: "on" or "off"
DEBUG0="off"

# "off" - create only log
# "on" - sort packages and create log ./s.log
#  set: "off" or "on" 
SORT0="off"
#########################

function DEBUG()
	{
		[ "$DEBUG0" == "on" ] &&  $@
	}

function SORT()
	{
		[ "$SORT0" == "on" ] &&  $@
	}

#-----------------------------------------{
# creating a list of packages
aa=$(ls "$DOPACZEK")

# counting folders
ab=$(ls "$DOPACZEK" | wc -l)
DEBUG echo "ab"


	# loop folders- count from 1 to $ab
	for i in `seq 1 $ab` 
	do
		# package name 
	    ac=$(awk 'NR=='$i <<< "$aa")
		DEBUG echo "$ac"

		# If error occurred
		rpm -qpv "${DOPACZEK}${ac}"
				if [[ "$?" -ne "0" ]]; then
					echo " --> Error: End because of error."
					echo " --> $ac is not rpm "
					exit 1
				fi

		# search qt4
		ad=$(rpm -qpR "${DOPACZEK}${ac}" | grep  ".*[qQ][tT].*4" | wc -l)
		DEBUG echo "$ad"

		# search qt5
		ae=$(rpm -qpR "${DOPACZEK}${ac}" | grep  ".*[qQ][tT].*5" | wc -l)
		DEBUG echo "$ae"

		# search mate
		af=$(rpm -qpi "${DOPACZEK}${ac}" | grep "Graphical desktop/Mate" | wc -l)
		DEBUG echo "$af"

		# search xfce
		ag=$(rpm -qpi "${DOPACZEK}${ac}" | grep "Graphical desktop/Xfce" | wc -l)
		DEBUG echo "$ag"

		echo "-------------------"
		date "+%H:%M:%S %d-%m-%Y" >> s.log
		echo "-------------------"

		#	MIX -	qt5 and qt4 inside
		if [[ "$ad" -gt "0" ]] && [[ "$ae" -gt "0" ]] ; then
			echo "MIX QT5/QT4 $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}MIX"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}MIX/"

		elif [[ "$ad" -gt "0" ]]; then
			echo "QT4 $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}QT4"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}QT4/"

		elif
			[[ "$ae" -gt "0" ]]; then
			echo "QT5 $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}QT5"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}QT5/"

		elif
			[[ "$af" -gt "0" ]]; then
			echo "Mate $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}Mate"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}Mate/"

		elif
			[[ "$ag" -gt "0" ]]; then
			echo "Xfce $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}Xfce"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}Xfce/"

		else 
			echo "Other $ac" >> s.log
			SORT mkdir -p "${DOPACZEK}Other"
			SORT mv -i "${DOPACZEK}${ac}" "${DOPACZEK}Other/"
		fi

	done
#-----------------------------------------}



