#!/bin/bash

usage="Usage: $0 -p apk_file [-v]"
dir=$(dirname "$0")

# delete any previous decompiles
rm -rf $dir/search

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

while getopts vp: o
do	case "$o" in
	v)	VERBOSE=true;;
	p)	apk_file="$OPTARG";;
	[?])	echo >&2 $usage
		exit 1;;
	esac
done

if [ -z "$apk_file" ]
  then
    echo "Must specify file to decompile"
    echo $usage
    exit 1
fi

if [ ! -f $apk_file ] 
	then
    echo "Apk file $apk_file not found"
    echo $usage
    exit 1
fi

echo "Decompiling source files to $dir/search/javafiles..."
redirect_cmd $dir/d2j/d2j-dex2jar.sh -o $dir/classes.jar "$apk_file"
redirect_cmd $dir/jd/jd-cli -od $dir/search/javafiles $dir/classes.jar
echo "Decompiling resources to $dir/search/res..."
redirect_cmd java -jar $dir/apktool/apktool_2.3.0.jar d -o $dir/search/res -s "$apk_file"

echo "Cleaning up temporary files"
rm $dir/search/res/*.dex
rm $dir/classes.jar