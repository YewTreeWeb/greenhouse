#!/bin/zsh

### Get required file ###
if [[ -e fertilise ]]; then
	cd "$(dirname "$DIR")" \
		&& . "./fertilise"
else
	printf "\n ⚠️ ./fertilise not found.\n"
	exit 1
fi

###############################################################################
# Setup Ruby and install Ruby gems #
###############################################################################

heading "Setting up Ruby and installing Ruby gems"

if test ! "$(which rbenv)"; then
	cecho "Unable to install latest Ruby version. Please check your Homebrew installation and try again." $red
	printf "\n"
else
	step "Configuring Ruby..."
	rubyVersion=$(rbenv install -l | grep -v - | tail -1)
	rbenv install $rubyVersion

	# Verify the state of your rbenv installation
	wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor -O- | bash

	rbenv local $rubyVersion
	rbenv global $rubyVersion
fi

# Choose between bundler install or gem install.
read -p "Would you like to install global Ruby gems with Bundler or with gem? b/g" rubyGems

if test ! "$(gem -v)"; then
	cecho "Unable to install Ruby gems.\n" $red
else
	step "Installing Ruby gems..."
	if [[ $rubyGems == 'b' ]];
	then
		if test ! "$(gem list bundler)"; then
			gem install bundler
		fi
		cd $HOME
		bundle init
		for bundle in $(<$location/seeds/bundles); do
			if test ! "$(bundle list | grep $bundle)"; then
				installing "Installing $bundle"
				bundle add $bundle >/dev/null
				cecho "${bold}✓ $bundle gem installed${normal}" $green
				printf "\n"
			else
				cecho "$bundle has already been installed. Skipped..." $dim
				printf "\n"
			fi
		done
		rbenv rehash
		cd $location
		printf "\n"
		cecho "Successfully installed Ruby gems with Bundler." $green
	else
		for gem in $(<$location/seeds/gems); do
			if test ! "$(gem list | grep $gem)"; then
				installing "Installing $gem"
				gem install $gem >/dev/null
				cecho "${bold}✓ $gem gem installed${normal}" $green
				printf "\n"
			else
				cecho "$gem has already been installed. Skipped..." $dim
				printf "\n"
			fi
		done
		rbenv rehash
		cecho "Successfully installed Ruby gems." $green
	fi

	# Create folder for Laravel
	if command -v jekyll &> /dev/null; then
		step "Adding custom Jekyll directory..."
		jekyll_dir_shortcut
		# Source your .zshrc to set up environment
		source $HOME/.zshrc
		cecho "Successfully add a custom Jekyll directory to the Sites directory." $green
	fi
fi
