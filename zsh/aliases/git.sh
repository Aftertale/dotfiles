#!/bin/zsh

# Git aliases
alias gunstage="git restore --staged "
alias k="kubectl"
alias gco="git checkout"
alias ga="git add"
alias gpl="git pull"
alias gpr="git pull-request"
function gp() {
  branchName=$(git rev-parse --abrev-ref HEAD)
  if [ "$branchName" = "main" ]; then
    echo "You are on the main branch! Checkout a new branch before you push!"
    exit 1
  fi
  hub push 2>/dev/null || git push 2>&1 | sed -n 's/.*\(git push.*\)/\1/p' | xargs command
}

function git(){
  case "$@" in
    "env")
      echo "setting environment vars"
      setGitEnvVars
      ;;
    "freak")
      echo "linking main to master"
      git symbolic-ref refs/heads/main refs/heads/master
      ;;

    "clean")
      git branch --merged | egrep -v "(^\*|main|master)" | xargs git branch -d
      ;;

    "delete --olderthan"*)
      date=$3
      for item in $(git ls-files); do
        result=$(git --no-pager log --since "$date" -- $item)
        if [[ "$result" == "" ]]; then
          echo $item
          rm $item
        fi
      done
      ;;

    "pull-request -v")
      gh pr view --web
      ;;
      
    "unstage")
      gunstage
      ;;

    "unstash")
      git stash pop
      ;;

    "api "*)
      gh "$@"
      ;;

    *)
      if [[ -z "$GITHUB_TOKEN" ]]; then
        setGitEnvVars
      fi
      hub "$@"
      ;;
  esac
}


function gpr(){
  # Get the most recent commit message
  if [ -z $last_commit_message]; then
    git pull-request
    exit 0
  fi
  git pull-request -m $last_commit_message | pbcopy
}

function gcmtest() {
  PS3='Change type: '
  nouns=("feat" "fix" "refactor" "cancel")
  select noun in "${nouns[@]}"
  do
    case $noun in
      "feat")
        echo "you chose choice 1"
        ;;
      "fix")
        echo "you chose choice 2"
        ;;
      "refactor")
        echo "you chose choice $REPLY which is $noun"
        ;;
      "cancel")
        break
        ;;
    *) echo "invalid option $REPLY";;
    esac
  done
}

function gcm() {
  current=$(pwd)
  pushd $(git rev-parse --show-toplevel)
  changePath=$(git status | grep -e "modified" -e "new" -e "deleted" -m 1 | sed "s/.*: //g" | xargs)
  cmmessage="$argv[1](${changePath%/*}): ${argv[@]:2}"
  vared -p 'Is this message correct? [enter or edit] -> ' cmmessage
  eval "git commit -m \"$cmmessage\""
  cd $current
  export last_commit_message="$cmmessage"
}

function grr() {
  pushd $(git rev-parse --show-toplevel)
}

function gokeeb() {
  pushd $HOME/qmk_firmware/keyboards/gmmk/pro/
}

function flushdns() {
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}

function git-branch-clean() {
  git branch --merged | egrep -v "(^\*|main)" | xargs git branch -d
}

function releaseConsumerApp() {
  imageVersion="$1"
  hr="./apps/us-east-1/live/consumer-app-prod/consumer-app.yaml"
  cd ~/code/src/github.com/updater/kubernetes-clusters/
  current=$(git branch --show-current) 
  git checkout main
  git pull
  git branch --merged | egrep -v "(^\*|main)" | xargs git branch -d
  git checkout -b release-consumer-app
  sed -i '' "s/\(appVersion: \).*/\1${imageVersion}/" $hr
  newVersion=$(dasel select -f "$hr" '.spec.values.appVersion')
  if [ $imageVersion != $newVersion ]; then
    echo "Something went wrong, do your change manually."
    exit 1
  fi
  git add "$hr"    
  git commit -m "chore(apps/us-east-1/live/consumer-app-prod): release consumer app"
  gp
  url=$(git pull-request -m "chore(apps/us-east-1/live/consumer-app-prod): release consumer app ${imageVersion}")
  echo $url | pbcopy
  open $url
}

function alertRunFinished(){
  echo "can I see?"
  repo="$1"
  run_status="in_progress"
  counter=100
  while [[ $run_status == "in_progress" ]] && [[ "counter" -gt 0 ]]; do
    sleep 1
    runs=$(gh api -H 'Accept: application/vnd.github+json' "/repos/Updater/$repo/actions/runs")
    run_status=$(echo $runs | jq '.workflow_runs[0].status')
    counter=($counter-1)
  done 
  printf \\a
}

function setGitEnvVars(){
  export GITHUB_TOKEN=$(op item get Github --field label=personal_token)
}
