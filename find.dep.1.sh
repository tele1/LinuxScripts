#! /bin/bash 

# Licence: GNU GPL v3
# Version: 1
# Script use:	Name_of_script /path/to/next/script
# Destiny: Script to find dependencies from *.bash and *.sh files


case $1 in
	"--help"|"-h")
		echo "---------------------------------------------------------"
		echo "usage: $0 --option"
		echo "usage: $0 your.bash.script"
		echo " "
		echo " Options:"
		echo "   -h  --help        Show this help."
		echo " "
		echo "  More info about script you can find inside script."
		echo "---------------------------------------------------------"
		exit 0
	;;
	"") 
		echo "	Error: You did not specify any bash script to search for its dependencies."		
		echo "	Try use: $0 --help"
		exit 0
	;;
esac


NC='\e[0m'    # Reset Color
GC='\e[0;32m' # Green ECHO
BL='\e[0;36m' # Cyan ECHO

DEBUG="ON"
DEBUG()
{
    if [[ "$DEBUG" == "ON" ]] ; then
        echo -e "${BL}Line in script:  DEBUG $1 ${NC}"
    fi
}


[ -f "$1" ] || echo "File $1 not exist"
[ -f "$1" ] || exit 1

# All available commands in the system except reserved
# dictionary: https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html
LIST1=$(compgen -c | grep [a-Z] | grep -v 'if\|then\|else\|elif\|fi\|select\|time\|while\|until\|do\|done\|case\|esac\|exit\|for\|in\|function')


while IFS= read -r line3 ; do
# Check only bash and sh files.
	if grep -q "/bin/bash\|/bin/sh" "$line3"; then
	    echo "--> Checked, this is unix script: $line3"
	    # FILE=remove comments, echo coments, options, gtkdialog comments, gtkdialog if(if false disable:CHECKBOX2), html, empty lines.
	    FILE=$(sed -e 's/#[^#]*//g' -e 's/"[^"]*"//g' -e 's/-[^-]*//g' -e '/<label>/d' -e '/able:/d' -e 's/<[^>]*>//g' -e '/^\s*$/d' ${line3})
	    while IFS= read -r line2 ; do
		    if  $(echo "$FILE" | grep -wq "$line2") ; then
			    echo $line2 
			    LIST2=$(echo -e "$LIST2\n${line2}")
		    fi
	    done <<< "${LIST1}"
    else
	    echo "--> No, this is not unix script: $line3"
        exit 1
	fi
# Find only text files
done <<< "$(find $1 -type f -exec grep -Iq . {} \; -print | grep -v "README"$)"


# Create more short list
LIST3=$(echo "$LIST2" | sort | uniq | sed '1d')
echo "============="
#echo "${LIST3}"


# Linux distribution settings 1
NAME_LINUX=$(lsb_release -is)
echo "--> Linux distribution name: $NAME_LINUX"
case "$NAME_LINUX" in
"UPLOS")
	FIND_PACKAGE="rpm -qf"   # find package name from path 
	FIND_SOURCE="rpm -qi"    # show info about package 
	;;
"LinuxMint")
	FIND_PACKAGE="dpkg -S"   # find package name from path 
	FIND_SOURCE="dpkg -s"    # show info about package 
;;
*)
    # Arch Linux
	FIND_PACKAGE="pacman -Qo"
esac

DEBUG 1000 #--------------------------

# Find linux distribution dependencies
while IFS= read -r line3 ; do
	#echo $line3
	PATH2=$(which "$line3")
	if [[ $(echo $?) == "1" ]] ;then
		echo "Command: $line3" 
	else
		NAME_PACK=$(${FIND_PACKAGE} "$PATH2")
		#LIST4=$(echo -e "$LIST4\n${NAME_PACK}")
		# DEBUG /
		LIST4=$(echo -e "$LIST4\n${NAME_PACK} $PATH2")
		LIST4_B=$(echo -e "${LIST4_B}\n${NAME_PACK}")
	fi
done <<< "${LIST3}"

echo "==============="
echo "--> Dependencies:"
LIST5=$(echo "$LIST4")
echo "$LIST5"
DEBUG 1001 #--------------------------
echo "==============="

LIST4_C=$(echo "$LIST4_B" | sort | uniq | sed '1d')
echo "--> Sorted:"
echo " "
echo "$LIST4_C"
DEBUG 1002 #--------------------------

echo "==============="
echo "--> Sources:"
echo " "

# Linux distribution settings 2
case "$NAME_LINUX" in
"UPLOS")
	while IFS= read -r line4 ; do
	    ${FIND_SOURCE} "$line4" | grep -o "Source RPM.*"
    done <<< "${LIST4_C}"
;;
"LinuxMint")
    echo "No valid command found for search source code in Linux Mint."
    echo "You can try \" apt-get source package_name \" but only works if you have the source repositories turned on"
;;
*)
    echo "Sorry, I don't have enough information about your system to develop this script."
    echo "You can send me output \" lsb_release -is \" and proper commands for this script."
esac




