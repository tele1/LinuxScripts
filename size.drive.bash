#!/usr/bin/env bash


##      Developed for Linux
##      License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
        VERSION='2'
##      Destiny: To compare partition size.
##      Script usage: bash script_name

##      Warning: This script from the output tries to separate only the "sd" words,
##              so not will work with "hd" names.
##      https://tldp.org/HOWTO/Partition-Mass-Storage-Definitions-Naming-HOWTO/x99.html


##  https://linuxhandbook.com/inode-linux/
##  https://tldp.org/HOWTO/Partition/recovering.html
##  https://www.kernel.org/doc/html/latest/block/stat.html


NC='\e[0m'    # Reset Color
GC='\e[0;32m' # Green ECHO

GREEN_ECHO()
{
	 echo -e "${GC}$@${NC}"  
}


CHECK() {
    SKIP=0
    # If app not installed and file not found and dir not found
    if [[ -z $(type -P "$1") ]] && [[ ! -f "$1" ]] && [[ ! -d "$1" ]]; then
        echo " "
        echo " Warning: not found and we skipped this: $1"
        echo " "
        SKIP=1
    else
        ##  Check if root is needed.
        if [[ "$2" == "root" ]] ; then
            if [[ "$EUID" -ne 0 ]] ; then
                echo " "
                echo " Warning: command need root and we skipped this: $1 "
                echo " "
                SKIP=1
            fi
        fi
    fi
    echo -----------------
}


#====================================================================


-lsblk() {
    CHECK lsblk
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO " lsblk (GiB)"
        lsblk -o NAME,FSTYPE,SIZE,FSUSED,MOUNTPOINT,LABEL | grep -v ^"loop"
    fi
}

#echo -----------------

-example() {
    CHECK lsblk
    if [[ "$SKIP" == 0 ]] ; then
        EXAMPLE=$(lsblk -bo NAME,SIZE | grep -v ^"loop" | grep "├─" | head -n1)
        echo "Example partitionin in B , GiB , GB:"
        echo "$EXAMPLE Bytes"
        BYTE=$( awk '{print $2}' <<< "$EXAMPLE" )
        NAME=$( awk '{print $1}' <<< "$EXAMPLE" )
        GiB="$(echo ""$BYTE"/1024/1024/1024" | bc -l | tr '.' ',')"
        GiB=$(printf "%.2f GiB \n" "$GiB")
        GB="$(echo ""$BYTE"/1000/1000/1000" | bc -l | tr '.' ',')"
        GB=$(printf "%.2f GB \n" "$GB")
        printf " %47s \n" "$GiB"
        printf " %47s \n" "$GB"
    fi
}

#echo -----------------

-procpart() {
    CHECK /proc/partitions
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  From /proc/partitions"
        echo "NAME SIZE"
        while read -r L1 L2 L3 L4 ; do
            if grep -q ^"sd" <<< "$L4" ; then
                P_GiB=$(echo "$L3 / 1024 / 1024" | bc -l | tr '.' ',')
                printf "$L4 %.2f GiB \n" $P_GiB
            fi
        done < /proc/partitions
    fi
}

#echo -----------------

-df() {
    CHECK df
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  From df (GiB)"
        GREEN_ECHO " Info: the size inside df may not be correct."
        df -Th | grep -v tmpfs
    fi
}

#echo -----------------

-sysblock() {
    CHECK /sys/block/
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  From /sys/block/"
        echo "NAME SIZE"
        while read -r L1 ; do
            #echo "$L1"
            while read -r L1L1 ; do
                #echo "$L1L1"
                S_GiB=$( echo "$(cat /sys/block/"$L1"/"$L1L1"/size) * 512 / 1024 / 1024 / 1024" | bc -l | tr '.' ',' )
                PARTNAME=$( grep -ri PARTNAME /sys/block/"$L1"/"$L1L1"/uevent | awk -F'=' '{print $2}' )
                printf "$L1L1 %.2f GiB $PARTNAME \n" "$S_GiB"
            done <<< $(ls /sys/block/"$L1" | grep ^"sd")
        done <<< $(ls /sys/block/ | grep ^"sd")
    fi
}

#echo -----------------

-blockdev() {
    CHECK blockdev root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  blockdev --report"
        while read -r L1 L2 L3 L4 L5 L6 L7 ; do
            if [[ "$L1" == RO ]] ; then
                printf  "%-7s %-7s %-7s %-7s %-14s %-16s %-7s %-7s \n" $L1 $L2 $L3 $L4 $L5 $L6 $L7
            elif grep -q "/dev/sd" <<<  "$L7" ; then
                ## Change size from Bytes to GiB
                L6=$( echo "$L6 / 1024 / 1024 / 1024" | bc -l | tr '.' ',')
                L6=$( printf "%.2f GiB" "$L6" )
                printf  "%-7s %-7s %-7s %-7s %-14s %-7s %-7s %-7s \n" $L1 $L2 $L3 $L4 $L5 $L6 $L7
            fi
        done <<< $(blockdev --report)
    fi
}

