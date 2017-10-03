#!/bin/bash

strings_file=""
app_file=""
decompile_script=""

usage="Usage: $0 [-s strings_file] [-p app_file] [--a || --i]"

while getopts s:p:ia o
do	case "$o" in
	s)	strings_file="$OPTARG";;
	p)	app_file="$OPTARG";;
	i)	decompile_script="decompile_ios.sh";;
	a)	decompile_script="decompile_android.sh";;
	[?])	echo >&2 $usage
		exit 1;;
	esac
done

#both input files are required
if [[ "$strings_file" = "" ||  "$app_file" = "" || "$decompile_script" = "" ]]
	then
	echo "Missing Arguments"
	echo >&2 $usage
	exit 1
fi

echo "Running $decompile_script"

sh ./"$decompile_script" -p "$app_file" -v

total_strings=0
strings_found=0
string_exists=false
tmp_file="obfs_temp.tmp"
found_strings_list=()
not_found_strings_list=()

echo "Searching for strings.."
#Loop through all lines in strings.txt -- new line delimited. Last line always caught regardless of newline
 while read p || [[ -n $p ]]; do
 	string_exists=false
 	grep -or "$p" search > $tmp_file
	while read -r line; do
		string_exists=true
	    echo "STRING FOUND: $line"
	done < $tmp_file
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

rm "$tmp_file"
rm -rf search