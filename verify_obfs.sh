#!/bin/bash

strings_file=""
apk_file=""

usage="Usage: $0 [-s strings_file] [-a apk_file]"

while getopts s:a: o
do	case "$o" in
	s)	strings_file="$OPTARG";;
	a)	apk_file="$OPTARG";;
	[?])	echo >&2 $usage
		exit 1;;
	esac
done

#both input files are required
if [[ "$strings_file" = "" ||  "$apk_file" = "" ]]
	then
	echo "Missing Arguments"
	echo >&2 $usage
	exit 1
fi

sh ./decompile_android.sh -a "$apk_file" -v

echo "Searching for strings.."
#Loop through all lines in strings.txt -- new line delimited. Last line always caught regardless of newline
 while read p || [[ -n $p ]]; do
   grep -or "$p" search
 done < $strings_file

rm -rf search