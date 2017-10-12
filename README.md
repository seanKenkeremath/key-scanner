# obfuscation-verification-script
A script and tools to verify that an app has been obfuscated

# Running the scripts
There are two types of scripts that can be run. ```decompile_android.sh``` or ```decompile_ios.sh``` will decompile the app into a folder called "search" that can be looked through manually. ```verify_obfs.sh``` and ```verify_obfs_safe.sh``` Will decompile the app (using ```decompile_android.sh``` and then search for every string specified in the input file argument you provide.

NOTE: This script will most like only work on MacOS. Whatever machine is running this must also have access to the ```strings``` command (built into MacOS)

### Running decompile_android.sh
To manually search through files, use:

```./decompile_android.sh -p {path_to_apk}```

The output will be in ```./search```. Both resources and source files will be put into this folder.

Optionally ```-v``` can be added for Verbose mode (prints all logs)

### Running decompile_ios.sh
To manually search through files, use:

```./decompile_ios.sh -p {path_to_ipa}```

The output will be in ```./search```. Right now the script just parses all PLists and dumps strings from the binary into a ```strings.txt``` file. 

Optionally ```-v``` can be added for Verbose mode (prints all logs)

### Running verify_obfs.sh
To run the automated search, use:

```./verify_obfs.sh -s {file containing input strings} -p {path_to_app} [-a or -i]```

Specify either -a for Android or -i for iOS. All arguments are required.

The input string files should be a new line delimited list of regex strings. The script will directly take the string and use it with grep. Keep in mind special characters have meaning in regex and in grep so you may need to escape some things. Regex wildcards such as using .* are supported. The grep command used on each line in the file is ```grep -or {line of input}``` if you want to test locally.

The script will decompile and print out any strings it finds.

The script will return an exit code of 1 if at least one string was found from input file, 2 if all strings were found, and 0 if no strings were found

### Running verify_obfs_safe.sh
To run the search, use:

```./verify_obfs_safe.sh -s {file containing new line delimited list of strings} -p {path_to_obfuscated_app} -m {path_to_unobfuscated_app}  [-a or -i] [-v]```
Specify either -a for Android or -i for iOS. All arguments are required except -v. **NOTE: ORDER OF THE ARGUMENTS MATTER**. I did it that way out of convenience, but I will fix it.

This script runs ```verify_obfs.sh``` on both the obfuscated and non-obfuscated versions of the app. Doing this provides extra security against false negatives. It will only return success (exit code 0) if ALL input strings were found in the unobfuscated version and NO input strings were found in the obfuscated version (it does this using exit codes from the other script). 

For example, if one of our input strings was entered as ```t3st_String``` when the real key is ```T3st_sTring```, running the regular ```verify_obfs.sh``` will still return a success because it technically didn't find that string anywhere (because it was mistyped). However, if we run ```verify_obfs_safe.sh``` and provide both versions of the app, it will fail.

# TODOs:
* Order of arguments should not matter for false negative search
* Add labels to string input file to make outputs easier to read?
* Proguard mapping support for verifying code 
* Dexguard mapping support for verifying code
* Ixguard?
* Logs
* Integrate with build server
