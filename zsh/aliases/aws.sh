#!/bin/zsh
#
function alo() {
  aws sso login
  [[ -n "$1" ]] && awsp "$1"
}

function awsp() {
  profiles="$(aws configure list-profiles)"
  if [[ "$1" == "list" ]]; then
    echo "$profiles"
    return 0
  fi
  awsProfile="$1"
  clusterARN="$(cat ~/.kube/config | profile=$awsProfile yq '.users[] | select(.user.exec.env[0].value == env(profile)) | .name')"
  kubectl config use-context "$clusterARN"
}

function sops() {
  awsProfile="live"
  case "$PWD" in
    *"live"*)
      awsProfile="live"
      ;;
    *"updater-prod"*)
      awsProfile="updater-prod"
      ;;
    *"updater-non-prod"*)
      awsProfile="updater-non-prod"
      ;;
    *)
      ;;
  esac
  AWS_PROFILE="$awsProfile" /usr/local/bin/sops "$@"
}
