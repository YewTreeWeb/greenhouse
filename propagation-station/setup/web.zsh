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
# Install Apps from the web #
###############################################################################

heading "Installing apps from the web"

# Check if Composer is already installed.
# Check if restore folder exists
# Move into pottingshed/apps
if [[ ! -d "$location/pottingshed" ]]; then
	mkdir "$location/pottingshed"
fi
cd "$location/pottingshed"

if [[ ! -d "$location/pottingshed/apps" ]]; then
	mkdir "$location/pottingshed/apps"
fi
cd "$location/pottingshed/apps"

if [[ ! -f "$HOME/Applications/Popcorn-Time.app" ]];
then
	read -p "Would you like to install Popcorn Time? Y/n" popcorn
	if [[ $popcorn =~ ^([yY])$ ]];
	then
		step "Downloading PopcornTime..."
		wget https://get.popcorntime.sh/build/Popcorn-Time-0.3.10-Mac.zip 2> /dev/null
		unzip Popcorn-Time-0.3.10-Mac.zip 2> /dev/null
		sudo mv Popcorn-Time.app $HOME/Applications
		cecho "Successfully downloaded and installed PopcornTime." $green
	else
		cecho "Popcorn Time installation aborted. Skipping..." $dim
	fi
else
	cecho "PopcornTime already installed. Skipping..." $dim
fi

if [[ ! -f "/Applications/Amphetamine Enhancer.app" ]];
then
	read -p "Would you like to download Amphetamine Enhancer? Y/n" amphetamine
	if [[ $amphetamine =~ ^([yY])$ ]];
	then
		step "Downloading File..."
		cd $HOME/Downloads
		wget https://github.com/x74353/Amphetamine-Enhancer/raw/master/Releases/Current/Amphetamine%20Enhancer.dmg 2> /dev/null
		cd $location/pottingshed/apps
		cecho "Downloaded Amphetamine Enhancer into Downloads folder" $green
	else
		cecho "Amphetamine Enhancer download aborted. Skipping..." $dim
	fi
else
	cecho "Amphetamine Enhancer already downloaded. Skipping..." $dim
fi

if [[ ! -f "/Applications/FileZilla.app" ]];
then
	read -p "Would you like to download FileZilla? Y/n" filezilla
	if [[ $filezilla =~ ^([yY])$ ]];
	then
		step "Downloading File..."
		cd $HOME/Downloads
		wget https://download.filezilla-project.org/client/FileZilla_3.46.3_macosx-x86_sponsored-setup.dmg 2> /dev/null
		cd $location/pottingshed/apps
		cecho "Downloaded FileZilla into Downloads folder" $green
	else
		cecho "FileZilla download aborted. Skipping..." $dim
	fi
else
	cecho "FileZilla already downloaded. Skipping..." $dim
fi

# Come out of pottingshed.
cd $location

# Remove pottingshed/apps to save space
rm -rf $location/pottingshed/apps/
