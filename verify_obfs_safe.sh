#!/bin/bash


#This script runs against both obfuscated and nonobfuscated versions of the app to prevent false negatives in search.
#It will only pass if ALL strings are present in nonobfuscated version and NO strings are present in obfuscated version

#Note: In this particular script (for use on build server), the order of the arguments matters, and all arguments are required. 
#I implemented it this way just for convenience in passing args to other scripts
#TODO: make order not matter
usage="Usage: $0 [-s strings_file] [-p obfs_app_file] [-m unobfs_app_file] [-a || -i]"

#Should find now strings in the obfuscated version
./verify_obfs.sh $1 $2 $3 $4 $7
obfs_result=$?

#Should find all strings in nonobfuscated
./verify_obfs.sh $1 $2 -p $6 $7
unobfs_result=$?

if [[ $obfs_result -eq 0 && $unobfs_result -eq 2 ]]; then
	exit 0;
fi

exit 1;