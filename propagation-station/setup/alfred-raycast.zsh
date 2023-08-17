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
# Install Alfred or Raycast
#############################################

heading "Install Alfred or Raycast"
read -p "Would you like to install either Alfred or Raycast? alfred/raycast" installAR

if [[ installAR == 'alfred' ]]; then
	if brew list --cask alfred; then
		cecho "Alfred is already installed via Homebrew. Skipping..." $dim
	else
		brew install --cask alfred
		# Wait for the installation to finish
		while ps | grep -q "[b]rew install alfred"; do
			sleep 5
		done

		if brew list --cask alfred; then
			cecho "Successfully installed Alfred." $green
		else
			cecho "Failed to install Alfred." $red
		fi
	fi
else
	if brew list --cask raycast &> /dev/null; then
		cecho "Raycast is already installed via Homebrew. Skipping..." $dim
	else
		brew install --cask raycast
		# Wait for the installation to finish
		while ps | grep -q "[b]rew install raycast"; do
			sleep 5
		done

		if brew list --cask raycast; then
			cecho "Successfully installed Raycast." $green
		else
			cecho "Failed to install Raycast." $red
		fi
	fi
fi
