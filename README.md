# obfuscation-verification-script
A script and tools to verify that an app has been obfuscated

# Running the scripts
There are two types of scripts that can be run. ```decompile_android.sh``` or ```decompile_ios.sh``` will decompile the app into a folder called "search" that can be looked through manually. ```verify_obfs.sh``` Will decompile the app (using ```decompile_android.sh``` and then search for every string specified in the input file argument you provide. A properly obfuscated app should not find any of these strings.

NOTE: This script will most like only work on MacOS. Whatever machine is running this must also have access to the ```strings``` command (built into MacOS)

*TODO:* This is a work in progress. The script eventually should match strings on a non-obfuscated version of the app first to make sure they're all there and then check that the obfuscated version contains none. This will prevent false negatives and ensure that the correct strings are provided to the script and the decompilation is happening correctly. Currently the script just decompiles, then prints out the strings it found vs what it did not find

### Running decompile_android.sh
To manually search through files, use:

```sh decompile_android.sh -p {path_to_apk}```

The output will be in ```./search```. Both resources and source files will be put into this folder.

Optionally ```-v``` can be added for Verbose mode (prints all logs)

### Running decompile_ios.sh
To manually search through files, use:

```sh decompile_ios.sh -p {path_to_ipa}```

The output will be in ```./search```. Right now the script just parses all PLists and dumps strings from the binary into a ```strings.txt``` file. 

Optionally ```-v``` can be added for Verbose mode (prints all logs)

### Running verify_obfs.sh
To run the automated search, use:

```sh verify_obfs.sh -p {path_to_app} -s {file containing new line delimited list of strings} [-a or -i]```
Specify either -a for Android or -i for iOS. All arguments are required.

The script will decompile and print out any strings it finds.

# TODOs:
* Add labels to string input file to make outputs easier to read
* Proguard mapping support for verifying code 
* Dexguard mapping support for verifying code
* Ixguard?
* Logs
* Integrate with build server
* Protect against false negatives by comparing unobfuscated app vs obfuscate app results
