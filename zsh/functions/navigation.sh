#!/bin/zsh
#

GREEN='\033[0;32m'
NC='\033[0m'
GOTOFILE_LOC=$HOME/.goto.yaml
declare -a gotopaths
export CURRENT_GOTO=""

function goto(){
  if [[ $# -eq 0 ]]; then
    gotoActive
  else
    case "$1" in
      "add"|"set"|"update"|"a"|"s"|"u")
        shift
        setLink "$@"
        ;;
      "delete"|"rm")
        shift
        deleteLink "$@"
        ;;
      "next"|"n")
        nextLink
        ;;
      "prev"|"p")
        prevLink
        ;;
      "list"|"ls")
        listLinks
        ;;
      "clear")
        clearLinks
        ;;
      "help"|"h")
        echo "add, update, remove, next, prev, list, help"
        ;;
      *)
        gotoLink "$@"
        ;;
    esac
  fi
}

function clearLinks(){
  rm -f $GOTOFILE_LOC
  touch $GOTOFILE_LOC
}

function __gotoLink(){
  # If not link provided, go to active
  [[ -z "$1" ]] && echo "No link name provided" && return 1
  linkName="$1"
  linkPath=$(yq -r ".quickLinks[] | select(.name == \"$linkName\") | .location" "$GOTOFILE_LOC")
  echo "Going to $linkPath"
  cd "$linkPath" || return 1
}

function gotoActive(){
  cd $(yq -r e '.quickLinks[] | select(.active == "true") | .location' "$GOTOFILE_LOC")
}

function setLink(){
  # 3 scenarios: no input=interactive, 1 input=link name, 2 inputs=link name and path
  linkName="$1"
  linkPath="$2"
  if [[ $# -eq 0 ]]; then
    read 'Name of Link: ' linkName
    read 'Path of Link: ' linkPath
    if [[ $linkPath == "" ]]; then
      linkPath=$PWD
    fi
  elif [[ $# -eq 1 ]]; then
    linkPath=$PWD
  fi

  # Create link
  __entryExists "$linkName" && __updateLink "$linkName" "$linkPath" || __createLink "$linkName" "$linkPath"

  # alias to the new link
  eval "alias $linkName='goto $linkName'"

  # Set new linke to active
  __updateCurrent "$linkName"
}

function __createLink(){
  linkName="$1"
  linkPath="$2"
  echo "got to createLink with values $1 and $2"
  yq -i e ".quickLinks += {\"name\": \"$linkName\", \"location\": \"$linkPath\", \"active\": \"false\"}" "$GOTOFILE_LOC"
}

function __updateLink(){
  linkName="$1"
  linkPath="$2"
  yq -i e "(.quickLinks[] | select(.name == \"$linkName\") | .location) = \"$linkPath\"" "$GOTOFILE_LOC"
}

function __updateCurrent(){
  newCurr="$1"
  yq -i e '(.quickLinks[] | select(.active == "true") | .active) = "false"' "$GOTOFILE_LOC"
  yq -i e "(.quickLinks[] | select(.name == \"$newCurr\") | .active) = \"true\"" "$GOTOFILE_LOC"
}

function __entryExists(){
  yq -e e ".quickLinks[] | select(.name == \"$1\")" "$GOTOFILE_LOC" &> /dev/null
}

# function __deleteLink(){

# }

function nextLink(){
  len=$(yq e '.quickLinks | length' "$GOTOFILE_LOC")
  curr=$(yq e '.quickLinks | to_entries | .[] | select(.value.active == "true") | .key' "$GOTOFILE_LOC")
  [[ $curr -lt $((len-1)) ]] && next=$((curr+1)) || next=0
  nextName=$(yq e ".quickLinks[$next].name" "$GOTOFILE_LOC")
  __updateCurrent "$nextName"
  __gotoLink "$nextName"
}

function prevLink(){
  len=$(yq e '.quickLinks | length' "$GOTOFILE_LOC")
  curr=$(yq e '.quickLinks | to_entries | .[] | select(.value.active == "true") | .key' "$GOTOFILE_LOC")
  [[ $curr -ne 0 ]] && next=$((curr-1)) || next=$((len-1))
  nextName=$(yq e ".quickLinks[$next].name" "$GOTOFILE_LOC")
  __updateCurrent "$nextName"
  __gotoLink "$nextName"
}

function listLinks(){
  declare -a allLinks
  allLinks=($(yq -r '.quickLinks[] | .name + ":" + .location + ":" + .active' "$GOTOFILE_LOC"))
  for link in $allLinks; do
    isActive="${link##*:}"
    foo="${link%:*}"
    [[ "$isActive" == "true" ]] && printf "${GREEN}%s\n" "$foo" || printf "${NC}%s\n" "$foo"
  done
}

# function __editLinks(){

# }
#
function c() {
  if [[ "$1" == '..' ]]; then
    cd ../
    return
  else
    cd "./$1" || cd "$1"
  fi
}

