#!/bin/bash

# Script designed to download and install Firefox portable.
VERSION="6"
LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
TRADEMARKS="Name Firefox is trademark Mozilla: https://www.mozilla.org/en-US/foundation/trademarks/list/"
SOURCE="https://github.com/tele1/LinuxScripts"
WARNING="I can help you only with this script. \
But I am not a Firefox developer and I am not responsible for errors in the portable application. \
If you see a problem in the portable application, look for the right developer. \
Try find contact at the end of the web page https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt"


#==================={
ERROR()
{
	echo "$@" ; exit 1
}
#===================}

#==================={
ERROR2()
{
	echo "$@" 
}
#===================}

#======================================={
change_language() {
	echo " "
	echo "--> Available other languages:"
	LIST_LANG=$(curl -v --silent https://ftp.mozilla.org/pub/firefox/releases/latest/README.txt --stderr - | grep -E "^   .* lang=")
	echo "$LIST_LANG"
	echo " "
	echo "--> Set new language or leave empty to set lang=en-US and click Enter key"
	read -p "lang=" LANG
	# If empty
	[[ -z "$LANG" ]] && LANGUAGE="en-US" || LANGUAGE="$LANG"
	# If wrong lang
    if echo "$LIST_LANG" | grep -qw "lang=$LANG" ; then
        echo " "
	    echo "Chosen language: lang=$LANG"
    else
        ERROR2 "lang="$LANG" not found :( "
        LANGUAGE="en-US"
    fi
}
#=======================================}

#=========================={
change_version() {
list_version_firefox() {
	LIST_VER=$(curl -v --silent https://ftp.mozilla.org/pub/firefox/releases/ --stderr -  | sed -e '/releases\/[0-9]/!d' -e 's/[\t]*<\/*[^>]*>//g' -e 's/\///g' -e '/[a-Z]/d' )
}

list_version_firefox_esr() {
	LIST_VER=$(curl --silent https://ftp.mozilla.org/pub/firefox/releases/ --stderr -  |  sed -e '/[0-9]esr\//!d' -e 's/[\t]*<\/*[^>]*>//g' -e 's/\///g' )
}

	echo " "
	echo "--> Available versions :"
	echo " "
	echo "1. Firefox"
	echo "2. Firefox ESR"
	echo " "
	read -p "--> Write a number to choose:" branch_firefox
case "$branch_firefox" in
        1 ) BRANCH="Firefox" ; list_version_firefox ;;
        2 ) BRANCH="Firefox ESR" ; list_version_firefox_esr ;;
        * ) echo "###########################################"
			echo "--> Incorrect number."
			ERROR2 "###########################################" ;;
esac
	echo "Chosen branch: $BRANCH"
	echo " "
	echo "--> Available versions :"
	echo " "
	echo "$LIST_VER" | sort --version-sort | column
	echo " "
	echo "--> Set new version and click Enter key"
	read -p "version=" VERSION_FIREFOX
	# If wrong version
    if echo "$LIST_VER" | grep -qw "$VERSION_FIREFOX"  ; then
	    echo "Chosen version: $VERSION_FIREFOX"
    else
        ERROR2 "version="$VERSION_FIREFOX" not found :( "
        VERSION_FIREFOX="$RELEASE"
    fi
}
#==========================}

#================================================================================={
install_app_f() {
# Is installed "curl" ?
[ "$(curl --version)" ] || ERROR "--> Please install Curl before run this script."
LANGUAGE="en-US"
LINK1="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux&lang=${LANGUAGE}"
RELEASE=$(curl  -s "${LINK1}" | sed -e 's/.*releases\/\(.*\)\/linux.*/\1/g' -e 1q)
LINK_ESR="https://download.mozilla.org/?product=firefox-esr-latest&os=linux&lang=${LANGUAGE}"
RELEASE_ESR=$(curl  -s "${LINK_ESR}" | sed -e 's/.*releases\/\(.*\)\/linux.*/\1/g' -e 1q)
VERSION_FIREFOX="$RELEASE"

LOOPS="y"
while [[ "$LOOPS" == "y" ]] ; do
echo " "
echo "=============================="
echo "--> Language: \"${LANGUAGE}\""
echo "--> Version: \"${VERSION_FIREFOX}\""
echo "   ( Latest Firefox:     ${RELEASE} )"
echo "   ( Latest Firefox ESR: ${RELEASE_ESR} )"
echo " "
echo "1. Change Language"
echo "2. Change Version"
echo "3. Exit"
echo "4. Install Firefox"
echo "5. Uninstall Firefox"
echo "=============================="
echo " "
read -p "--> Write a number to choose:" choice
case "$choice" in
        1 ) change_language ;;
        2 ) change_version ;;
        3 ) exit 0 ;;
        4 ) LOOPS="n";;
        5 ) uninstall_app_f;;
        * ) echo "###########################################"
			echo "--> Incorrect number."
			echo "###########################################" ;;
esac
done



echo " "
# Download firefox
echo "--> Downloading..."
curl -O https://ftp.mozilla.org/pub/firefox/releases/${VERSION_FIREFOX}/linux-i686/${LANGUAGE}/firefox-${VERSION_FIREFOX}.tar.bz2

# Check if downloaded file exist.
[ "$(ls -A ./firefox*tar.bz2)" ] || ERROR "--> Firefox was not downloaded!"


