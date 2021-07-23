#!/usr/local/bin/bash
version="23.7.21"
author="harrysit8"
license="MIT"

white="\033[0m"
grey="\033[90m"
red="\033[91m"
green="\033[92m"
yellow="\033[93m"
blue="\033[94m"
purple="\033[95m"
lightblue="\033[96m"

Cprint() {
    if [[ "$3" == + ]]; then echo -ne ${!2}$1$white;
    else echo -e ${!2}$1$white; fi
}
print() {
    if [[ "$2" == + ]]; then echo -ne "$1";
    else echo -e "$1"; fi
}

gen() {
    local inputDir=$@
    local currentDir=$(echo "$@" | sed 's#.*/##')
    #echo "$inputDir & $currentDir"
    for i in "$inputDir"/*; do
        local item=$i
        local item_basename=$(basename "$item")
        if [ "$item_basename" = "PLAYLISTS" ]  || [ "$item_basename" = "genplaylist.sh" ]; then
            continue         
        else 
            if [ -d "$item" ]; then
                print "Directory " +; Cprint "[$item]" lightblue +; print " found, parsing..."
                gen $item
                Cprint "subfolder playlist ready, appending $blue$path/$(basename "$item").ppl$green to $lightblue$currentDir.ppl$green" green
                cat "$path/$(basename "$item").ppl" >>"$currentDir.ppl"

            else
                print "$item"
                Cprint "Matching extension to corresponding digit..." grey
                typeDIG=0
                if [[ $(tr "[:upper:]" "[:lower:]" <<<"${item##*.}") = $(tr "[:upper:]" "[:lower:]" <<<"wav") ]]; then
                    typeDIG=2
                elif [[ $(tr "[:upper:]" "[:lower:]" <<<"${item##*.}") = $(tr "[:upper:]" "[:lower:]" <<<"flac") ]]; then
                    typeDIG=4
                elif [[ $(tr "[:upper:]" "[:lower:]" <<<"${item##*.}") = $(tr "[:upper:]" "[:lower:]" <<<"m4a") ]]; then
                    typeDIG=9
                fi
                OUTpathname="${item#"$path"}"
                OUTpathname="${OUTpathname////\\}"
                if [ $typeDIG -ne 0 ]; then
                    Cprint "appending $item into $currentDir.ppl" grey
                    echo "\"E:$OUTpathname\"",$typeDIG,"\"\"","\"\"",$rand,0,$(($rand - 1)) >>"$currentDir.ppl"
                else
                    Cprint "The extension digit of $purple$(basename "$item")$yellow is unknown, skipping" yellow
                fi

            fi
        fi
    done
}
print "$(basename $BASH_SOURCE) - $version, @$author"

path=$(pwd)
rand=$(date +%s)
rand=${rand: -5}
rm -f *.ppl
gen $path

shopt -s dotglob
if [ ! -d PLAYLISTS ]; then
    mkdir PLAYLISTS
else
    rm -rf PLAYLISTS.backup
    mv PLAYLISTS PLAYLISTS.backup
    mkdir PLAYLISTS
fi
mv *.ppl PLAYLISTS/
shopt -u dotglob