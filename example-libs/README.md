

# README:

My English is not perfect, but I hope you will understand.
Some improvements have been made for better readability.

### 1. Every function starts with  F_
    for exmaple: F_Green_Echo , F_Yellow_Echo

### 2. Each new variable uses uppercase and lowercase letters
    to distinguish it from system variables.
    But appropriate syntax color in a text editor improves readability.

### 3. "readonly" will make variable immutable
        and if you will try change this variable,
        you will have error: "readonly variable"

### 4. Each library contains a version number and must be commented with "#".
    What I mean is that bash shouldn't read the "Version" variable directly
     from the libraries, because every library will overwrite this variable.

### 5. Dependencies.

####    5.1 In default we load library that way:

        source lib-your-library-name.bash

I recommend a more reliable method:
(At least until Bash will improved.)

        #=================================={
        #--------------------------{
        ##  Safeguard
        Source_If_Exist() {
            if [[ -f "$1" ]] ; then
                source "$1"
            else
                echo "Error: Source not found: $1"
                exit 1
            fi
        }
        #--------------------------}

        Path_Of_Script="$(dirname "$(realpath $0)")"
        Source_If_Exist "$Path_Of_Script"/lib/lib-1-basic-messages.bash
        Source_If_Exist "$Path_Of_Script"/lib/lib-your-library-name.bash
        #==================================}

Advantages of this way:

- If the library has the wrong name or does not exist, 
    then script will terminate with an error.

- Regardless of which directory you run the script from,
    the library should always be loaded.


####    5.2 Some libraries use other libraries.
    This is usually mentioned at the beginning of the file.
    For example if want use lib-2-colorful-messages.bash,
    then you should use also lib-1-basic-messages.bash.


### 6. If you need more advice for bash, then you can check
" Good advices for bash developer. "
<https://forums.linuxmint.com/viewtopic.php?t=342766>


