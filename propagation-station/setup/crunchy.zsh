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
# Install crunchy-cli #
###############################################################################

heading "crunchy-cli"

if command -v cargo &> /dev/null; then
	cecho "Cargo already installed. Skipping..." $dim
else
	step "Downloading and installing Cargo..."
	yes 1 | curl https://sh.rustup.rs -sSf | sh

	# Wait for the installation to finish
	while ps | grep -q "[s]h.rustup.rs"; do
		sleep 5
	done

	step "Activating Cargo..."
	source "$HOME/.cargo/env"
	printf "\n"

	if command -v cargo &> /dev/null; then
		cecho "cargo installed successfully." $green
		printf "\n\n"
	else
		cecho "Failed to install cargo." $red
		printf "\n"
		cecho "Retrying..." $dim
		printf "\n"
		brew install rust

		# Wait for the installation to finish
		while ps | grep -q "[b]rew install rust"; do
			sleep 5
		done

		step "Activating Cargo..."
		source "$HOME/.cargo/env"
		printf "\n"
		if command -v cargo &> /dev/null; then
			cecho "cargo installed successfully." $green
			printf "\n\n"
		else
			cecho "Failed to install cargo." $red
			printf "\n"
			cecho "Skipping crunchy-cli installation..." $dim
			printf "\n\n"
		fi
	fi
fi

if command -v cargo &> /dev/null; then
	if command -v crunchy-cli &> /dev/null; then
		cecho "crunchy-cli already installed. Skipping..." $dim
		printf "\n\n"
	else
		step "Installing crunchy-cli..."
		# Move into pottingshed/apps
		if [[ ! -d "$location/pottingshed" ]]; then
			mkdir "$location/pottingshed"
		fi
		cd "$location/pottingshed"

		if [[ ! -d "$location/pottingshed/crunchy" ]]; then
			mkdir "$location/pottingshed/crunchy"
		fi
		cd "$location/pottingshed/crunchy"

		git clone https://github.com/crunchy-labs/crunchy-cli
		cd crunchy-cli
		cargo build --release
		cargo install --force --path .

		cd $location

		# Check for crunchy-cli installation
		if command -v crunchy-cli &> /dev/null; then
			cecho "Successfully installed crunchy-cli" $green
			printf "\n"
		else
			cecho "Failed to install crunchy-cli." $red
			printf "\n\n"
		fi

		rm -rf $location/pottingshed/crunchy
	fi
fi
