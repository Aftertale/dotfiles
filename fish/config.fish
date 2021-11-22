if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
alias vi="nvim"
alias gocode="cd $HOME/code/src/github.com/updater"
alias code="codium"

set vpntypes corp prod devqa sysops ucore
set vpnlocations atl mia
function vc --description "<type> <location>"
  if not contains $argv[1] $vpntypes
    echo "first argument must be one of vpntypes: "
    echo $vpntypes
    return 1
  end
  if not contains $argv[2] $vpnlocations
    echo "second argument must be one of locations: "
    echo $vpnlocations
    return 1
  end
  /opt/cisco/anyconnect/bin/vpn connect vpn-$argv[1]-$argv[2].updater.com
end 

function mkcd
  mkdir $argv; and cd $argv; or echo "failed to create $argv"
end

# Git aliases
function gclone
  git clone $argv; and cd (string split -r -m1 / $argv)[2]; or return 1
end
alias gnew="git checkout -b"

thefuck --alias | source

source /usr/local/opt/asdf/libexec/asdf.fish

# Simple Aliases:
alias ls=exa
alias git=hub
