#!/bin/zsh
function fcd(){
  loc=""
  case "$1" in
    "config")
      loc="$(fd . $HOME/.config | fzf)"
      ;;
    "repo")
      [[ "$(git rev-parse --is-inside-work-tree)" == "true" ]] \
        && loc="$(fd . $(git rev-parse --show-toplevel) | fzf)" \
        || loc="$(fd . $HOME/code/src/github.com/updater | fzf)"
      ;;
    "all-repos")
      loc="$(fd . $HOME/code/src/github.com | fzf)"
      ;;
    *)
      loc="$(fd . $HOME | fzf)"
      ;;
  esac
  [[ -d "$loc" ]] && cd "$loc" || vi "$loc"
  # [[ "$(git rev-parse --is-inside-work-tree)" == "true" ]] \
  #   && loc="$(fd . $(git rev-parse --show-toplevel))"
  # [[ "$1" == "config" ]] \
  #   && loc="$(fd . $HOME/.config | fzf)" \
  #   || loc="$(fd . $HOME/code/src/github.com/updater | fzf)"
}

