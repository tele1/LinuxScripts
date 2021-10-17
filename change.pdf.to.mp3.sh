#!/bin/bash


## Developed for Linux
## License: GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
	VERSION='1'
## Destiny: The script translates .pdf files into a .txt file and an .mp3 file 
## Script usage:
##		1. Paste .pdf files to PDF folder
##		2. Run in terminal:		bash script_name
##		3. Wait a minute and it's ready. You will have TEXT and MP3 folders with files.


###########################}
# Check Dependecies - List created automatically by find.bash.dep.sh version=8 
# source=https://github.com/tele1/LinuxScripts
[[ -z $(type -P echo) ]] && DEP="$DEP"$'\n'"echo"
[[ -z $(type -P espeak) ]] && DEP="$DEP"$'\n'"espeak-ng"
[[ -z $(type -P ls) ]] && DEP="$DEP"$'\n'"ls"
[[ -z $(type -P mkdir) ]] && DEP="$DEP"$'\n'"mkdir"
[[ -z $(type -P pdftotext) ]] && DEP="$DEP"$'\n'"pdftotext"
 
# End script if exist any error
[ -z "$DEP" ] || { echo "   Error: Missing dependencies, before run script please install: $DEP"  ; exit 1  ;}
###########################}

if [ ! -d PDF ]; then
  echo "Error: PDF folder not exist." ; exit 1
elif [ ! -d TEXT ]; then
  mkdir -p TEXT
elif [ ! -d MP3 ]; then
  mkdir -p MP3
fi

LISTA_1=$(ls PDF/)

while IFS=" " read -r FILE ; do
	echo $FILE
	pdftotext -layout PDF/${FILE} TEXT/${FILE}.txt
done <<< $LISTA_1

echo "	"
echo "===================="
echo "	"

while IFS=" " read -r FILE2 ; do
	echo $FILE2
	espeak-ng  -v polish --stdout -f TEXT/${FILE2}.txt | ffmpeg -i - -ar 44100 -ac 2 -ab 192k -f mp3 MP3/${FILE2}.mp3
done <<< $LISTA_1

echo "THE END"

exit 0






