#!/bin/bash

#! /bin/bash 


# Destiny: 
#			This example script which use " own.bash.shell "
#
# Licence: GNU GPL v3
# Version: 1
# How use script:			bash own.bash.shell test.script.sh 

LOCK=0

F_IF $LOCK -eq 1
	echo "s 1"
	echo "s 2"

echo "s 3"
echo "LOCK = $LOCK"


F_WHILE $LOCK -le 9
	echo "The count is: $LOCK"
	F_IF $LOCK -eq 5
		echo "The LOCK is 5"

   ((LOCK++))