#echo -----------------

-parted() {
    CHECK parted root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  parted -l (GB)"
        parted -l
    fi
}

#echo -----------------


SHORT_OUTPUT() {
    NOT_PRINT_L=0 ; EMPTY_LINE=0 ; while read -r L1 ; do
        # If line empty
        if [ -z "$L1" ] ; then
            # Reset
            NOT_PRINT=0
            
            if [[ "$EMPTY_LINE" == 0 ]] ; then
                echo " "
            fi
            EMPTY_LINE=1     
        else
            if grep -q "/dev/" <<< "$L1" ; then
                if grep -q "/dev/sd" <<< "$L1" ; then
                    NOT_PRINT=0
                else
                    NOT_PRINT=1
                fi
            fi
        
            if [[ $NOT_PRINT == 0 ]] ; then 
                echo "$L1"
            fi
            
            EMPTY_LINE=0
        fi
    done <<< $($@)
}

-fdisk() {
    CHECK fdisk root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  fdisk -l (GiB)"
        SHORT_OUTPUT "fdisk -l"
    fi
}

#echo -----------------

-sfdisk() {
    CHECK sfdisk root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  sfdisk -l (GiB)"
        SHORT_OUTPUT "sfdisk -l"
    fi
}

#echo -----------------

READ_OUTPUT() {
    COMMAND="$@"
    if [ -f /proc/partitions ] ; then
        while read -r L1 L2 L3 L4 ; do
            OUTPUT=$($COMMAND /dev/"$L4")
            
            while read -r L1L1 ; do
                if grep -q "Block count:" <<< "$L1L1" ; then
                    B_COUNT=$( awk '{print $3}' <<< "$L1L1" )
                    
                elif grep -q "Block size:" <<< "$L1L1" ; then
                    B_SIZE=$( awk '{print $3}' <<< "$L1L1" )
                elif grep -q "Journal checksum:" <<< "$L1L1" ; then
                    break
                fi
            done <<< "$OUTPUT"
            
            echo " "
            echo "Name:  /dev/$L4"
            if [ ! -z "$B_COUNT" ] ; then
                BYTE=$(($B_COUNT * $B_SIZE))
                GiB="$(echo ""$BYTE"/1024/1024/1024" | bc -l | tr '.' ',')"
                GiB=$(printf "%.2f GiB \n" "$GiB")
                GB="$(echo ""$BYTE"/1000/1000/1000" | bc -l | tr '.' ',')"
                GB=$(printf "%.2f GB \n" "$GB")
                echo "------------------{"
                echo "SIZE (Byte) = Block count * Block size "
                echo "SIZE: $BYTE BYTES"
                echo "SIZE: $GiB GiB"
                echo "SIZE: $GB GB"
                echo "------------------}"
            fi
            
            unset OUTPUT
            unset B_COUNT
            unset B_SIZE
            echo " "
        done <<< $(grep sd /proc/partitions)
    else
        echo "  Warning: not found /proc/partitions "
        echo "  so We will skip test. "
    fi
}

-dumpe2fs() {
    CHECK dumpe2fs root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  dumpe2fs (GiB)"
        READ_OUTPUT "dumpe2fs" "-h"
    fi
}

#echo -----------------

-tune2fs() {
    CHECK tune2fs root
    if [[ "$SKIP" == 0 ]] ; then
        GREEN_ECHO "  tune2fs (GiB)"
        READ_OUTPUT "tune2fs" "-l"
    fi
}




##  Other tools:
##  gparted , gnome-disks , cfdisk

##========================================={
## Options
case $1 in
	"--help"|"-h")
	    echo " "
	    echo "                  No options = run all options."
	    echo " "
		echo " -o               Specify which commands to print."
		echo " "
		echo " Available commands with -o argument:"
	    echo "  -lsblk          Like lsblk command "
	    echo "  -example        Example with lsblk command "
	    echo "  -procpart       Like /proc/partitions file "
	    echo "  -df             Like df command, "
	    echo "                  the size inside df may not be correct."
	    echo "  -sysblock       Like /sys/block/ file "
	    echo "  -blockdev       Like blockdev command"
	    echo "  -parted         Like parted command"
	    echo "  -fdisk          Like fdisk command"
	    echo "  -sfdisk         Like sfdisk command"
	    echo "  -dumpe2fs       Like dumpe2fs command"
	    echo "  -tune2fs        Like tune2fs command"
    ;;
	"")
	    -lsblk ; -example ; -procpart ; -df ; -sysblock ; -blockdev
	    -parted ; -fdisk ; -sfdisk ; -dumpe2fs ; -tune2fs
	;;
	"-o")
	    ARGS="${*:2}"
	    for OPT in $ARGS ; do
	        "$OPT"
        done 
	;;
	"--version"|"-v")
		echo "Version = $VERSION"
		exit 0
	;; 
	*)
		echo "Unknown option."
		exit 1
	;;
esac


