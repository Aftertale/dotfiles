#!/bin/zsh

function sopse(){
  /usr/local/bin/sops -e --in-place "$1"
}

function sopsd(){
  /usr/local/bin/sops -d --in-place "$1"
}

function checkInput(){
  requiredArgs="$1"
  providedArgs=("${@:2}")
  if [[ "${#providedArgs[@]}" -eq "$requiredArgs" ]]; then
    return 0
  else
    return 1
  fi
}
