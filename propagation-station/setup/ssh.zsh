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
# Create a system SSH key #
# See: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
#############################################

heading "Creating system SSH key"

# Check if ssh folder exists.
if [[ ! -d "$HOME/.ssh/" ]]; then
	mkdir $HOME/.ssh
	sudo chown -R $(whoami):admin "$HOME/.ssh"
fi
if [ -f $HOME/.ssh/id_rsa ]; then
	cecho "SSH key 'id_rsa' found in ~/.ssh directory. Skipping... " $dim
	printf "\n"
else
	cd $HOME/.ssh
	step "Creating key and adding to agent."
	read -p 'Input email for ssh key: ' sshEmail
	ssh-keygen -t rsa -b 4096 -C "$sshEmail"  # will prompt for password
	eval "$(ssh-agent -s)"
	cd $location
fi

# If the OS version is equal to or higher than Sierra then ssh key will not be able to be saved to keychain.
step "Adding SSH key to keychain..."
ssh-add $HOME/.ssh/id_rsa
echo "# ssh keys" >> $HOME/.zshrc
echo "ssh-add $HOME/.ssh/id_rsa" >> $HOME/.zshrc
cecho "If you are running macOS Sierra or lower you can add the ssh key to your keygen" $dim
cecho "To add to keygen run ${bold}ssh-add -K $HOME/.ssh/id_rsa${normal}" $dim
printf "\n"

if [[ -e "$HOME/.ssh/config" ]]; then
	cecho "An SSH config file already exists. Skipping... " $dim
else
	step "Creating a new SSH config file with default settings..."
	create_ssh_config
	if [ $? -eq 0 ]; then
		cecho "Successfully created SSH config file." $green
	else
		cecho "Unable to create SSH config file." $red
	fi
fi
