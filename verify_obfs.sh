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

total_strings=0
strings_found=0
string_exists=false
found_strings_list=()
not_found_strings_list=()

echo "Searching for strings.."
#Loop through all lines in strings.txt -- new line delimited. Last line always caught regardless of newline
 while read p || [[ -n $p ]]; do
 	string_exists=false
	while read -r line; do
		string_exists=true
	    echo "$string_exists STRING FOUND: $line"
	done < <(grep -or "$p" search)
	if $string_exists; then
		found_strings_list+=($p)
		strings_found=$((strings_found + 1))
	else
		not_found_strings_list+=($p)
	fi
	total_strings=$((total_strings + 1))
 done < $strings_file

 echo "$strings_found out of $total_strings strings found"
 echo ""
 echo "Not Found:"
 echo ""
 printf '%s\n' "${not_found_strings_list[@]}"
 echo ""
 echo "Found:"
 echo ""
 printf '%s\n' "${found_strings_list[@]}"

rm -rf search