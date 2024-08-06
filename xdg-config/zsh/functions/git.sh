#!/bin/zsh

# Function definitions for easier git schtuff

PROVIDER="ADO"
GIT_DEFAULT_ORG="CostcoWholesale"
GIT_DEFAULT_PROJECT="ECP"

# Git aliases
alias gunstage="git restore --staged "
alias k="kubectl"
alias gco='git checkout $(git branch | fzf)'
alias ga="git add "
alias gpl="git pull"
alias gpr="git pr create | jq -r '.url' | pbcopy"

# Set provider variable to github or azure devops
function _getRemoteType() {
  [[ "(pwd)" == *"dev.azure.com"* ]]
}

# function gp() {
# 	branchName=$(git rev-parse --abrev-ref HEAD)
# 	if [ "$branchName" = "main" ]; then
# 		echo "You are on the main branch! Checkout a new branch before you push!"
# 		exit 1
# 	fi
# 	hub push 2>/dev/null || git push 2>&1 | sed -n 's/.*\(git push.*\)/\1/p' | xargs command
# }

function git() {
	case "$@" in
	"env")
		echo "setting environment vars"
		;;

	"freak")
		echo "linking main to master"
		git symbolic-ref refs/heads/main refs/heads/master
		;;

	"clean")
		git branch --merged | egrep -v "(^\*|main|master)" | xargs git branch -d
		;;

	# override clone behavior to deal with ado sillyness
	"clone -ado "*)
		org="$GIT_DEFAULT_ORG"
		project="$GIT_DEFAULT_PROJECT"
		if [[ "$#" -eq 5 ]]; then
			repo="$5"
			project="$4"
			org="$3"
		elif [[ "$#" -eq 4 ]]; then
			repo="$4"
			project="$3"
		else
			repo="$3"
		fi
		/usr/bin/git clone https://${org}@dev.azure.com/${org}/${project}/_git/${repo}
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
  "feature"*)
    _create_new_git_branch_from_origin_main "$@"
    ;;

	"pull-request -v")
		/usr/bin/git pr view --web
		;;

	"pr")
		_getRemoteType &&
			az repos pr create ||
			gh pull-request
		;;

	"push")
		/usr/bin/git push || /usr/bin/git push --set-upstream origin $(/usr/bin/git branch --show-current)
		;;

	"unstage")
		gunstage
		;;

	"unstash")
		git stash pop
		;;

	"api "*)
		/usr/bin/git "$@"
		;;

	*)
		if [[ "$GIT_PROVIDER" == "github" ]]; then /opt/homebrew/bin/hub "$@"; else /usr/bin/git "$@"; fi
		;;
	esac
}

function _create_new_git_branch_from_origin_main() {
	task="$1"
	shift
	given_branch_name="$@"
	prefix="dmcdowell/${TASK}"
	# replaces spaces eg. ngb this is a new branch
	# will create branch ochambers/AKS-this-is-a-new-branch
	new_branch_name="${prefix}-${given_branch_name// /-}"

	git fetch origin main
	git checkout -b "${new_branch_name}" origin/main
	echo "git push -u origin ${new_branch_name}"
	git push -u origin "${new_branch_name}"
}

function gp() {
	git push || git push --set-upstream origin $(git branch --show-current)
}

function gpr() {
	# Get the most recent commit message
	if [ -z $last_commit_message]; then
		git pr create
		exit 0
	fi
	git pull-request -m $last_commit_message | pbcopy
}

function gcmtest() {
	PS3='Change type: '
	nouns=("feat" "fix" "refactor" "cancel")
	select noun in "${nouns[@]}"; do
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
		*) echo "invalid option $REPLY" ;;
		esac
	done
}

function grr() {
	pushd $(git rev-parse --show-toplevel)
}

function gokeeb() {
	pushd $HOME/qmk_firmware/keyboards/gmmk/pro/
}

function flushdns() {
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
}

function git-branch-clean() {
	git branch --merged | egrep -v "(^\*|main)" | xargs git branch -d
}

function setGitEnvVars() {
	export GITHUB_TOKEN=$(op item get Github --field label=personal_token)
}
