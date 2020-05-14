#!/bin/bash

# Find largest files and directories

VERSION="1"
LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
SOURCE="https://github.com/tele1/LinuxScripts"


#########################################################
YOUR_PATH="$2"
[ -z "$YOUR_PATH" ] && YOUR_PATH=$(pwd)


case "$1" in
	"--dirs"|"-d")
		du -h "$YOUR_PATH" | sort -hr | head -10
	;;
	"--files.and.dirs"|"-f.d")
		du -ah "$YOUR_PATH" | sort -hr | head -5
	;;
	"--files"|"-f")
		find "$YOUR_PATH" -type f -exec du -ah {} + | sort -hr | head -5	
	;;
	"--help"|"-h")
		echo "---------------------------------------------------------"
		echo "usage: $0 --option /your/path/"
		echo " "
		echo " Main:"
		echo "   --dirs            -d     find largest dirs"
		echo "   --files.and.dirs  -f.d   find largest files and dirs"
		echo "   --files           -f     find largest files"
		echo "   --help            -h     show help"
		echo " "
		echo " Info: If you don't add a path at the end, the script will search in the place where it was run."
		echo "---------------------------------------------------------"
		exit
	;;
	*)
		echo "	Error: unknown option"		
		echo "	Try use: $0 --help"
		exit
	;;
esac
