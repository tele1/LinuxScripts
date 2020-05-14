#!/bin/bash


# Destiny: Skript to convert files with source bb code (from forum) to Markdown 
#           More about Markdown: https://guides.github.com/features/mastering-markdown/
#           For now this is very simple converter, so this is script may not work very well.
#
# Licence: GNU GPL v3
# Version: Beta 2
# Script use:	Name_of_script -f /path/to/dir/
# Info:
#       Online markdown editor:  markdown-editor.github.io/
#       Html editor:             html-online.com/editor/


# File or Dir
PATH_FD="$2"

####################################################
CONVERT()
{
# convert [b] / Bold Font
sed -i -e 's/\[b\]/**/g' -e 's/\[\/b\]/**/g' "$(pwd)/READY/${NEW_NAME}"
# convert [i] / Italic Font
sed -i -e 's/\[i\]/*/g' -e 's/\[\/i\]/*/g' "$(pwd)/READY/${NEW_NAME}"
# convert [size=large]
sed -i -e 's/\[size=large\]/# /g' -e 's/\[\/size\]//g' "$(pwd)/READY/${NEW_NAME}"
# convert [size=medium]
sed -i -e 's/\[size=medium\]/# /g'  "$(pwd)/READY/${NEW_NAME}"
# convert [size=small]
sed -i -e 's/\[size=small\]/## /g'  "$(pwd)/READY/${NEW_NAME}"
# convert [code]
sed -i -e 's/\[code\]/```\n/g' -e 's/\[\/code\]/\n```/g' "$(pwd)/READY/${NEW_NAME}"
# convert [list]
sed -i -e 's/\[list\]//g' -e 's/\[\/list\]//g' -e 's/\[\*\]/*/g' "$(pwd)/READY/${NEW_NAME}"
##################
# convert [quote]
##sed -i -e 's/\[quote\]/> /g' -e 's/\[\/quote\]/\n/g' "$(pwd)/READY/${NEW_NAME}"
## HTML5 tags: https://www.tutorialrepublic.com/html-reference/html5-tags.php
sed -i -e 's/\[quote\]/<blockquote>/g' -e 's/\[\/quote\]/<\/blockquote>/g' "$(pwd)/READY/${NEW_NAME}"
##################
# convert color:  https://stackoverflow.com/questions/35465557/how-to-apply-color-in-markdown
# remove html tags: https://stackoverflow.com/questions/19878056/sed-remove-tags-from-html-file
## note -> part code color to html: sed -e 's/\[color=/<p><span style="color:/g'
# for now remove colors
sed -i -e 's/\[color=#......\]//g' -e 's/\[\/color\]//g' "$(pwd)/READY/${NEW_NAME}"
# note -> all in "[]": sed  -e 's/\[[^]]*\]//g' 
##################
FOUND_1="$(grep -H  "\[.*\]" "$(pwd)/READY/${NEW_NAME}" | grep -v "%\]" | grep -v "\[.*[[:space:]].*\]" | grep -v "\[done\]" | grep -v "\[\$.*")"
[ -z "${FOUND_1}" ] || echo -e "\n--> INFO: trying only detect other syntax of bb code and show you:"
[ -z "${FOUND_1}" ] || echo "$FOUND_1" | grep -H --color=auto "\[.*\]" 
}
####################################################
RENAME_FILE()
{
# add ".md" and remove "space bar" 
NEW_NAME=$(echo "${1}.md" | sed '/^$/d;s/[[:blank:]]/./g')

}
####################################################
DIR_WHOLE()
{
[ ! -d "$PATH_FD" ] && echo "--> Dir not exist: $PATH_FD"
[ ! -d "$PATH_FD" ] && exit 1

[ -d "$(pwd)/READY" ] && echo "--> Remove folder READY before we paste there files."
[ -d "$(pwd)/READY" ] && exit 1
[ ! -d "$(pwd)/READY" ] && mkdir READY

NUMBER_FILES=$(find "$PATH_FD" -type f | wc -l)
# get only file name from find: https://superuser.com/questions/69400/how-can-i-force-only-relative-paths-in-find-output
LIST_FILES=$(find "$PATH_FD" -type f -printf "%P\n")

for NUMBER_X in `seq 1 "$NUMBER_FILES"` ; do
    # get line
    LINE=$(awk 'NR=='"$NUMBER_X"  <<< "$LIST_FILES")
    RENAME_FILE "$LINE"
    #echo "$LINE = ${NEW_NAME}"
    cp "$PATH_FD/$LINE" "$(pwd)/READY/${NEW_NAME}"
    CONVERT "$(pwd)/READY/${NEW_NAME}"
done
    echo " "
    echo " --> Converted files you find in READY folder."
}




case "$1" in
	"--dirs"|"-d")
        DIR_WHOLE
	;;
	"--files"|"-f")
        echo " Sorry, you need finish this part script alone for now, "
        echo " or copy file to empty folder and try with --dir option. :)"
	;;
	"--help"|"-h")
		echo "---------------------------------------------------------"
		echo "usage: $0 --option /your/path/"
		echo " "
		echo " Main:"
		echo "   --dir             -d     convert all files from directory"
		echo "   --file            -f     convert file"
		echo "   --help            -h     show help"
		echo " "
		echo " Always remember to back up your files ;-) "
		echo " "
		echo "---------------------------------------------------------"
		exit 0
	;;
	*)
		echo "	Error: unknown option"		
		echo "	Try use: $0 --help"
		exit 0
	;;
esac
