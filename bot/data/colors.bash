#!/bin/bash


#############################################################

##      LICENCE="GPL v3: https://www.gnu.org/licenses/gpl.html "
##      SOURCE="https://github.com/tele1/LinuxScripts"

#############################################################


NC='\e[0m'    # Reset Color
BL='\e[0;36m' # Cyan ECHO
GN='\e[0;32m' # Green ECHO
YW='\e[0;33m' # Yellow ECHO
RD='\e[0;31m' # Red ECHO


FuncGREEN_ECHO()
{
    echo -e "${GN}$@${NC}"  
}

FuncYELLOW_ECHO() {
    echo -e "${YW}${@}${NC}"
}

FuncRED_ECHO() {
    echo -e "${RD}${@}${NC}"
}
