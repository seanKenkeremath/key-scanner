#!/bin/bash

usage="Usage: $0 -p ipa_file [-v]"

# delete any previous decompiles
rm -rf search

ipa_file=""

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
	p)	ipa_file="$OPTARG";;
	[?])	echo >&2 $usage
		exit 1;;
	esac
done

if [ -z "$ipa_file" ]
  then
    echo "Must specify file to decompile"
    echo $usage
    exit 1
fi

if [ ! -f $ipa_file ] 
	then
    echo "IPA file $ipa_file not found"
    echo $usage
    exit 1
fi

echo "Unzipping $ipa_file"
redirect_cmd unzip $ipa_file -d unzipped

mkdir search

#files are named dynamically, so we need to figure them out
package_name="$(ls ./unzipped/Payload | tail -n1)"
content_path="./unzipped/Payload/$package_name"
bin_path="$content_path/$(./PlistBuddy -c "Print CFBundleExecutable" ./unzipped/Payload/$package_name/Info.plist)"

echo "Dumping strings from binary $bin_path to search/strings.txt..."
strings "$bin_path" > ./search/strings.txt

echo "Dumping strings from plists in $content_path to search/plists..."
for f in $content_path/*.plist; do
    echo "Dumping $f"
  ./PlistBuddy -c "Print" "$f" > "./search/$(basename "$f").txt"
done

echo "Cleaning up temporary files"
rm -rf unzipped