#!/bin/bash


#=============================================================================={
##    Destiny:    A script designed to detect the base Linux distribution
##    VERSION="1" 
##    Date:       2024.12.14 (Year.Month.Day) 
##    License:    GNU GPL v.3   http://www.gnu.org/licenses/gpl-3.0.en.html 
##    Source:     https://github.com/tele1/LinuxScripts 
##    Script usage:   Each function below has a guide how to use it.
##    Dependencies: ( read REDME.md )
##                
#==============================================================================}


#============================================================================{
##       # Depends on local timezone,

#   $ date -d '2024-12-02 14:27:04' +%s
#   1733146024

F_To_Epoch() 
{
    date -d "$1" +%s
}
#============================================================================}


#============================================================================{
##       # Depends on local timezone,

#   date -d @1707891682 "+%Y-%m-%d %H:%M:%S"
#  2024-02-14 07:21:22

F_From_Epoch() 
{
    date -d @$1 "+%Y-%m-%d %H:%M:%S"
}
#============================================================================}
