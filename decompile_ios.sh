#!/bin/bash

usage="Usage: $0 -p ipa_file [-v]"
dir=$(dirname "$0")

# delete any previous decompiles
rm -rf $dir/search

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
redirect_cmd unzip $ipa_file -d $dir/unzipped

mkdir $dir/search

#files are named dynamically, so we need to figure them out
package_name="$(ls $dir/unzipped/Payload | tail -n1)"
content_path="$dir/unzipped/Payload/$package_name"
frameworks_path="$dir/unzipped/Payload/$package_name/Frameworks"
bin_path="$content_path/$($dir/PlistBuddy -c "Print CFBundleExecutable" $dir/unzipped/Payload/$package_name/Info.plist)"

echo "Dumping strings from binary $bin_path to $dir/search/strings.txt..."
strings "$bin_path" > $dir/search/strings.txt

mkdir search/frameworks
echo "Dumping strings from frameworks in $frameworks_path"
for f in $frameworks_path/*; do
    echo "Dumping strings from $f to search/frameworks/"
  strings $f > "$dir/search/frameworks/$(basename "$f").txt"
done

echo "Dumping strings from plists in $content_path to $dir/search/plists..."
for f in $content_path/*.plist; do
    echo "Dumping $f"
  $dir/PlistBuddy -c "Print" "$f" > "$dir/search/$(basename "$f").txt"
done

echo "Cleaning up temporary files"
rm -rf $dir/unzipped