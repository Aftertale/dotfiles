ROOT_DIR="$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))"

brew: 
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | /bin/bash 

install_shell:
	test -d && ${{HOME}/.config/zsh && rm -rf $${HOME}/.config/zsh
	mkdir -p $${HOME}/.config/zsh
	ln -s $(ROOT_DIR)/zsh/prezto $${HOME}/.config/zsh/.zprezto
	test -f ${{HOME}}/.zshrc && rm $${HOME}/.zshrc
	ln -s $(ROOT_DIR)/zsh/functions $${HOME}/.config/zsh/functions
	ln -s $(ROOT_DIR)/zsh/aliases $${HOME}/.config/zsh/aliases
	ln -s $(ROOT_DIR)/zsh/completions $${HOME}/.config/zsh/completions
	ln -s $(ROOT_DIR)/zsh/util $${HOME}/.config/zsh/util

	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zlogin $${HOME}/.config/zsh/.zlogin
	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zlogout $${HOME}/.config/zsh/.zlogout
	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zpreztorc $${HOME}/.config/zsh/.zpreztorc
	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zprofile $${HOME}/.config/zsh/.zprofile
	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zshenv $${HOME}/.config/zsh/.zshenv
	ln -s $(ROOT_DIR)/zsh/prezto/runcoms/zshrc $${HOME}/.config/zsh/.zshrc

install_kitty: brew
	brew install kitty

path:
	echo $(ROOT_DIR)
