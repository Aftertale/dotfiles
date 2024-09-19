# Functions for quick configuration of terminal
#
# Alacritty
function _opacity() {
	case "$@" in
	+* | increase*)
		_increaseOpacity "$@"
		;;
	-* | decrease*)
		_decreaseOpacity "$@"
		;;
	esac
}

function _increaseOpacity() {
	curr=$(sed)
}
