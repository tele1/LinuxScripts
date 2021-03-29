#! /bin/bash 

# Licence: GNU GPL v3
# Version: Beta 1
# Script use:	Name_of_script /path/to/scripts
# Destiny: Script to find dependencies from *.bash and *.sh files


# All available commands in the system except reserved
# dictionary: https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html
LIST1=$(compgen -c | grep [a-Z] | grep -v 'if\|then\|else\|elif\|fi\|select\|time\|while\|until\|do\|done\|case\|esac\|exit\|for\|in\|function')


while IFS= read -r line3 ; do
# Check only bash and sh files.
	if grep -q "/bin/bash\|/bin/sh" "$line3"; then
	echo "YES: $line3"
####else
####	echo "NOT: $line3"
	# FILE=remove comments, echo coments, options, gtkdialog comments, gtkdialog if(if false disable:CHECKBOX2), html, empty lines.
	FILE=$(sed -e 's/#[^#]*//g' -e 's/"[^"]*"//g' -e 's/-[^-]*//g' -e '/<label>/d' -e '/able:/d' -e 's/<[^>]*>//g' -e '/^\s*$/d' ${line3})
	while IFS= read -r line2 ; do
		if  $(echo "$FILE" | grep -wq "$line2") ; then
			echo $line2 
			LIST2=$(echo -e "$LIST2\n${line2}")
		fi
	done <<< "${LIST1}"
	#echo "$LIST2" | sort | uniq 
	fi
# Find only text files
done <<< "$(find $1 -type f -exec grep -Iq . {} \; -print | grep -v "README"$)"


# Create more short list
LIST3=$(echo "$LIST2" | sort | uniq | sed '1d')
echo "============="
#echo "${LIST3}"


# Linux distribution settings
NAME_LINUX=$(lsb_release -is)
echo "Linux distribution name: $NAME_LINUX"
case "$NAME_LINUX" in
"UPLOS")
	FIND_PACKAGE="rpm -qf"
	FIND_SOURCE="rpm -qi"
	;;
*)
	FIND_PACKAGE="pacman -Qo"
esac


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
LIST5=$(echo "$LIST4")
echo "$LIST5"
echo "==============="
LIST4_C=$(echo "$LIST4_B" | sort | uniq | sed '1d')
echo "$LIST4_C"
echo "==============="
echo "Sources:"

	while IFS= read -r line4 ; do
		${FIND_SOURCE} "$line4" | grep -o "Source RPM.*"
	done <<< "${LIST4_C}"