# Check sum
SUM=$(curl -v --silent https://ftp.mozilla.org/pub/firefox/releases/${VERSION_FIREFOX}/SHA256SUMS --stderr - | grep "linux-i686/${LANGUAGE}/firefox-${VERSION_FIREFOX}.tar.bz2" \
| awk '{print $1}')

echo " "
echo "--> Checking the checksum sha256sum"
echo "$SUM firefox-${VERSION_FIREFOX}.tar.bz2" | sha256sum --check  
[ $? == 0 ] || ERROR "--> Downloaded file is broken or sha256sum not exist!"
echo " "

###################################
## Security theory:
# chown -R root:root /opt/firefox
# chmod -R 755 /opt/firefox
# find /opt/ -perm /4000 -o -perm /2000 -o -perm /6000 -o -perm /1000
#
## Important:
#  If the regular user can hang the program
#  (which is owned by the root user and has the suid or sgid flag set)
#  to get to the shell, then he will get the program owner's rights
#  (in this case the root user).
#  So avoid "suid" or "sgid" flag, if you can.

# Info: https://www.techrepublic.com/blog/it-security/understand-the-setuid-and-setgid-permissions-to-improve-security/
# Calculator: http://permissions-calculator.org/
# How find: https://www.tecmint.com/how-to-find-files-with-suid-and-sgid-permissions-in-linux/
#
## Update Menu theory:
# update-desktop-database /usr/share/applications
# update-menus

## Create link
# ln -s /opt/firefox/firefox ~/Desktop/portable.firefox
###################################

# Own item to menu
cat <<'EOF' >> portablefirefox.desktop
[Desktop Entry]
Version=1.0
Name=Portable.Firefox
GenericName=Web Browser
Comment=Browse the Web
Exec=/opt/firefox/firefox %u
Icon=firefox
Terminal=false
Type=Application
StartupWMClass=PortableFirefox
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;
Categories=GTK;Network;WebBrowser;X-MandrivaLinux-Internet-WebBrowsers;X-MandrivaLinux-CrossDesktop;
EOF

echo " "
# Unpack to /opt/
# Change owner to root
# Add icon to "Menu"
echo "--> Installation:"

if uname -a | grep -iq ubuntu ; then
    sudo bash -c 'rm -rf /opt/firefox ; bzip2 -dc firefox*tar.bz2 | tar xvf - -C /opt ; chown -R root:root /opt/firefox ; mv portablefirefox.desktop /usr/share/applications/ ; update-desktop-database /usr/share/applications'
else
    su root -c 'rm -rf /opt/firefox ; bzip2 -dc firefox*tar.bz2 | tar xvf - -C /opt ; chown -R root:root /opt/firefox ; mv portablefirefox.desktop /usr/share/applications/ ; update-desktop-database /usr/share/applications'
fi

# Checking file permissions
echo "  "
echo "------------------"
# Find files with "suid" or "sgid" flag.
if [[ ! "$(find /opt/firefox -perm /4000 -o -perm /2000 -o -perm /6000 | wc -l)" == "0" ]]; then
    RC='\e[0;31m' # Red Color
    NC='\e[0m' # No Color
    echo -e "${RC} Potentially dangerous files: ${NC}"
    find /opt/firefox -perm /4000 -o -perm /2000 -o -perm /6000
    echo -e "${RC} Warning!  ${NC}"
    echo -e "${RC} Found "suid" or "sgid" flag. Using firefox can be dangerous. ${NC}"
    exit 1
fi
# Find writable files
if [[ ! "$(find /opt/firefox -perm -o+w | wc -l)" == "0" ]]; then
    RC='\e[0;31m' # Red Color
    NC='\e[0m' # No Color
    echo -e "${RC} Potentially dangerous files: ${NC}"
    find /opt/firefox -perm -o+w
    echo -e "${RC} Warning!  ${NC}"
    echo -e "${RC} Found writable files. ${NC}"
    exit 1
fi

# Remove superfluous file
rm ./firefox*tar.bz2

# Info.
[ -d "/opt/firefox" ] && echo "--> Portable.Firefox installed now, check."
[ -d "/opt/firefox" ] || echo "--> Installation failed. Path /opt/firefox/ does not exist"
}
#=================================================================================}

#======================{
uninstall_app_f() {
if uname -a | grep -qi ubuntu ; then
    sudo bash -c 'rm -rfv /opt/firefox ; rm -rfv /usr/share/applications/portablefirefox.desktop ; update-desktop-database /usr/share/applications'
else
    su root -c 'rm -rfv /opt/firefox ; rm -rfv /usr/share/applications/portablefirefox.desktop ; update-desktop-database /usr/share/applications'
fi
[ -d "/opt/firefox" ] || echo "--> Removal /opt/firefox/ completed successfully"
}
#======================}

###################{
case $1 in
	"--install")
	install_app_f
	;;

	"--uninstall")
	uninstall_app_f
	;;

	"--help")
	echo "Usage: [SCRIPT NAME] [OPTION]"
	echo " "
	echo "                              without option will also install portable.firefox"
	echo "      --install               install or reinstall portable.firefox"
	echo "      --uninstall             remove portable.firefox"
	echo "      --help                  display this help and exit"
	echo "      --version               output version information and exit"
	echo " "
	echo -e "WARNING: $WARNING"
	;;

	"--version")
	echo "Script Version: $VERSION"
	echo "Licence: $LICENCE"
	echo "Trademarks: $TRADEMARKS"
	;;

	*)
	install_app_f
	;;
esac
###################}
