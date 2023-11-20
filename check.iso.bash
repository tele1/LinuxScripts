#!/bin/bash


###############################################################################{
# Description: It allows you to automatically check the iso file with the hash file 
#              and displays the USB stick 
#              and displays a ready command to copy the ISO file to the USB stick.
# Destiny: 
#          For more comfortable check ISO
#
	VERSION="2"
#	Licence:	GNU GPL v3
    SOURCE="https://github.com/tele1/LinuxScripts"
# 	Script use:
#               First, download the ISO file and hash file from the Internet
#               and move it to an empty folder.
#               Warning: You can check only 1 ISO file.
#               then use command:
#                   bash check.iso.bash -p $HOME/YourPath
#
###############################################################################}

###########################{
# Check Dependecies - List created automatically by find.bash.dep.sh version=8 
# source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P awk) ]] && DEP="$DEP"$'\n'"awk"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P find) ]] && DEP="$DEP"$'\n'"find"
[[ -z $(type -P grep) ]] && DEP="$DEP"$'\n'"grep"
[[ -z $(type -P ls) ]] && DEP="$DEP"$'\n'"ls"
[[ -z $(type -P lsblk) ]] && DEP="$DEP"$'\n'"lsblk"
[[ -z $(type -P realpath) ]] && DEP="$DEP"$'\n'"realpath"
[[ -z $(type -P tee) ]] && DEP="$DEP"$'\n'"tee"
[[ -z $(type -P tty) ]] && DEP="$DEP"$'\n'"tty"
[[ -z $(type -P yad) ]] && DEP="$DEP"$'\n'"yad"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
###########################}


#   Useful links:
#   https://dug.net.pl/tekst/241/weryfikacja_sum_kontrolnych_nagranego_obrazu__iso/
#   https://wiki.manjaro.org/index.php/Burn_an_ISO_File
#   https://linuxexplore.com/2013/01/01/how-to-find-usb-device-in-linux/
#   http://smokey01.com/yad/

###################{
#   Default User Interface
Gui=on
###################}

#   Colors
#-------------------------{
NC='\e[0m'    # Reset Color
GN='\e[0;32m' # Green ECHO

Func_GREEN_ECHO() {
    if [[ ! "$Gui" == "on" ]] ; then
        echo -e "${GN}${1}${NC}"
    else
        echo "${1}"
    fi
}
#-------------------------}

##  Relative Path needed for read other files from other place
Relativ_Path="$(dirname "$(realpath $0)")"

#-------------------------------{
Func_Question1() {
    echo "Do you want check checksum?"
    echo "You have 5 seconds to answer: y/n "
    read -r -t6 -n1 Answer1
    echo "  "
    if [[ "$Answer1" == y ]] || [[ "$Answer1" == "" ]] ; then
        echo "Checksum Verification:"
        $1
    else
        echo "Verification canceled."
    fi
}
#-------------------------------}

#---------------{
Func_Switch() {
    cd $Folder_Selected
    ##  If is set $Option2 then change $Option2 to $Option1 for Func_Switch
    if [[ ! -z "$Option2" ]] ; then
        Option1="$Option2"
    fi
    case "$Option1" in
        ignore)
        ;;
        ask) Func_Question1 "$1" 
        ;;
        *)
            echo "Checksum Verification:"
            $1
        ;;
    esac
}
#---------------}


#-----------------------------------------------{
Func_Terminal_Output() {

Func_GREEN_ECHO "1/2 File checking in: $Relativ_Path"

for File in $(find "$Folder_Selected" -type f | sed 's|^\./||') ; do
#    echo " "
    Extension=$(awk -F'.' '{print $NF}' <<< "$File")
    case "$Extension" in
    'iso') echo "File iso = $File"
#           Iso_File="$File"
           Iso_File="$Iso_File"$'\n'"$File"
    ;;
    'md5'|'md5sum') echo "File md5 = $File"
        Func_Switch "md5sum -c $File"
    ;;
    'sha1'|'sha1sum') echo "File sha1 = $File"
        Func_Switch "sha1sum -c $File"
    ;;
    'sha256'|'sha256sum') echo "File sha256 = $File"
        Func_Switch "sha256sum -c $File"
    ;;
    'sha512'|'sha512sum') echo "File sha512 = $File"
        Func_Switch "sha512sum -c $File"
    ;;
#    *)  1>&2 echo "Unknown file = $File" ;;


    *)  UnknowFiles="$UnknowFiles"$'\n'"Unknown file = $File"
#        echo "Unknown file = $File"
    ;;
    esac
done

Count_U_Files=$(grep "\S" <<< "$UnknowFiles" | wc -l)
    if [[ ! -z "$Count_U_Files" ]] ;then
        echo "Unknown files: $Count_U_Files"
    fi

Count_Iso_Files=$(grep "\S" <<< "$Iso_File" | wc -l)
    if [[ -z "$Count_Iso_Files" ]] ; then
        echo "Error: Not found any ISO file." ; exit 1
    elif [[ "$Count_Iso_Files" -gt "1" ]] ; then
        echo "Error: Too many ISO files: $Count_Iso_Files" ; exit 1
    fi

