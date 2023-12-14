#!/bin/bash


#=============================================================================={
##    Destiny:   Alternative to "pstree -spa".
##    VERSION="1" 
##    Date:       2023.11.30 (Year.Month.Day) 
##    License:    GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
##    Source:     https://github.com/tele1/LinuxScripts
##    Script usage:    Try use in your own bash script: 
##                     source lib-pstree.bash
#==============================================================================}


#============================================================================{
PROC.OF.PSTREE_2() {
#		This is instead of command "pstree -spa" version 23.4
# Advantages:
#           This script returns an error if the PID number is invalid.
#           The newer version of pstree should already be corrected.

Ps_Tree=$(pstree -paAt)
PID="$1"

if [ -z "$Ps_Tree" ] ; then echo "Error: variable Ps_Tree is empty." ; exit 1 ; fi
if [ -z "$PID" ]     ; then echo "Error: variable PID is empty." ; exit 1 ; fi

#echo "=========="
#echo "PID = $PID"

# For Part Above of lines
KOLUMN=0 ;
OLD_NUMBER_CHARS=0
# For Part Below
BREAK=0

while IFS=',' read -r COLUMNS_AND_NAME  PID_AND_ARGUMENTS ; do

	LINE="${COLUMNS_AND_NAME} ${PID_AND_ARGUMENTS}"

	##	== Part Above of lines =={
	#	if first line ; then
	if [[ "$OLD_NUMBER_CHARS" -eq "0" ]] ; then
		OLD_NUMBER_CHARS="1" 
		TAB_ABOVE[$KOLUMN]="$LINE"
		F_Cyan_Debug1 " First line saved"
	elif [[ "$BREAK" == "0" ]] ; then
		# divide "$COLUMNS_AND_NAME"
		while IFS='-' read -r SOME_CHARS  PROCESS_NAME ; do
			NUMBER_CHARS="${#SOME_CHARS}"

			# For Debug
			F_Blue_Debug2 " "
			F_Blue_Debug2 '=========={'
			F_Blue_Debug2 "LINE:$LINE"
			F_Blue_Debug2 "NUMBER_CHARS = $NUMBER_CHARS ; OLD_NUMBER_CHARS = $OLD_NUMBER_CHARS"
		
			# if next tree
			if [[ "$NUMBER_CHARS" -gt "$OLD_NUMBER_CHARS" ]] ; then
				KOLUMN="$[$KOLUMN + 1]"
				TAB3[$KOLUMN]="$NUMBER_CHARS"  ;
				TAB_ABOVE[$KOLUMN]="$LINE"  ;
				F_Cyan_Debug1 " This line gt than saved ; Line saved to KOLUMN = $KOLUMN"
					#F_Blue_Debug2 "---- Tab Above ----"
					#printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}}"
					#F_Blue_Debug2 "-------------------"

			# if the same tree
			elif [[ "$NUMBER_CHARS" -eq "$OLD_NUMBER_CHARS" ]] ; then
				KOLUMN="$KOLUMN"
				TAB3[$KOLUMN]="$NUMBER_CHARS"
				TAB_ABOVE[$KOLUMN]="$LINE"  ;
				F_Cyan_Debug1 "	This line eq than saved ; Line saved to KOLUMN = $KOLUMN"
					#F_Blue_Debug2 "---- Tab Above ----"
					#printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}}"
					#F_Blue_Debug2 "-------------------"

			# if one of the earlier tree
			elif [[ "$NUMBER_CHARS" -lt "$OLD_NUMBER_CHARS" ]] ; then
				F_Cyan_Debug1 "	This line lt than saved "

				#$F_Blue_Debug2 "TAB3 before TAB3_NUMBER for loop: ${TAB3[@]}"
				#$F_Blue_Debug2 "We will remove lines earlier, bigger than "$NUMBER_CHARS""
				COUNT_LOCAL=1
				for TAB3_NUMBER in "${TAB3[@]}" ; do

					if   [[ "$NUMBER_CHARS" -eq "$TAB3_NUMBER" ]] ; then
						F_Cyan_Debug1 "	: "$NUMBER_CHARS" = "$TAB3_NUMBER". Line saved to KOLUMN "$COUNT_LOCAL". "
						KOLUMN="$COUNT_LOCAL"
						TAB3[$KOLUMN]="$NUMBER_CHARS"
						TAB_ABOVE[$KOLUMN]="$LINE" 

					elif [[ "$NUMBER_CHARS" -gt "$TAB3_NUMBER" ]] ; then
						F_Cyan_Debug1 "	: "$NUMBER_CHARS" > "$TAB3_NUMBER". KOLUMN "$COUNT_LOCAL" skipped. "

					elif [[ "$NUMBER_CHARS" -lt "$TAB3_NUMBER" ]] ; then
						F_Cyan_Debug1 "	: "$NUMBER_CHARS" < "$TAB3_NUMBER".  KOLUMN "$COUNT_LOCAL" removed. "
						unset TAB3[$COUNT_LOCAL]
						unset TAB_ABOVE[$COUNT_LOCAL]
					fi

					COUNT_LOCAL=$[$COUNT_LOCAL + 1]
				done

				#F_Blue_Debug2 "---- Tab Above ----"
				#printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}}"
				#F_Blue_Debug2 "-------------------"
				#F_Blue_Debug2 "TAB3 after for loop: ${TAB3[@]}"
			fi

			OLD_NUMBER_CHARS="$NUMBER_CHARS"
		done <<< "$COLUMNS_AND_NAME"
	fi


	##	== Part Center of lines ==
	while IFS=' ' read -r PID_LINE OPTIONS ; do
		#echo "PID_LINE = $PID_LINE"
		if [[ "$PID_LINE" -eq "$PID" ]] ; then

					## For Debug
					#echo "===BEFORE 1 SET $COLUMNS_AND_NAME ; $CHARS ; $1 ================{"

			Part_Center="$LINE"
			BREAK=1
			IFS="-"; set $COLUMNS_AND_NAME ; CHARS="$1" ; SAVE_NUMBER_CHARS=${#CHARS}
			COUNT_PART_BELOW=0

					#echo "===AFTER 1 SET $COLUMNS_AND_NAME ; $CHARS ; $1 =================}"
			break
		fi
	done <<< "$PID_AND_ARGUMENTS"

	# Trick for Part Below
	if [[ "$BREAK" == "1" ]] ; then
		BREAK=2
		continue
	fi

	##	== Part Below of lines ==
	if [[ "$BREAK" == "2" ]] ; then

				# For Debug: tree signs have been replaced with the number of these characters
				#echo "===BEFORE 2 SET ${#COLUMNS_AND_NAME} ; ${#CHARS} ; ${#1} =========={" 
		##	Bash remember last while settings, so we restore the main settings 
		IFS="-"; set $COLUMNS_AND_NAME ; CHARS="$1" ; NUMBER_CHARS=${#CHARS}
				#echo "===AFTER 2 SET ${#COLUMNS_AND_NAME} ; ${#CHARS} ; ${#1}  ==========}" 

		# For Debug
		#echo "Part Below:"
		#echo "$LINE"
		#echo "CHARS=$CHARS"
		#echo " SAVE ; NEW = $SAVE_NUMBER_CHARS ; $NUMBER_CHARS"
		
		if [[ "$NUMBER_CHARS" -le "$SAVE_NUMBER_CHARS" ]] ;then
			#echo "Smaler or equal"
			break
		fi

		PART_BELOW[$COUNT_PART_BELOW]="$LINE"
		COUNT_PART_BELOW=$[$COUNT_PART_BELOW + 1]
		#echo "COUNT_PART_BELOW: ${COUNT_PART_BELOW[@]}"
	fi

	#echo "spam wwww"
done <<< "$Ps_Tree"
#
#echo "=========={"
#printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}-1}"
#echo "==========--"
#printf "%s\n" "${Part_Center}"
#echo "==========--"
#printf "%s\n" "${PART_BELOW[@]}"
#echo "==========}"

if [ ! -z "${Part_Center}" ] ; then
	if [[ "$TREE_FULL" == 1 ]] ; then
		Proc_Pstree_Out=$(printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}-1}" "${Part_Center}" "${PART_BELOW[@]}")
	else
		Proc_Pstree_Out=$(printf "%s\n" "${TAB_ABOVE[@]::${#TAB_ABOVE[@]}-1}" "${Part_Center}")
	fi

	##	DEBUG:
	#echo "== Proc_Pstree_Out =={"
	echo "$Proc_Pstree_Out"
	#echo "== Proc_Pstree_Out ==}"
fi

if [ -z "$Proc_Pstree_Out" ] ; then 
	echo "Error: variable Proc_Pstree_Out is empty. PID not found in side output of pstree command."
	echo "PID = $PID"
	exit 1
fi
}
#============================================================================}


