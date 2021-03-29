#!/bin/bash


# Created for UPLOS Linux
# http://www.liberainformatica.it/forum/forumdisplay.php?fid=25

# License: GNU GPL v.3
# Version: 8
# Destiny: GUI for testers, for check broken packages in repository.
# Usage:  ./script

#==================================={
# dependencies
            RC='\e[0;31m' # Red Color
            NC='\e[0m' # No Color

            func_Error_Depend()
            {
                echo "======================"
                echo -e "${RC}    Error: Missing $1.
    Please install $1, before run script. ${NC}"
                echo "======================"
            }

[[ -z $(which lynx) ]] && { func_Error_Depend lynx ; exit 1 ;}
[[ -z $(which gtkdialog) ]] && { func_Error_Depend gtkdialog ; exit 1 ;}


#-----------------------------------{
funcError()
                {
GTKDIALOG=gtkdialog

export WindowError='
    <vbox>
        <frame>
            <hbox>
                <pixmap icon_size="6">
                    <input file stock="gtk-dialog-error"></input>
                </pixmap>
                <vbox>
                <text use-markup="true">
                    <label>"<span size='"'large'"' color='"'red'"'>'$"Error:"'
'"$1"' </span>"</label>
                </text>
                </vbox>
            </hbox>
        </frame>
        <hbox>
            <button>
                <label>'$"exit"'</label>
                <input file icon="exit"></input>
                <action>echo You pressed exit button</action>
                <action type="exit">Exit by button</action>
            </button>
        </hbox>
    </vbox>'

gtkdialog -c --program WindowError
exit 1
}
#-----------------------------------}
#===================================}


#---Checking exist dirs to work --{
aaa=`pwd`/TMP/
if [ ! -d $aaa ];
   then
   echo "TMP dir not found / will created."
   mkdir TMP
else
    rm -fvr TMP
    mkdir TMP
fi
#---------------------------------}


#============================================{
#------- CREATING THE LIST 32 BIT ----------------------------------{
#-----GUI------------------------{

function gui {
URI="http://ftp.nluug.nl/os/Linux/distr/"
DISTR="uplos/32bit"
OLD_SECTIONS=$(grep ^"rpm " /etc/apt/sources.list | cut -d" "  -f4-)
echo "test" > `pwd`/TMP/sections


export MAIN_DIALOG='
<window>
<vbox width-request="600">

<frame>
    <button>
		<input file icon="reload"></input>
		<label>Edit active sections.</label>
        <action>echo "2" > `pwd`/TMP/exit</action>
        <action type="exit">"Exit by button"</action>
    </button>
</frame>
<frame>
  	<text>
		<label>List active sections:</label>
  	</text>
    <entry>
		<default>'"$OLD_SECTIONS"'</default>
      <variable>ENTRY1</variable>
      <visible>disabled</visible>
    </entry>

</frame>
<frame>

  <text>
    <label>From which active section download list packages to test ?</label>
  </text>
  <entry>
    <default>'"$(cat `pwd`/TMP/sections)"'</default>
    <variable>ENTRY2</variable>
  </entry>
</frame>

  <hbox>


    <button cancel>
        <action>echo You pressed exit button</action>
        <action>echo "1" > `pwd`/TMP/exit</action>
        <action type="exit">"Exit by button"</action>
    </button>
    <button>
        <input file stock="gtk-apply"></input>
        <label>Start</label>
        <action>echo "$ENTRY2" > `pwd`/TMP/sections</action>
        <action>echo "0" > `pwd`/TMP/exit</action>
        <action type="exit">"Start by button"</action>
    </button>
  </hbox>
</vbox>
</window>
'
gtkdialog --program=MAIN_DIALOG
}


until [[ $EXIT == 0 ]]; do
	gui
	EXIT=$(cat `pwd`/TMP/exit)
	if [[ $EXIT == 1 ]]; then
		echo "Exiting"
    	exit 0 
	elif  [[ $EXIT == 2 ]]; then
		gksu "synaptic -r"
	fi
done
#-----GUI------------------------}
#============================================}


