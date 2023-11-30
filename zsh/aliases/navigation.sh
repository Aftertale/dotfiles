#!/bin/zsh

declare -A QUICKCD

function quickcd {
  if [[ -z "$1" ]]; then
    printf "Usage: quickcd <alias> [directory]\n"
    printf "Current aliases: \n"
    showAliases
    return 1
  fi
  if [[ "$1" == "clear" ]]; then
    unset QUICKCD
    removeAliases
    return 0
  fi
  NEWALIAS="$1"
  which "$NEWALIAS" > /dev/null && echo "Alias $NEWALIAS already exists" && return 1
  [[ -n "$2" ]] && DIR="$2" || DIR=$PWD
  eval "alias $NEWALIAS=\"cd $DIR\" && QUICKCD[$NEWALIAS]=$DIR || return 1"
}

function showAliases {
  for key val in ${(kv)QUICKCD}; do
    print "\t$key -> $val"
  done
}

function removeAliases {
  for key in ${(k)QUICKCD}; do
    unalias $key
  done
}
