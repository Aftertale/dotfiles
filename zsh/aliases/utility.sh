#!/bin/zsh
alias vi="lvim"
alias -g cat="bat"
alias pip="pip3"

function shortenPath {
  longpath="$1"
  declare -a patharray
  patharray=(${(s:/:)longpath})
  echo $patharray
}

function ohshitmemcachedrestarted {
  kubectl -n memcached rollout restart statefulset memcached-prod && echo "restarted memcached" || echo "failed to restart memcached"
  kubectl -n memcached rollout status statefulset memcached-prod

  kubectl -n dc-falcon-prod rollout restart deploy dc-falcon
  kubectl -n dc-falcon-prod rollout status deployment dc-falcon

  kubectl -n dc-callcenter-prod rollout restart deploy dc-callcenter
  kubectl -n dc-callcenter-prod rollout status deploy dc-callcenter

  kubectl -n dc-externalordertracker-prod rollout restart deploy dc-externalordertracker
  kubectl -n dc-externalordertracker-prod rollout status deploy dc-externalordertracker

  kubectl -n dc-customertransfer-prod rollout restart deploy dc-customertransfer
  kubectl -n dc-customertransfer-prod rollout status deploy dc-customertransfer

  kubectl -n dc-vault-extranet-prod rollout restart deploy dc-vault-extranet
  kubectl -n dc-vault-extranet-prod rollout status deploy dc-vault-extranet
}
