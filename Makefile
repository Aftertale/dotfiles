ROOT_DIR="$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))"
HOME_DIR=$(shell echo $${HOME})
SHELL := /bin/zsh

install: brew install_kitty install_prezto

brew: 
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash 

install_prezto:
	-rm -rf $(HOME_DIR)/.zcompdump* $(HOME_DIR)/.zhistory $(HOME_DIR)/.zlog* $(HOME_DIR)/.zprezto $(HOME_DIR)/.zpreztorc $(HOME_DIR)/.zprofile $(HOME_DIR)/.zshenv $(HOME_DIR)/.zshrc
	git clone --recursive https://github.com/Aftertale/prezto.git $(HOME_DIR)/.zprezto

	setopt EXTENDED_GLOB; for rcfile in $(HOME_DIR)/.zprezto/runcoms/^README.md(.N); do \
		ln -s "$$rcfile" "$(HOME_DIR)/.$${rcfile:t}" ; \
	done

install_kitty: brew
	brew install kitty

path:
	echo $(ROOT_DIR)
