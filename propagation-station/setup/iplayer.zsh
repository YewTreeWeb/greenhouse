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
# Install get_iplayer #
###############################################################################

heading "get_iplayer"

if command -v get_iplayer &> /dev/null; then
	cecho "get_iplayer already installed. Skipping..." $dim
else
	# Move into pottingshed/apps
	if [[ ! -d "$location/pottingshed" ]]; then
		mkdir "$location/pottingshed"
	fi
	cd "$location/pottingshed"

	if [[ ! -d "$location/pottingshed/iplayer" ]]; then
		mkdir "$location/pottingshed/iplayer"
	fi
	cd "$location/pottingshed/iplayer"

	step "Installing get_iplayer..."
	wget https://github.com/get-iplayer/get_iplayer_macos/releases/download/3.31.0/get_iplayer-3.31.0-macos-x86_64.pkg
	sudo installer -pkg get_iplayer-3.31.0-macos-x86_64.pkg -target /Applications

	cd $location

	if command -v get_iplayer &> /dev/null; then
		cecho "Successfully installed get_iplayer" $green
	else
		cecho "Failed to install get_iplayer" $red
	fi

	rm -rf $location/pottingshed/iplayer
fi
