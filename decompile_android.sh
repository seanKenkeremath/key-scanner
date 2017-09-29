#!/bin/bash

usage="Usage: $0 -a [apk_file] [options] \n\nOptions:\n\n-v Verbose mode: all logs are turned on\n\n"

# delete any previous decompiles
rm -rf search

apk_file=""

VERBOSE=false

redirect_cmd() {
    # write your test however you want; this just tests if SILENT is non-empty
    if $VERBOSE; then
        "$@" 
    else
        "$@" > /dev/null 2>&1
    fi
}

while getopts va: o
do	case "$o" in
	v)	VERBOSE=true;;
	a)	apk_file="$OPTARG";;
	[?])	echo >&2 $usage
		exit 1;;
	esac
done

if [ -z "$apk_file" ]
  then
    echo "Must specify file to decompile"
    echo -e $usage
    exit 1
fi

if [ ! -f $apk_file ] 
	then
    echo "Apk file $apk_file not found"
    echo -e $usage
    exit 1
fi

echo "Decompiling source files to search/javafiles..."
redirect_cmd d2j/d2j-dex2jar.sh -o classes.jar "$apk_file"
redirect_cmd jd/jd-cli -od search/javafiles classes.jar
echo "Decompiling resources to search/res..."
redirect_cmd java -jar apktool/apktool_2.3.0.jar d -o search/res -s "$apk_file"

echo "Cleaning up temporary files"
rm search/res/*.dex
rm classes.jar