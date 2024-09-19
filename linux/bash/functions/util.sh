#!/bin/bash

function cleard(){
  current=$(pwd)
  while true; do
    popd && popd || break
  done
  cd $current
}

function today(){
  date +"%Y-%m-%d"
}

function qq(){
  inFmt="json"
  while read -r data; do
      printf "%s" "$data"
  done
}

function installCert() {
  certFile="$1"
	if [[ certFile == "" ]]; then
		echo "Must specify a cert file"
    exit 1
	fi

  fileName=$(basename -- "$certFile")
  # determine if file is zip or pem
  extension="${filename##*.}"
  ((extension == "zip" ? _installCertZip certFile : _installCertPem certFile))
}

function _installCertZip() {
  sudo unzip "$1" -d /usr/local/share/ca-certificates/
  sudo update-ca-certificates
}

function _installCertPEM() {
  sudo mv "$1" /usr/local/share/ca-certificates/
  sudo update-ca-certificates
}

function mkcd() {
  mkdir "$1" && cd "$1"
}

function tmux_cheat() {
  man tmux | grep 'The default command' -A 60 | less
}

function wtfis() {
  curl "https://cheat.sh/$1"
}

# Directory listing
alias ls='lsd -F --sort=extension --color=auto'
alias ll='lsd -l'
alias lsl='lsd -alf'
alias la='lsd -A'
alias lsa='lsd -al'
alias l='lsd -CF'

# guard aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sd="cd ~ && cd \$(find * -type d | fzf)"

alias popdall="pushd -0 && dirs -c"

export NODE_OPTIONS=--use-openssl-ca
