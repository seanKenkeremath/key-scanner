#!/bin/bash

usage="Usage: $0 apk_file"

# delete any previous decompiles
rm -rf search

if [ -z "$1" ]
  then
    echo "Must specify file to decompile"
    echo $usage
    exit 1
fi

apk_file="$1"

if [ ! -f $1 ] 
	then
    echo "Apk file $1 not found"
    echo $usage
    exit 1
fi

echo "Decompiling source files to search/javafiles..."
d2j/d2j-dex2jar.sh -o classes.jar "$apk_file" > /dev/null 2>&1
jd/jd-cli -od search/javafiles classes.jar > /dev/null 2>&1
echo "Decompiling resources to search/res..."
java -jar apktool/apktool_2.3.0.jar d -o search/res -s "$apk_file" > /dev/null 2>&1

echo "Cleaning up temporary files"
rm search/res/*.dex
rm classes.jar