# obfuscation-verification-script
A script and tools to verify that an app has been obfuscated. Currently Android only

# Running the scripts
There are two scripts that can be run. ```decompile_android.sh``` will decompile the app (both resources and source files) into a folder called "search" that can be looked through manually. ```verify_obfs.sh``` Will decompile the app (using ```decompile_android.sh``` and then search for every string specified in the input file argument you provide. A properly obfuscated app should not find any of these strings.

*TODO:* This is a work in progress. The script eventually should match strings on a non-obfuscated version of the app first to make sure they're all there and then check that the obfuscated version contains none. This will prevent false negatives and ensure that the correct strings are provided to the script and the decompilation is happening correctly. Currently the script just decompiles, and then prints out all the strings it finds.

### Running decompile_android.sh
To manually search through files, use:

```sh decompile_android.sh {path_to_apk}```

The output will be in ```./search```

### Running verify_obfs.sh
To run the automated search, use:

```sh verify_obfs.sh -a {path_to_apk} -s {file containing new line delimited list of strings}```

The script will decompile and print out any strings it finds.


# TODOs:
* iOS decompilation
* Proguard mapping support for verifying code 
* Dexguard mapping support for verifying code
* Ixguard?
* Logs
* More human readable output
* Integrate with build server
* Protect against false negatives by comparing unobfuscated app vs obfuscate app results
