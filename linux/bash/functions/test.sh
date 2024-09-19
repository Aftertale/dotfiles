#!/bin/bash

function SetDeviceProp() {
	PS3='Choose Device'
	tempFile="$HOME/temp/list.txt"
	xinput list | sed -r 's/\t.*//g' >$tempFile
	readarray -t options <$tempFile
	devID=""
	select opt in "${options[@]}"; do
		devID="$(xinput list | sed -rn 's;^'"$opt"'.*id=([0-9]*).*;\1;p')"
		break
	done
	echo "$devID"
	xinput list-props "$devID" >$tempFile
	readarray -t props <$tempFile
	select prop in "${props[@]}"; do
		echo "$prop"
	done
}
