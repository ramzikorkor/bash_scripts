#!/bin/bash
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BROWN='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

#REPO1="...path"
#REPO2="...path"
#REPO3="...path"
#REPO4="...path"

 # Create REPOS array to be used in functions:
#REPOS=($REPO1 $REPO2 $REPO3 $REPO4)
#REPO_NAME=("REPO1" "REPO2" "REPO3" "REPO4")

# Add repo paths here:
LIBRARY="/c/Projects/repos/library/NearLo.RTS.API.AngularLibrary"
MOBILE="/c/Projects/repos/mobile/NearLo.Sp.Rts.Ionic.Mobile"
PORTAL="/c/Projects/repos/portal/NearLo-RTS-Ng-Portal"
FRAMEWORK="/c/Projects/repos/framework/NearLo.Framework"
 
 # Create REPOS array to be used in functions:
REPOS=($LIBRARY $MOBILE $PORTAL $FRAMEWORK)
REPO_NAME=("Library" "Mobile" "Portal" "Framework")

# Silences pushd & popd outputs:
function pushd () {
    command pushd "$@" > /dev/null
}

function popd () {
    command popd "$@" > /dev/null
}

function error_text() {
	printf "Usage: ./branch <command>\n"
	printf "where <command> is one of the following.\n"
	printf "update, prune, status\n"
	printf "\n"
	printf "./branch update - Updates REPOS with develop assuming the branches are on develop branch\n"
	printf "./branch prune - Prunes remote branches for all REPOS\n"
	printf "./branch status - Checks status for all REPOS\n"
}

function update_branches() {
	for index in ${!REPO_NAME[*]};
		do
			printf "= Updating branches for ${PURPLE}${REPO_NAME[$index]}${NC} with develop =\n"
			pushd "${REPOS[$index]}"
			BRANCH=$(git rev-parse --abbrev-ref HEAD)
				if [ "$BRANCH" == "develop" ]
				then
					OUTPUT=$(git pull)
					if [ "$OUTPUT" == "Already up to date." ]
					then
						printf "${GREEN}${OUTPUT}${NC}"
					fi
				else 
					printf "Not on branch develop, on Branch ${RED}$BRANCH${NC}\n"
				fi
				popd
		printf "\n\n"
	done
}

function prune_branches() {
	for index in ${!REPO_NAME[*]};
		do
			printf "= Pruning branches for ${PURPLE}${REPO_NAME[$index]}${NC} =\n"
			pushd "${REPOS[$index]}" && git remote prune origin && popd
			printf "\n\n"
	done
}

function branch_status() {
	for index in ${!REPO_NAME[*]};
		do
			printf "= Checking status for ${PURPLE}${REPO_NAME[$index]}${NC} =\n"
			
			pushd "${REPOS[$index]}" 
			BRANCH=$(git rev-parse --abbrev-ref HEAD)
			if [ "$BRANCH" == "develop" ]
				then
					printf "${GREEN}"
				else
					printf "${RED}"
			fi
			git status
			printf "${NC}"
			popd
			printf "\n\n"
	done
}

function check_user_inputs() {
	if [ "$#" -ne 1 ];
	then
		error_text
	elif [ "$1" == "update" ]
	then
		update_branches
	elif [ "$1" == "prune" ]
	then
		prune_branches
	elif [ "$1" == "status" ]
	then
		branch_status
	else
		error_text
	fi
}

function main() {
	check_user_inputs "$1"
}

main "$1"
