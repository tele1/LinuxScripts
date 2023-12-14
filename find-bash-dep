#! /bin/bash 

# Licence: GNU GPL v3  https://www.gnu.org/licenses/gpl-3.0.html
  VERSION="10"
  SOURCE="https://github.com/tele1/LinuxScripts"
# Destiny:      Script to find dependencies from *.bash and *.sh files
# Script use:	Name_of_script --check /path/to/next/script





####################################{
## == Check Dependecies ==
[[ -z $(type -P awk) ]] && DEP="$DEP"$'\n'"awk"
[[ -z $(type -P comm) ]] && DEP="$DEP"$'\n'"comm"
[[ -z $(type -P cut) ]] && DEP="$DEP"$'\n'"cut"
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P grep) ]] && DEP="$DEP"$'\n'"grep"
[[ -z $(type -P lsb_release) ]] && DEP="$DEP"$'\n'"lsb_release"
[[ -z $(type -P sed) ]] && DEP="$DEP"$'\n'"sed"
[[ -z $(type -P wc) ]] && DEP="$DEP"$'\n'"wc"

# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}

## == Check Dependecies ==
####################################}




####################################{
## == Message library ==

NC='\e[0m'    # Reset Color
BL='\e[0;36m' # Cyan ECHO
GN='\e[0;32m' # Green ECHO
YW='\e[0;33m' # Yellow ECHO
RD='\e[0;31m' # Red ECHO


#----------------{
MESSAGE_DEBUG() {
    #DEBUG="OFF / ON"
    DEBUG="OFF"
    if [[ "$DEBUG" == "ON" ]] ; then
        echo -e "${BL}  DEBUG: $1 ${NC}"
    fi
}
#----------------}


MESSAGE_INFO() {
    #echo "----"
    echo -e "${GN}  INFO: $1 ${NC}"
    #echo "----"
}


MESSAGE_WARNING() {
    # Print text in red and redirect to error
	echo -e "${YW}  WARNING: $* ${NC}" 1>&2
    #; exit 1
}


MESSAGE_ERROR() {
    # Print text in red and redirect to error
	echo -e "${RD}  ERROR: $* ${NC}" 1>&2
    #; exit 1
}

## 
####################################}




CHECK_ARG() {
########################{
## == System settings ==

NAME_LINUX=$(lsb_release -is)
MESSAGE_DEBUG "--> Linux distribution name: $NAME_LINUX"

case "$NAME_LINUX" in
"UPLOS")
	FIND_PACKAGE="rpm -qf"   # find package name from path 
	FIND_SOURCE="rpm -qi"    # show info about package 
	;;
"Linuxmint")
	FIND_PACKAGE="dpkg -S"   # find package name from path 
	FIND_SOURCE="dpkg-query -s"    # show info about package 
    #   Example
    #   command:    dpkg-query -s ncurses-bin | grep -i source
    #               Source: ncurses
    #   command:    dpkg -s ncurses-bin | grep -i source
    #               Source: ncurses
    ;;
"Ubuntu")
	FIND_PACKAGE="dpkg -S"   # find package name from path 
	FIND_SOURCE="dpkg-query -s"    # show info about package 
    ;;
*)
    # Arch Linux
	#FIND_PACKAGE="pacman -Qo"

    MESSAGE_ERROR "Sorry, I don't have enough information about your system to develop this script."
    MESSAGE_INFO "You can send me output \" lsb_release -is \" , how find package name from path ,how show info about package "
    exit 1
    ;;
esac

## == System settings ==
########################}


##################################{
## == Reject invalid arguments  ==

MESSAGE_DEBUG "Used arguments = $1"

##  Remove first word "--check" (skip first field and print the rest)
FILES=$(awk '{ $1="" ; print}' <<< "$1")
    MESSAGE_DEBUG "FILES = $FILES"

if [[ $(echo "$FILES" | wc -w) -lt "1" ]] ; then
    MESSAGE_ERROR "The number of arguments given is less than 1  = $FILES" ; exit 1
fi
for NAME_SCRIPT in $FILES ; do
    if [ ! -f "$NAME_SCRIPT" ]                                                              ; then
        MESSAGE_ERROR "We can't find file: ${NAME_SCRIPT}"     ; exit 1
    elif ! grep -q "text" <(file "$NAME_SCRIPT")                                            ; then
        MESSAGE_ERROR "This is not text file: $NAME_SCRIPT"    ; exit 1
    elif ! grep -q  "/bin/bash\|/bin/sh\|/usr/bin/env sh\|/usr/bin/env bash" "$NAME_SCRIPT" ; then
        MESSAGE_ERROR "This is not shell script: $NAME_SCRIPT" ; exit 1
    fi
