#!/bin/zsh

_cd() 
{
  local dirs=($(fd --hidden --follow --type=d))
  compadd -a -f dirs
}

_cda() 
{
  local cur opts
  # local prev
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  # prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="one two three"
  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  return 0
}
