#!/bin/bash

function conf() {
	case "$@" in
	"alacritty")
		vi $HOME/.config/alacritty/alacritty.toml
		;;
	"keyboard")
		vi $HOME/qmk_firmware/keyboards/controllerworks/mini42/keymaps/aftertale/keymap.c
		;;
	*)
		echo "not yet implemented"
		;;
	esac
}