done

## == Reject invalid arguments  ==
##################################}


#########################################{
## == List of all available commands   ==

# All available commands in the system except reserved
# dictionary: https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html
# compgen  https://bash.cyberciti.biz/bash-reference-manual/Programmable-Completion-Builtins.html#index-compgen-367
#
# From all available commands remove aliasses
LIST_1=$(comm  -23 <(compgen -c | sort) <(compgen -a | sort))
# From LIST_1 remove functions
LIST_2=$(comm  -23 <(echo "$LIST_1" | sort) <(compgen -A function | sort))
# From LIST_2 remove shell reserved
LIST_3=$(comm  -23 <(echo "$LIST_2" | sort) <(compgen -k | sort))
# From LIST_3 remove shell builtin commands and "[" and repeat
LIST_4=$(comm  -23 <(echo "$LIST_3" | sort) <(compgen -b | sort) | grep -v '\[' | uniq)
#   MESSAGE_DEBUG "List commands = $LIST_4"

## == List of all available commands   ==
#########################################}


################################################################{
## == Test if script has commands from the list of commands   ==

for NAME_SCRIPT in $FILES ; do
    # Clear file = remove comments, echo coments, options, gtkdialog comments, gtkdialog if(if false disable:CHECKBOX2), html, empty lines.
    CLEARED_FILE=$(sed -e 's/#[^#]*//g' -e 's/"[^"]*"//g' -e "s/'[^']*'//g" -e 's/-[^-]*//g' -e '/<label>/d' -e '/able:/d' -e 's/<[^>]*>//g' -e '/^\s*$/d'  ${NAME_SCRIPT})
        MESSAGE_DEBUG "==============="
        MESSAGE_DEBUG "CLEARED_FILE = $CLEARED_FILE" 
        MESSAGE_DEBUG "==============="

    CLEARED_FILE=$(echo "$CLEARED_FILE" | sort | uniq)

    # Test if your script has any command from list of commands
    while IFS= read -r COMMAND_LINE ; do
        if  $(echo "$CLEARED_FILE" | grep -wq "$COMMAND_LINE") ; then
			    #   MESSAGE_DEBUG "$COMMAND_LINE" 
			    LIST_OF_DEPEND=$(echo -e "$LIST_OF_DEPEND\n${COMMAND_LINE}")
        fi
    done <<< "${LIST_4}"


    LIST_OF_DEPEND_ALL=$(echo -e "$LIST_OF_DEPEND_ALL\n${LIST_OF_DEPEND}")
#       MESSAGE_DEBUG "$LIST_OF_DEPEND_ALL"

done
## == Test if script has commands from the list of commands   ==
################################################################}


# Remove empty lines, sort, and remove repetitions
LIST_OF_DEPEND_ALL=$(grep -v -e '^$' <<< "$LIST_OF_DEPEND_ALL" | sort | uniq)
       MESSAGE_DEBUG "LIST_OF_DEPEND_ALL = $LIST_OF_DEPEND_ALL"


################################################{
## == Find which package contains the command ==
while IFS= read -r LINE_DEPEND ; do
        MESSAGE_DEBUG "LINE_DEPEND = $LINE_DEPEND"
	PATH_DEPEND=$(type -P "$LINE_DEPEND")
	    if [[ $(echo $?) == "1" ]] ;then
		    MESSAGE_ERROR "We can not find path of command: $LINE_DEPEND" 
            continue
        fi


		NAME_PACK=$(${FIND_PACKAGE} "$PATH_DEPEND")
	    if [[ $(echo $?) == "1" ]] ;then
            # Some symbolic links are badly made in packages and it will be harder to find the right package from package manager.
            # We will try use deep search 
            if grep -q "symbolic link" <(file "$PATH_DEPEND")  ;then
                MESSAGE_DEBUG   "This is symbolic link = $PATH_DEPEND"
                MESSAGE_WARNING "Search package from path failed. We will try find file from symbolic link = $PATH_DEPEND" 
                # We will try get file from symbolic link
                NAME_PACK=$(${FIND_PACKAGE} "$(readlink -f "$PATH_DEPEND")")
                    if [[ $(echo $?) == "1" ]] ;then
                        MESSAGE_ERROR "We can not find package = $PATH_DEPEND" 
                        continue
                    fi
            else
		        MESSAGE_ERROR "We can not find package = $PATH_DEPEND" 
                continue
            fi
        fi
        MESSAGE_DEBUG "NAME_PACK = $NAME_PACK"

		LIST_PACK=$(echo -e "${LIST_PACK}\n${NAME_PACK}")
