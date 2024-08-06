#!/bin/zsh
alias vaultup="vault login -path=/updater_okta -method=okta username='dillon.mcdowell@updater.com'"

function unseal(){
  targetHost="$1"
  if [ -z $UNSEAL1 ] || [ -z $UNSEAL2 ] || [ -z $UNSEAL3 ]; then
    echo "Must set UNSEAL env vars"
  else
    typeset -a unseals
    unseals=($UNSEAL1 $UNSEAL2 $UNSEAL3)
    for unseal in $unseals; do
      ssh -i "$HOME/Downloads/production.pem" ubuntu@$targetHost "VAULT_ADDR=http://127.0.0.1:8200 vault operator unseal $unseal"
    done
  fi
}


function status(){
  targetHost="$1"
  ssh -i "$HOME/Downloads/production.pem" ubuntu@$targetHost "VAULT_ADDR=http://127.0.0.1:8200 vault status"
}
