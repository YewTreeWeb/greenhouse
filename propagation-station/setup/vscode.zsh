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
# VSCode configuration #
###############################################################################

heading "Configuring VSCode"

if command -v code &> /dev/null; then
	rm -rf $HOME/Library/Application\ Support/Code/User/settings.json
	cp $location/seeds/vscode/settings.json $HOME/Library/Application\ Support/Code/User
	vscode_commandline
fi

# Source your .zshrc to set up environment
source $HOME/.zshrc

cecho "Successfully configured VSCode" $green
