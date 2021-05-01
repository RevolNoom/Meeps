#!/usr/bin/bash

OUTPUT_FILE="meep.asm"

if [ $# -eq 1 ] && [ "$1" = "-h" ] || [ "$1" = "--help" ]
then
	echo "Usage: meep.bash [-h|--help] [FILE] ..."
	echo "	With -h or --help, show this help"
	echo "	Without any files, Meep scans the current directory for all *.asm files, "
	echo "	and then join them into one file named $OUTPUT_FILE."
	echo "	(If you already have it, it will be overwritten. So take care!)"
	echo 
	echo "	If you supplied Meep some file, it will join them into $OUTPUT_FILE instead."
	exit 0
fi

if [ $# -eq 0 ] # Default use case: No argument
then
	INPUT_FILE=`ls *.asm 2>/dev/null` 
else
	INPUT_FILE=`echo "$*" | tr [:blank:] "\n"`
fi

# Unite all *.asm file together into a file named $OUTPUT_FILE
# (except the $OUTPUT_FILE itself, if exists)
INPUT_FILE=`echo $INPUT_FILE | sed "s/\b$OUTPUT_FILE\b//g"`

echo "In Meep's hands are:"
echo
echo "$INPUT_FILE"
echo 
echo "The files melt into one. Only $OUTPUT_FILE remains."

cat $INPUT_FILE > $OUTPUT_FILE
