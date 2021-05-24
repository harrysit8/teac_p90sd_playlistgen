#!/usr/local/bin/bash

lightblue="\033[96m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
white="\033[0m"
blue="\033[94m"
grey="\033[90m"
purple="\033[95m"

Cprint() {
    if [[ $3 == n ]]; then echo -ne ${!2}$1$white;
    else echo -e ${!2}$1$white; fi
}
print() {
    if [[ $2 == n ]]; then echo -ne $1;
    else echo -e $1; fi
}

gen() {
    local inputDir=$@
    local currentDir=$(echo "$@" | sed 's#.*/##')
    echo "$inputDir & $currentDir"
    for i in "$inputDir"/*; do
        local item=$i
        if [ -d "$item" ]; then
            echo "Directory [[$item]] found, parsing..."
            gen $item
            echo "subfolder playlist ready, appending...$path/$(basename "$item").ppl to $currentDir.ppl"
            cat "$path/$(basename "$item").ppl" >>"$currentDir.ppl"

        else
            echo "Matching extension to corresponding digit..."
            typeDIG=0
            if [[ $(tr "[:upper:]" "[:lower:]" <<<"${item##*.}") = $(tr "[:upper:]" "[:lower:]" <<<"wav") ]]; then
                typeDIG=2
            elif [[ $(tr "[:upper:]" "[:lower:]" <<<"${item##*.}") = $(tr "[:upper:]" "[:lower:]" <<<"flac") ]]; then
                typeDIG=4
            fi
            OUTpathname="${item#"$path"}"
            OUTpathname="${OUTpathname////\\}"
            if [ $typeDIG -ne 0 ]; then
                echo "appending $item into $currentDir.ppl"
                echo "\"E:$OUTpathname\"",$typeDIG,"\"\"","\"\"",$rand,0,$(($rand - 1)) >>"$currentDir.ppl"
            else
                echo "The extension digit is unknown, skipping $(basename "$item")........."
            fi

        fi

    done
}

path=$(pwd)
rand=$(date +%s)
rand=${rand: -5}
rm -f *.ppl
gen $path

shopt -s dotglob
if [ ! -d PLAYLISTS ]; then
    mkdir PLAYLISTS
fi
mv *.ppl PLAYLISTS/
shopt -u dotglob