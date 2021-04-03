#!/usr/local/bin/bash

gen(){
local inputDir=$@
local currentDir=$( echo "$@" | sed 's#.*/##' )
echo "$inputDir & $currentDir"
for i in "$inputDir"/*;
do 
    local item=$i
	if [ -d "$item" ]; then
		echo "Directory [[$item]] found, parsing..."
			gen $item
        echo "subfolder playlist ready, appending...$path/$(basename "$item").ppl to $currentDir.ppl"
        cat "$path/$(basename "$item").ppl" >> "$currentDir.ppl"
	
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
            echo "\"E:$OUTpathname\"",$typeDIG,"\"\"","\"\"",$rand,0,$(($rand-1)) >> "$currentDir.ppl"
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
mv *.ppl PLAYLISTS/
shopt -u dotglob