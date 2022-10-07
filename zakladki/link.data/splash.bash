#!/bin/bash


# License:		GNU GPL v.3		http://www.gnu.org/licenses/gpl-3.0.en.html
# Destiny:		example splash screen for script


PLUS() {
    echo " "
    echo " h + Enter = help"
    echo " "
    sleep "$1"
    clear
    echo " "
}


FUNC_SPLASH() {
echo '  ||_||'
echo '  || ||'
PLUS 0.2
echo '  ||_|| ==== '
echo '  || ||  ||  '
PLUS 0.2
echo '  ||_|| ==== ==== '
echo '  || ||  ||   ||  '
PLUS 0.2
echo '  ||_|| ==== ==== |O) '
echo '  || ||  ||   ||  ||  '
PLUS 0.4
echo '  ||_|| ==== ==== |O) *  // // '
echo '  || ||  ||   ||  ||  * // //  '
PLUS 0.4
echo '  ||_|| ==== ==== |O) *  // //  \\    //'
echo '  || ||  ||   ||  ||  * // //    \\/\// '
PLUS 0.2
echo '  ||_|| ==== ==== |O) *  // //  \\    // \\    //'
echo '  || ||  ||   ||  ||  * // //    \\/\//   \\/\// '
PLUS 0.2
echo '  ||_|| ==== ==== |O) *  // //  \\    // \\    //  \\    // '
echo '  || ||  ||   ||  ||  * // //    \\/\//   \\/\//    \\/\// '
PLUS 0.2
echo '  ||_|| ==== ==== |O) *  // //  \\    // \\    //  \\    // '
echo '  || ||  ||   ||  ||  * // //    \\/\//   \\/\//    \\/\// *'
PLUS 0.2
}


