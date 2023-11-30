#!/bin/zsh

function shortenPath {
  longpath="$1"
  declare -a patharray
  patharray=(${(s:/:)longpath})
  echo $patharray
  # Loop through paths to find shortest unique path
  for i in "$patharray[@]"; do
    echo $i
  done
}

