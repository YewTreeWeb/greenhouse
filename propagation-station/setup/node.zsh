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
# Install Node with NVM & NPM packages #
###############################################################################
heading "Node with NVM & NPM packages"

# Install NVM to manage Node.
step "Configuring NVM..."
if [[ ! -f "$HOME/.nvmrc" ]]; then
	cp $location/seeds/.nvmrc $HOME
fi
. "/usr/local/opt/nvm/nvm.sh"
cecho "NVM configured." $green
printf "\n\n"

step "Installing latest Node & LTS Node..."
nvm install node
nvm install --lts
nvm use node
nvm alias default node

step "Updating NPM..."
npm i -g npm@latest

if command -v node &> /dev/null; then
	cecho "Successfully installed NVM, latest Node and LTS version\n" $green
	cecho "To use the latest version of Node as default run ${bold}nvm alias default node${normal} or ${bold}nvm alias default stable${normal}\n" $dim
else
	cecho "Failed to installed NVM, latest Node and LTS version\n" $red
fi

step "Installing packages..."
echo -n "Would you like to use yarn, pnpm, bun or npm? y/p/b/n"
read installPkg

if [[ -e $location/seeds/npm ]]; then
	if [[ $installPkg =~ ^([yY])$ ]]; then
		if brew list yarn &> /dev/null; then
			step "Using Yarn as global package manager"
			echo "export PATH=\"$(yarn global bin):$PATH\"" >> $HOME/.zshrc
			# Source your .zshrc to set up environment
			source $HOME/.zshrc
			step "Setting Yarn to latest version..."
			yarn set version berry
			brew ugrade yarn
			xargs yarn global add < $location/seeds/npm
		else
			cecho "Yarn not installed. To use Yarn run ${bold}brew install yarn${normal} or ${bold}curl -o- -L https://yarnpkg.com/install.sh | bash${normal}. Defaulting to NPM..." $yellow
			printf "\n"
			xargs npm i -g < $location/seeds/npm
		fi
	elif [[ $installPkg =~ ^([pP])$ ]]; then
		if brew list pnpm &> /dev/null; then
			step "Using pnpm as global package manager"
			pnpm setup
			# Source your .zshrc to set up environment
			source $HOME/.zshrc

			step "Updating pnpm to latest version..."
			brew upgrade pnpm
			xargs pnpm add -g < $location/seeds/npm
		else
			cecho "pnpm not installed. To use pnpm run ${bold}brew install pnpm${normal} or ${bold}curl -fsSL https://get.pnpm.io/install.sh | PNPM_VERSION=7.0.0-rc.5 sh -${normal}. Defaulting to NPM..." $yellow
			printf "\n"
			xargs npm i -g < $location/seeds/npm
		fi
	elif [[ $installPkg =~ ^([bB])$ ]]; then
		if brew list bun &> /dev/null; then
			step "Using Bun as global package manager"
			step "Updating pnpm to latest version..."
			brew upgrade bun
			xargs bun add -g < $location/seeds/npm
		else
			cecho "Bun not installed. To use Bun run ${bold}brew install bun${normal} or ${bold}curl -fsSL https://bun.sh/install | bash${normal}. Defaulting to NPM..." $yellow
			printf "\n"
			xargs npm i -g < $location/seeds/npm
		fi
	else
		step "Using NPM as global package manager"
		xargs npm i -g < $location/seeds/npm
	fi
fi
cecho "All $installPkg packages installed." $green