# Save `pwd`/TMP/sections to bash table  ------{
NUMBER_OF_WORDS=$(cat `pwd`/TMP/sections | wc -w)

    for i in `seq 1 $NUMBER_OF_WORDS`
    do
        DZIALY_32BIT[$i]=$(cat `pwd`/TMP/sections |  cut -d" " -f${i})
        echo ${DZIALY_32BIT[$i]}
        echo "----"
    done

LICZBA_DZIALOW_32BIT="${#DZIALY_32BIT[@]}"
# Save `pwd`/TMP/sections to bash table  ------}


#---------------{
# Check link to repository
aba=$(grep ^"rpm ${URI} ${DISTR}" /etc/apt/sources.list | wc -l)

if [ "$aba" -ne "1" ]; then
    ERROR="    rpm ${URI} ${DISTR}
    this repository is not active.
    Please check in Synaptic."
    funcError "$ERROR"
fi
#---------------}

echo " --> Number of sections: $LICZBA_DZIALOW_32BIT "

#======================================================{
# 1. ------- CREATING THE LIST 32 BIT PACKAGES ----
    for i in `seq 1 $LICZBA_DZIALOW_32BIT`
    do
        NUMER=$(($i))
        DZIAL=RPMS.${DZIALY_32BIT[$NUMER]}
        echo "$NUMER - $i - $DZIAL"


        #-- Check  repository sections --{
        TEST_SECTION=$(grep ^"rpm ${URI} ${DISTR}" /etc/apt/sources.list | grep ${DZIALY_32BIT[$NUMER]} | wc -l )

        if [ "$TEST_SECTION" -ne "1" ]; then

            ERROR="    ${DZIALY_32BIT[$NUMER]}
    this section is not active / not added.
    Please add and reload repository in Synaptic,
    you can later this section remove."
            funcError "$ERROR"
        fi
        #-- Check  repository sections --}


        lynx   -nolist -dump -width 120  ${URI}${DISTR}/$DZIAL/ \
        | grep "\[   \]" | awk -F" " '{ print $3}'  | \
        sed -e 's/google-chrome-stable_current_i386.rpm/google-chrome-stable-1.0-1/g' \
            -e 's/nomachine_4.4.12_12_i686.rpm/nomachine-1.0-1/g'  \
            -e 's/teamviewer_11.0.53191.i686.rpm/teamviewer-11.0.53191-1/g' | \
        sed -e 's/pclos.....i586.rpm//g' \
        -e 's/pclos.....noarch.rpm//g' \
        -e 's/.i386.rpm//g' \
        -e 's/uplos.....i586.rpm//g' \
        -e 's/uplos.....noarch.rpm//g' >> `pwd`/TMP/32bit.rpm.lista0
    done

echo " - LIST OF PACKAGES 32 BIT IS READY :)"

#=================={
# save only name of packages
rev `pwd`/TMP/32bit.rpm.lista0 | cut -d"-" -f 3- | rev > `pwd`/TMP/32bit.rpm.lista2
#==================}

#------- CREATING THE LIST 32 BIT PACKAGES ----
#======================================================}


#========================================{
# note
echo "Sections: $(cat `pwd`/TMP/sections)" > `pwd`/TMP/apt.log
echo "apt-get install -s \$(/TMP/32bit.rpm.lista2)" >> `pwd`/TMP/apt.log
echo "-------------------------" >> `pwd`/TMP/apt.log

echo "Sections: $(cat `pwd`/TMP/sections)" > `pwd`/TMP/distupgrade.log
echo "apt-get  -s dist-upgrade" >> `pwd`/TMP/distupgrade.log
echo "-------------------------" >> `pwd`/TMP/distupgrade.log
#========================================}


#==================================={
# 2. Save the simulation command to a file
echo " apt-get update ; \
apt-get install -s \$(cat \`pwd\`/TMP/32bit.rpm.lista2) |& tee -a \`pwd\`/TMP/apt.log ; \
apt-get  -s dist-upgrade |& tee -a \`pwd\`/TMP/distupgrade.log" > `pwd`/TMP/komenda
#===================================}


#====================={
# make file executable
chmod +x `pwd`/TMP/komenda

# 3. Run file with root
gksu -u root `pwd`/TMP/komenda
#====================={


#==================================={
# 4. Open log with default text editor
xdg-open `pwd`/TMP/apt.log
xdg-open `pwd`/TMP/distupgrade.log
#===================================}
echo "Completion successfully"