echo " "
echo "--------------------------------------"
Func_GREEN_ECHO "2/2 USB mass storage devices detected:"

ListDevices1=$(find /sys/bus/usb/drivers/usb-storage/[1-9]-[0-1]\:1.0/ 2> /dev/null)

Get_Status1=$?
    if [[ ! "$Get_Status1" == 0 ]] ; then
        echo "Info: USB storage not found."
        exit 0
    fi
    
ListDevices2=$( grep -wo sd\[a-z] <<< "$ListDevices1" | uniq )
    if [[ -z "$ListDevices2" ]]; then
        echo 'Info: USB storage sd[a-z] not found'
        exit 0
    fi

while read -r Column_1 ; do
    echo " "
    echo "/dev/$Column_1 , lsblk info:"
    lsblk /dev/"$Column_1" -o NAME,FSTYPE,FSUSE%,MOUNTPOINT,LABEL,PATH,FSVER
    echo " "
    Iso_Size=$(ls -sh ${Iso_File} | awk '{print $1}')
    echo "ISO file size = $Iso_Size"
    echo " "
    Func_GREEN_ECHO "Command to copy ISO on usb storage:" 
    echo "pv ${Iso_File} | sudo dd of=/dev/${Column_1}"
    
done <<< "$ListDevices2"
}
#-----------------------------------------------}

# ===============================================


while (($#)) ; do

    case "$1" in
	"--help"|"-h")
	    echo "Available options:"
	    echo "--help | -h       = Show this help."
	    echo "--ask  | -a       = Ask when is verification (md5-sha)."
	    echo "                      Verify a Linux ISO's Checksum is enabled by default"
	    echo "                      You cannot use arguments -a and -i at the same time"
	    echo "--ignore  | -i    = Ignore verification (md5-sha)."
	    echo "--gui  | -g       = Graphical user interface."
	    echo "--term | -t       = Terminal user interface."	     	     
	    echo "--path | -p       = Path to dir with files (iso, md5-sha)."
	    echo "                      Useful if the command is run in a different"
	    echo "                      place than the files are located"
	    echo " "
	    echo "Example:"
	    echo "  $0 -p  $HOME/Downloads"
	    exit 0
	;;
	"--ask"|"-a")
        Option1=ask
	;;
	"--ignore"|"-i")
        Option2=ignore
	;;
	"--gui"|"-g")
	    Gui=on
	;;
	"--term"|"-t")
	    Gui=off
	;;
    "--path"|"-p")
	    Folder_Selected="$2"
            if [ ! -d "$Folder_Selected" ]; then
                echo "Folder not exist: $Folder_Selected"
                exit
            fi
            
    shift
	;;
	*)  echo "  Error: Wrong argument: $1 "  
	    echo "  Try use: $0 --help"; exit ;;
	esac
	
	shift
done

# Set default path
if [ -z "$Folder_Selected" ]; then
    Folder_Selected="$(pwd)"
fi
                
##   For debug
#echo "Option1=$Option1 , Gui=$Gui , Folder_Selected=$Folder_Selected"
#exit

if [[ "$Option1" == ask ]] && [[ "$Option2" == ignore ]]; then
    echo "Error: You cannot use arguments -a and -i at the same time."
    echo "  This means that you cannot both ask and ignore hash file verification."
    exit 1
fi


## Switch bitween terminal and GUI
if [[ "$Gui" == on ]] ; then

    Yad_Output1=$(yad --fixed --center --title="$0" --image="dialog-information" \
    --text="Welcome in $0 bash script! \n Please enter your details:" --align=center \
    --form --field="Select path with .iso and hash file:DIR" "$Folder_Selected" \
    --field="You can select if you want ignore verification (md5-sha).:CHK"  FALSE \
    --field=" ":LBL --field="Click the OK button and wait a while for output in window.":LBL \
    --button=gtk-ok:0 --button=gtk-cancel:1 --buttons-layout=center)
    GET_ERROR="$?"
        if [[ "$GET_ERROR" == 1 ]] ; then
            echo "Info: Yad window was closed." ; exit
        fi
    
    # Info:
    # In yad --field is empty with --button=gtk-ok:1 
    # because 1 is reserved for "Cancel" which have empty output"
     
    Folder_Selected=$(awk -F '|' '{print $1}' <<< "$Yad_Output1")
    ReBuildOption1=$( awk -F '|' '{print $2}' <<< "$Yad_Output1")
        if [[ "$ReBuildOption1" == "TRUE" ]] ; then
            Option1="ignore"
        else
            Option1=""
        fi
    # Edit variables


    Text_GUI=$(Func_Terminal_Output | tee /dev/tty)
    
    ##  Info:
    ##  Do not use &, because using this line will clear Text_GUI variable
    ##  Because yad commands / windows can use &
    #& timeout 2 yad --center --title="$0" --text="Wait a moment." --button=gtk-ok:0

    Text_GUI="Output:"'\n'"$Text_GUI"
    yad --fixed --center --title="$0" --selectable-labels --text="$Text_GUI" \
    --buttons-layout=center --button=gtk-ok:0

else
    Func_Terminal_Output
fi


