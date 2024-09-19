#!/bin/bash

alias get="sudo apt install -y"

alias vi="nvim"

alias bat="batcat"

alias cat="bat"

function _getInputDeviceID() {
	devID="$(xinput list | sed -rn 's/.*'"$1"'.*id=([0-9]*).*/\1/p')"
	echo "$devID"
}
