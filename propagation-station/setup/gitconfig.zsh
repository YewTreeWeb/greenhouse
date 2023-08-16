#!/bin/zsh

### Get required file ###
if [[ -e fertilise ]]; then
	cd "$(dirname "$DIR")" \
		&& . "./fertilise"
else
	printf "\n ⚠️ ./fertilise not found.\n"
	exit 1
fi

##############################
# Add git user config data #
##############################

heading "Creating gitconfig and adding user info to file..."

step "Creating gitconfig..."
if [[ ! -f "$HOME/.gitconfig" ]];
then
	touch $HOME/.gitconfig
else
	cecho "A gitconfig already exists. Skipping..." $dim
fi

step "Configuring gitconfig..."
read -p "What username would you like to add to the gitconfig file? Default is your user account ." gitUser

read -p "Enter the email you would like to add to the gitconfig file? Default is the SSH email you set earlier. " gitEmail

read -p "What would you like your default main branch to be called? Default will be master. `cecho $'\nhint: Names commonly chosen instead of 'master' are 'main', 'trunk' and 'development'. You can renamed via this command: git branch -m <name> at any time' $dim``printf $'\n> '` " gitBranchName

read -p "What would you like your default pull request to be? Default will be merge. `cecho $'\nhint: git config pull.rebase false (merge), git config pull.rebase true (rebase), git config pull.ff only (fast-forward only).' $dim``printf $'\n> '``cecho $'\nhint: Default will be pull.rebase false. You can renamed via this command: git config --global <pull-type> at any time.' $dim``printf $'\n> '` " gitPullRequest
br=${gitBranchName:-master}
pr=${gitPullRequest:-pull.rebase false}

step "Adding Git config data..."
git config --global user.name "${gitUser:-$USER}"
git config --global user.email "${gitEmail:-$sshEmail}"
git config --global init.defaultBranch $br
git config --global $pr

cecho "Git user data has been successfully added to .gitconfig" $green
