

# Mods

This folder contains scripts 

( Usually these are single commands handled by the bot. )

that are loaded automatically when certain conditions are met.


The script must contain at the beginning

```
#============================================================================={
Func_main_help_<name_of_your_script>.bash() {
		    echo " "
		    echo "      <your_command>  Your_Sentence   - <Explanation>."
}


Func_main_case_<name_of_your_script.bash>() {
    if [[ $1 == "<your_command>" ]] ; then
        Sentence="${@:2}"
        <Your_Function_Name> "$Sentence"
        Status_Break=break
    fi
}
#=============================================================================}

<Your_Function_Name>() {

}
```

- In angle brackets I marked what you need to change.
- " Func_main_help... "  It will display an explanation of your command in the help option ( --help -h h )
- " Func_main_case "  will run your script from <Your_Function_Name> if your command runs.

