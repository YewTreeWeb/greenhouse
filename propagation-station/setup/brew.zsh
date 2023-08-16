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
# Install Brews #
##############################

heading "Installing Homebrew formulaes and casks"

if [[ -e $location/seeds/Brewfile ]]; then
	if command -v brew &> /dev/null; then
		step "Installing Homebrew packages..."
		# Check if user local Applications folder exists.
		read -p "Would you like to install casks to a local Applications directory? Y/n " haveLocalApps
		if [[ $haveLocalApps =~ ^([yY])$ ]]; then
			if [[ ! -d "$HOME/Applications" ]]; then
				mkdir "$HOME/Applications"
				sudo chflags norestricted "$HOME/Applications"
			fi
			echo "# Homebrew install cask location" >> $HOME/.zshrc
			echo "export HOMEBREW_CASK_OPTS=\"--appdir=~/Applications\"" >> $HOME/.zshrc
		fi

		# Create temporary folder
		if [[ $haveLocalApps =~ ^([yY])$ ]]; then
			# Move into pottingshed/apps
			if [[ ! -d "$location/pottingshed" ]]; then
				mkdir "$location/pottingshed"
			fi
			cd "$location/pottingshed"

			if [[ ! -d "$location/pottingshed/brew" ]]; then
				mkdir "$location/pottingshed/brew"
			fi
			cd "$location/pottingshed/brew"

			printf '## Set global configuration arguments\ncask_args appdir: "~/Applications"\n\n' | cat - $location/seeds/Brewfile > $location/pottingshed/brew/temp && mv $location/pottingshed/brew/temp $location/pottingshed/brew/Brewfile
		fi

		# Copy Greenhouse Brewfile to $HOME
		if [[ $haveLocalApps =~ ^([yY])$ ]]; then
			cp $location/pottingshed/brew/Brewfile $HOME
		else
			cp $location/seeds/Brewfile $HOME
		fi

		# Install brew packages
		cd $HOME
		# brew bundle
		brew bundle

		# Install IconJar
		read -p "Would you like to install IconJar? y/N" installIJ
		if [[ $installIJ =~ ^([yY])$ ]]; then
				# Install iconjar and wait for installation
			if ! brew list --cask iconjar &> /dev/null; then
				cecho "Installing iconjar via Homebrew..."
				brew install --cask iconjar

				# Wait for the installation to finish
				while ps | grep -q "[b]rew install --cask iconjar"; do
					sleep 5
				done

				if brew list --cask iconjar &> /dev/null; then
					cecho "iconjar installed successfully via Homebrew." $green
				else
					cecho "Failed to install iconjar via Homebrew." $red
				fi
			else
				cecho "iconjar is already installed via Homebrew. Skipping..." $dim
			fi
		else
			cecho "IconJar installation aborted. Skipping..." $dim
		fi

		# Install Shopify
		cecho "Shopify CLI replaces Theme Kit for most Shopify theme development tasks. You should use Shopify CLI if you're working on Online Store 2.0 themes. You should use Theme Kit instead of Shopify CLI only if you're working on older themes or you have Theme Kit integrated into your existing theme development workflows." $dim
		printf "\n"
		read -p "Would you like to install the Shopify CLI, Theme Kit or both? both/cli/themekit/n" whichShopifyCli

		if [[ $whichShopifyCli == 'cli' ]]; then
			brew install shopify-cli
			if command -v shopify-cli &> /dev/null; then
				cecho "Shopify CLI successfully installed" $green
			else
				cecho "Failed to install Shopify CLI via Homebrew" $red
			fi
			printf "\n"
		elif [[ $whichShopifyCli == "themekit" ]]; then
			brew install themekit
			if command -v themekit &> /dev/null; then
				cecho "Theme Kit successfully installed" $green
			else
				cecho "Failed to install Theme Kit via Homebrew" $red
			fi
			printf "\n"
		elif [[ $whichShopifyCli == "both" ]]; then
			brew install shopify-cli
			brew install themekit
			if command -v shopify-cli  &> /dev/null; then
				cecho "Shopify CLI successfully installed" $green
			else
				cecho "Failed to install Shopify CLI via Homebrew" $red
			fi
			if command -v themekit  &> /dev/null; then
				cecho "Themekit successfully installed" $green
			else
				cecho "Failed to install Themekit via Homebrew" $red
			fi
			printf "\n"
		else
			cecho "Shopify CLI and Theme Kit installation aborted. Skipping..." $dim
		fi

		# Create Shopify directories
		if brew list shopify-cli || brew list themekit; then
			shopfiy_dir_shortcut
			# Source your .zshrc to set up environment
			source $HOME/.zshrc
		fi

		# Run a Homebrew cleanup.
		step "Cleaning up Homebrew..."
		brew cleanup
		brew cleanup -s
		cd $location
		if [[ $haveLocalApps =~ ^([yY])$ ]]; then
			# Remove pottingshed/brew to save space
			rm -rf $location/pottingshed/brew
		fi
	else
		cecho "Homebrew may not be installed or you may not have internet. Please try again." $red
	fi
fi
