#! /bin/bash 


# Destiny: 
#			This for own website / blog on GitHub with Markdown. 
#			This script show you broken links in README.md 
#			or files .md which exists but are not included in README.md
#
# Licence: GNU GPL v3
# Version: 1
# Script use:
#			with path to repository
#
#           						bash ./script /path/to/repository/

echo "Hello! :)"

YOUR_PATH="$1"
	[ -z "$YOUR_PATH" ] && YOUR_PATH=$(pwd)
	[[ ! -f "${YOUR_PATH}/README.md" ]] && echo "WRONG Path, $YOUR_PATH/README.md not found."
	[[ ! -f "${YOUR_PATH}/README.md" ]] && exit 1
	echo "Your path to repository: $YOUR_PATH"

cd "$YOUR_PATH"
FILES=$(find ./ -name "*.md" | sed 's/^\.\///g' | grep -v "README.md" | sort)
LINKS=$(grep '.md)' "README.md" | sed -e 's/.*(//g' -e 's/).*//g' | sort)



OUTPUT_1=$(diff <(echo "$FILES") <(echo "$LINKS"))
MISSING_IN_README=$(grep ^"<" <<< "$OUTPUT_1")
MISSING_IN_FILES=$(grep ^">" <<< "$OUTPUT_1")


[[ -z "$MISSING_IN_README" ]] || echo -e "\n\n --> Missing links in README.md, but file exist:"
[[ -z "$MISSING_IN_README" ]] || echo "$MISSING_IN_README"

[[ -z "$MISSING_IN_FILES" ]] || echo -e "\n\n --> Missing files .md in repository, but exist in README.md:"
[[ -z "$MISSING_IN_FILES" ]] || echo "$MISSING_IN_FILES"

[[ -z "$MISSING_IN_README" && -z "$MISSING_IN_FILES" ]] && echo "Everything looks fine."
