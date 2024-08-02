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
# Setup shell environment #
##############################
step "Setting up the Shell environment..."
printf "\n\n"

# Check if Zsh is installed through Homebrew
if brew list zsh &> /dev/null; then
	cecho "Homebrew ZSH already installed. Updating..." $dim
	brew upgrade zsh
	if [ $? -eq 0 ]; then
		cecho "Updated ZSH successfully." $green
	fi
	printf '\n'
else
	brew install zsh
	# Switch to using brew-installed zsh as default shell
	if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
		echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
		chsh -s "${BREW_PREFIX}/bin/zsh";
	fi
	if [ $? -eq 0 ]; then
		cecho "Shell environment changed to ZSH." $green
	else
		cecho "Failed to install ZSH via Homebrew." $red
	fi
	printf '\n'
fi

##############################
# Use Fig #
##############################
heading "Use Fig"
# Check if Fig is installed
if command -v fig &> /dev/null; then
	cecho "Fig already installed. Skipping..." $dim
else
	# Check if ZSH is installed
	if command -v zsh &> /dev/null; then
		echo -n "Would you like to have your system managed by Fig? y/n/both `cecho $'\nhint: Choose both if you want manual control as well as Fig control' $dim``printf $'\n\n> '`"
		read useFig

		if [[ $useFig == "both" || $useFig =~ ^([yY])$ ]]; then
			brew install fig --cask
		fi
		install_zsh_dependecies
		# Remove system generated .zshrc and use Greenhouse's zsh file
		# step "Replacing system .zshrc with Greenhouse's .zshrc"
		if [ -f $HOME/.zshrc ]; then
			rm -rf $HOME/.zshrc
		fi
		if [[ $useFig == "both" ]]; then
			cp $location/seeds/profile/.zshrc-w-fig $HOME/.zshrc
		elif [[ $useFig =~ ^([yY])$ ]]; then
			cp $location/seeds/profile/.figZshrc $HOME/.zshrc
		else
			cp $location/seeds/profile/.zshrc $HOME/.zshrc
		fi
	else
		cecho "ZSH is not installed. Fig setup aborted" $red
	fi
fi

# Source your .zshrc to set up environment
source $HOME/.zshrc
