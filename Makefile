SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

brew: 
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash 

fish: brew
	brew install fish

nvim: fish
	ln -sf $(SCRIPTPATH)/nvim $${HOME}/nvim/init.lua
