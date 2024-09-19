#!/bin/bash

#function testMultiAccount() {
#
#}

function azActivate() {
	toActivate="$1" # should be dmcdowell-z or dmcdowell
	cp ~/.azureprofiles/${toActivate}.json ~/.azure/azureProfile.json
}

function azLogin() {
	/usr/bin/az login --allow-no-subscriptions
	cp ~/.azure/azureProfile.json ~/.azureprofiles/dmcdowell.json
}

function azLoginZ() {
	/usr/bin/az login
	cp ~/.azure/azureProfile.json ~/.azureprofiles/dmcdowell-z.json
}

# function az() {
# 	case "$@" in
# 	"login "*)
# 		/usr/bin/az login && grab-aks $2
# 		;;
# 	*)
# 		/usr/bin/az "$@"
# 		;;
# 	esac
# }
