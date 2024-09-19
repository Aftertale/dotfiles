#!/bin/bash

GO_TARGET=linux-amd64
export GOROOT=/usr/local/go
export GOPATH=$HOME/code
export GO_ARCHIVE_DIRECTORY="$HOME/.installs/go"
export PATH=$GOPATH/bin:$PATH

# Check if version is supplied by user
# effectively extends the go binary to download itself
function goenv() {
	case "$@" in
	"get "*)
		_goExists && return 0 || _goDownload "$@"
		;;
	"use "*)
		_goToNewVersion "$@"
		;;
	"rm "*)
		_goRemove "$@"
		;;
	*)
		_goEnvHelp
		;;
	esac
}

function _goList() {
	asdf list all golang
}

function _goDownload() {
	asdf install golang ${2}
}

# removes the current active version and installs the requested version
function _goToNewVersion() {
	asdf global golang ${2}
}

# removes the archive for the requested version. If that version is active, it remains so.
function _goRemove() {
	asdf uninstall golang ${2}
}

function _hasVersionParam() {
	[[ -n "$2" ]] && return 0 || return 1
}

function _goEnvHelp() {
	cat <<EOM

  [usage]
  goEnv <command> <version>
  
  commands:
    get [version]   Installs the specified version.
    use [version]   Uses the specified version if exists. Installs it if not.
    rm [version]    Removes the spefified go install from the archive. Does not remove active go install. Without version argument, uninstalls current go.
EOM
}

# use => download if !exists => rename archive to x.xx.x => remove current go => extract to current => done
# get => download if !exists => rename archive to x.xx.x => done
# rm => rm archive if exists

# json
# {
#   "goLangs": ["1.21.0", "1.22.0"]
#   "active": ["1.22.0"]
# }
