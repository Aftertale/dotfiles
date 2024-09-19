#!/bin/bash

export NOTES_BASE_DIR="$HOME/code/src/github.com/aftertale/blog"
function note() {
	printf -v datenow '%(%Y-%m-%d)T'
	while read line; do
		if [[ "$line" == "EOF" ]]; then
			return
		fi
		echo "$line" >>"${NOTES_BASE_DIR}/${datenow%/*}.md"
	done
}

function vinote() {
	case "$@" in
	"save")
		pushd "${NOTES_BASE_DIR}"
		git add .
		git commit -m "notes update"
		git pull
		git push
		;;
	*)
		printf -v datenow '%(%Y-%m-%d)T'
		$(which nvim) "${NOTES_BASE_DIR}/${datenow%/*}.md"
		;;
	esac
}
