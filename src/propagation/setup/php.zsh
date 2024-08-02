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
# Fix PHP memory error #
##############################

heading "Fix PHP memory error"

step "Fixing PHP memory errors..."
# Resolve PHP Fatal error: Allowed memory size of 999999 bytes exhausted.
fix_php_memory

cecho "PHP memory error resolved" $green
printf "\n"

###############################################################################
# Install Composer and packages #
###############################################################################

heading "Installing Composer and packages"

echo -n "Would you like to install Composer? Y/n"
read iComposer
if [[ iComposer =~ ^([yY])$ ]]; then
	# Make sure the Brew PHP service has started.
	brew services start php

	if command -v composer &> /dev/null; then
		cecho "Composer already installed. Skipping..." $dim
	else
		brew install composer
		# Wait for the installation to finish
		while ps | grep -q "[b]rew install composer"; do
			sleep 5
		done

		if command -v composer &> /dev/null; then
			cecho "Successfully installed Composer." $green
		else
			cecho "Failed to install composer." $red
		fi
	fi

	if command -v composer &> /dev/null; then
		step "Installing Composer packages..."
		for composer in $(<$location/seeds/composer); do
			if test ! "$(composer global info | grep $composer)"; then
				installing "Installing $composer"
				composer global require $composer >/dev/null
				composer config --no-interaction allow-plugins.$composer true
				cecho "${bold}✓ $composer package installed${normal}" $green
				printf "\n"
			else
				cecho "$composer has already been installed. Skipped..." $dim
				printf "\n"
			fi
		done
	else
		cecho "Unable to install Composer packages. Please try again." $red
	fi

	# Park Laravel Valet
	if command -v valet &> /dev/null; then
		step "Setting Laravel Valet's default directory..."
		cd $HOME/Sites
		valet park
		# Create folder for static sites
		step "Adding custom directory for static sites..."
		static_dir_shortcut
		# Source your .zshrc to set up environment
		source $HOME/.zshrc
		cecho "Successfully set Laravel Valet's default directory to the Sites directory and created custom static directory." $green
	fi

	# Create folder for Laravel
	if command -v laravel &> /dev/null; then
		step "Adding custom Laravel directory..."
		laravel_dir_shortcut
		# Source your .zshrc to set up environment
		source $HOME/.zshrc
		cecho "Successfully add a custom Laravel directory to the Sites directory." $green
	fi
	cd $location
else
	cecho "Composer install aborted. Skipping..." $dim
	printf "\n"
fi

###############################################################################
# Install WP-CLI and packages #
###############################################################################

heading "Installing WP-CLI and packages"

if command -v wp &> /dev/null; then
	cecho "WP-CLI already installed. Skipping..." $dim
else
	echo -n "Would you like to install WP-CLI? Y/n"
	read wordpresscli
	if [[ $wordpresscli =~ ^([yY])$ ]];
	then
		brew install wp-cli

		# Add WP standards with Composer
		if command -v composer &> /dev/null; then
			composer global require phpcompatibility/phpcompatibility-wp:*
			composer config --no-interaction allow-plugins.phpcompatibility/phpcompatibility-wp:* true
			composer global require wp-coding-standards/wpcs
			composer config --no-interaction allow-plugins.wp-coding-standards/wpcs true
		fi

		# Add helpful aliases to .zshrc
		zsh_wpcli_aliases

		# Add custom directory for WordPress sites
		wp_dir_shortcut

		# Source your .zshrc to set up environment
		source $HOME/.zshrc

		cecho "Successfully installed WP-CLI." $green
	else
		cecho "WP-CLI installation aborted. Skipping..." $dim
	fi
fi

if [[ $wordpresscli =~ ^([yY])$ ]]; then
	if command -v wp &> /dev/null; then
		step "Installing WP-CLI packages..."
		for wp in $(<$location/seeds/wpcli); do
			if test ! "$(wp package list | grep $wp)"; then
				installing "Installing $wp"
				wp package install $wp >/dev/null
				cecho "${bold}✓ $wp package installed${normal}" $green
				printf "\n"
			else
				cecho "$wp has already been installed. Skipped..." $dim
				printf "\n"
			fi
		done
		cecho "Successfully installed WP-CLI packages." $green
	else
		cecho "Unable to install packages. Please try again." $red
	fi
else
	cecho "WP-CLI installation aborted. Skipping package installations..." $dim
fi
