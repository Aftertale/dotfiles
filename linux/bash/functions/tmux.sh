#!/bin/bash

function mux() {
	case "#@" in
	"start"*)
		if [[ -n $2 ]]; then
			tmux -f "$2"
		else
			start_tmux_info
		fi
		;;
	*)
		echo "not yet supported"
		;;
	esac
}

function start_tmux_info() {
	SESSION="infotainment"
	tmux new-session -d -s $SESSION
	tmux rename-window -t $SESSION 'Main'
	tmux split-window -t $SESSION
	tmux send-keys -t $SESSION 'spt' C-m
	tmux split-window -t $SESSION
	tmux select-layout -t $SESSION main-vertical

	tmux attach -t $SESSION
}