done <<< "${LIST_OF_DEPEND_ALL}"
## == Find which package contains the command ==
################################################}


#MESSAGE_DEBUG "$LIST_PACK"


#################################{
## == Main information to show ==
LIST_PACK=$(grep -v -e '^$' <<< "$LIST_PACK" | sort)
MESSAGE_INFO "List of packages dependencies: \n$LIST_PACK"

# Remove empty lines and sort
LIST_ONLY_PACK=$(echo "$LIST_PACK" | cut -d':' -f1 | sort | uniq)
MESSAGE_DEBUG "Short form of dependencies: \n$LIST_ONLY_PACK"

echo " "
echo  "==============="
echo " "


##############################{
## == Find source code name ==
function DISABLED() {
##  Find source code
##  Poorly described packages in Ubuntu/LinuxMint and I don't know any other method 
##  so is off
while IFS= read -r NAME_ONLY_PACK ; do
        SOURCE_CODE=$(${FIND_SOURCE} "$NAME_ONLY_PACK" | grep -i source)
	    MESSAGE_INFO "$NAME_ONLY_PACK = $SOURCE_CODE"
done <<< "${LIST_ONLY_PACK}"

echo " "
echo  "==============="
echo " "
}
## == Find source code name ==
##############################}


MESSAGE_INFO 'If your script does not work on another system, \nyou can check / compare aliases with command:  alias -p \n and check inside script.'
echo " "
echo  "==============="

echo " "
MESSAGE_INFO "Example of the code for your shell script:"
MESSAGE_INFO "+ bash template gratis."
MESSAGE_INFO "###################################################################"
echo " "
echo " "
echo '#!/bin/bash'
echo " "
echo "#=============================================================================={"
echo "##    Destiny:    <Edit> "
echo '     VERSION="<Edit>" '
echo "##    Date:       $(date +"%Y.%m.%d") (Year.Month.Day) "
echo '##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html '
echo "##    Source:   <Edit> "
echo "##    Script usage:   <Edit> "
echo "#==============================================================================}"
echo " "
echo "#=============================================================================={"
echo "# Check Dependecies - List created automatically by $0 version=${VERSION} "
echo "# source=${SOURCE}"
echo " "
while IFS= read -r DEPEND ; do
    echo  "[[ -z \$(type -P "${DEPEND}") ]] && DEP=\"\$DEP\"$'\n'\"${DEPEND}\""
done <<< "${LIST_OF_DEPEND_ALL}"

echo " "
echo '# End script if exist any error'
echo '[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}'
echo " "
echo "#     Used Packages: $(tr '\n' ',' <<< $LIST_ONLY_PACK)"
echo "#=============================================================================={"
echo " "
MESSAGE_INFO "###################################################################"

## == Main information to show ==
#################################}
}




case $1 in
	"--help"|"-h")
		echo "---------------------------------------------------------"
        echo ' '
		echo '  Destiny:        Script to find dependencies from *.bash and *.sh files'
		echo "  Script usage:   $0 --check file.1.sh file.2.sh"
        echo '                  This script can handle one or more files simultaneously.'
		echo " "
		echo " Options:"
		echo "   -h  --help             Show this help."
		echo "       --check            Checks dependencies. Use this option with your script."
		echo " "
		echo "---------------------------------------------------------"
        echo "  Info:"
		echo " "
		echo "1. This script has a debug option, if you want enable debugging"
		echo ' you have to inside the script find line containing:'
        echo 'DEBUG="OFF" and change to DEBUG="ON"'
		echo " "
        echo '2. This script is not very fast.'
        echo ' '
		echo '3. I did not use the package name for generating the example code '
		echo ' because any Linux distribution can split a package into any number of packages and any name.'
		echo " "
		echo '4. For now it was hard for me to filter out all the comments created with "echo" from any script. '
		echo ' So script output may contain the redundant dependencies if you mentioned in the comment'
		echo ' For example: script , compare , split'
		echo ' So if the dependencies are wrong, you have to delete them manually'
		echo ' You can find and check in this script: CLEARED_FILE'
        echo ' '
        echo '5. Dependencies of coreutils may seem redundant,'
        echo ' but may exist different versions of them. (coreutils, busybox, toybox)'
        echo ' '
		exit 0
	;;
	"--check")
        CHECK_ARG "$*"
    ;;
    *)
        MESSAGE_ERROR "Unknow option. For help write: $0 --help"
    ;;
esac


