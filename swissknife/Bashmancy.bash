#!/bin/bash

# This script updates the search path to include
# swissknife directory

#TOOLBOX_DIR=`realpath ${BASH_SOURCE[0]} | sed -E 's/[^/]+$//'`
TOOLBOX_DIR=`realpath ${BASH_SOURCE[0]} | xargs dirname`


# Exit when Shell is not sourced
if [ "$0" = "${BASH_SOURCE[0]}" ]
then
	echo "To wield the immense power of this artifact, you need to source it by:"
	echo "	source /this/script/absolute/path"
	echo "	source ./this/script/relative/path"
	echo "	or"
	echo "	. /this/script/absolute/path"
	echo "	. ./this/script/relative/path"
	echo
	echo "Come back when you have proved yourself."
	exit 0
fi

	
if [ "x$(echo "$PATH" | grep "$TOOLBOX_DIR" -)" != "x" ]
then
	echo "The Ancient Ones see your treacherous intents."
	echo "You won't get more than what they have already given."
else
	declare -a FinalWords=("The Ancient Script grants you the power of thousand generations." 
				"You feel a surge of power course through your vein." 
				"Suddenly, the flow of universe shows itself before your eye." )
	COUNT=0
	while [ "x${FinalWords[$COUNT]}" != "x" ]
	do
		COUNT=$((COUNT+1))
	done
	
	printf "${FinalWords[$RANDOM % $((COUNT))]}"
	PATH=$PATH:$TOOLBOX_DIR
	unset TOOLBOX_DIR
	echo ""
fi
