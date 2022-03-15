


README


This is only example shell based on " bash ".
The goal was to simplify the writing of bash scripts.

For example

I created 
================{
F_IF $LOCK -eq 1
	echo "s 1"
================}

Instead 
================{
if [ $LOCK -eq 1 ] ; then
	echo "s 1"
fi
================}

So the main goal is to automatically complete characters through the shell. 
A script which uses an additional shell 
- should be more readable.
- should take less space 
- should allow you to write scripts very quickly.


Output from test.script.sh
==============================={
$ bash bash.shell test.script.sh 
s 3
LOCK = 0
The count is: 0
The count is: 1
The count is: 2
The count is: 3
The count is: 4
The count is: 5
The LOCK is 5
The count is: 6
The count is: 7
The count is: 8
The count is: 9
=================================}



Conclusions from this experiment:

Benefits: 
+ I can create own commands and the code is smaller 
+ I can write bash scripts faster.


Disadvantages:
- For obvious reasons the script will run slower.
Because it use bash to process the script and then run it.
It is possible that with improved bash will run faster. 

- For me, the code is less readable.
Marking End and Start of a condition may be more readable  ( for example "if" and "fi" )

- Searching for bugs in the code can sometimes be more difficult.

- The sample script may not work with some online bash editors.
For example, a variable sometimes must have an escape character " \$VARIABLE ".

