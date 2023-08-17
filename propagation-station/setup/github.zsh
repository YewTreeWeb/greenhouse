#!/bin/zsh

### Get required file ###
if [[ -e fertilise ]]; then
	cd "$(dirname "$DIR")" \
		&& . "./fertilise"
else
	printf "\n ⚠️ ./fertilise not found.\n"
	exit 1
fi

#############################################
# Add ssh-key to GitHub via api
# Reference new-computer github account
#############################################

heading "Adding ssh-key to GitHub (via api)..."
read -p "Would you like to add your ssh key to Github? Y/n " useGithub

if [[ $useGithub =~ ^([yY])$ ]]; then
	cecho "Important! For this step, use a github personal token with the admin:public_key permission." $yellow
	cecho "If you don't have one, create it here: https://github.com/settings/tokens/new" $yellow
	retries=3
	SSH_KEY=`cat $HOME/.ssh/id_rsa.pub`

	for ((i=0; i<retries; i++)); do
		read -p 'GitHub username: ' ghusername
		read -p 'Machine name: ' ghtitle
		read -sp 'GitHub personal token: ' ghtoken

		gh_status_code=$(curl -o /dev/null -s -w "%{http_code}\n" -u "$ghusername:$ghtoken" -d '{"title":"'$ghtitle'","key":"'"$SSH_KEY"'"}' 'https://api.github.com/user/keys')

		if (( $gh_status_code -eq == 201)); then
			cecho "GitHub ssh key added successfully!" $green
			break
		else
			cecho "${bold}Something went wrong${normal}. Enter your credentials and try again..." $yellow
			echo -n "Status code returned: "
			echo $gh_status_code
		fi
	done

	[[ $retries -eq i ]] && cecho "Adding ssh-key to GitHub failed! Try again later." $red
	printf "\n"

	# Add Github to ssh config file
	add_github_host
	# Authenticate with Github
	gh auth login
else
	cecho "Adding ssh-key to GitHub aborted. Skipping... " $dim
fi
