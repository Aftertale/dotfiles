#!/bin/bash

function qtilectl() {
	case "$@" in
	"logs" | "log")
		tail -f ~/.local/share/qtile/qtile.log
		;;
	"config")
		open ~/.config/qtile/config.py
		;;
	*)
		echo "dunno what do"
		;;
	esac
}
