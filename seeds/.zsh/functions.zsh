#!/usr/bin/env zsh

# Create a new directory and enter it
function mkd() {
	mkdir -p "$@" && cd "$_";
}

# gitignore.io
function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
	cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
function targz() {
	local tmpFile="${@%/}.tar";
	tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1;

	size=$(
		stat -f"%z" "${tmpFile}" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}" 2> /dev/null;  # GNU `stat`
	);

	local cmd="";
	if (( size < 52428800 )) && hash zopfli 2> /dev/null; then
		# the .tar file is smaller than 50 MB and Zopfli is available; use it
		cmd="zopfli";
	else
		if hash pigz 2> /dev/null; then
			cmd="pigz";
		else
			cmd="gzip";
		fi;
	fi;

	echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…";
	"${cmd}" -v "${tmpFile}" || return 1;
	[ -f "${tmpFile}" ] && rm "${tmpFile}";

	zippedSize=$(
		stat -f"%z" "${tmpFile}.gz" 2> /dev/null; # macOS `stat`
		stat -c"%s" "${tmpFile}.gz" 2> /dev/null; # GNU `stat`
	);

	echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully.";
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Use Git’s colored diff when available
hash git &>/dev/null;
if [ $? -eq 0 ]; then
	function diff() {
		git diff --no-index --color-words "$@";
	}
fi;

# Create a data URL from a file
function dataurl() {
	local mimeType=$(file -b --mime-type "$1");
	if [[ $mimeType == text/* ]]; then
		mimeType="${mimeType};charset=utf-8";
	fi
	echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')";
}

# Compare original and gzipped file size
function gz() {
	local origsize=$(wc -c < "$1");
	local gzipsize=$(gzip -c "$1" | wc -c);
	local ratio=$(echo "$gzipsize * 100 / $origsize" | bc -l);
	printf "orig: %d bytes\n" "$origsize";
	printf "gzip: %d bytes (%2.2f%%)\n" "$gzipsize" "$ratio";
}

# Run `dig` and display the most useful info
function digga() {
	dig +nocmd "$1" any +multiline +noall +answer;
}

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
	if [ -z "${1}" ]; then
		echo "ERROR: No domain specified.";
		return 1;
	fi;

	local domain="${1}";
	echo "Testing ${domain}…";
	echo ""; # newline

	local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
		| openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

	if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
		local certText=$(echo "${tmp}" \
			| openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
			no_serial, no_sigdump, no_signame, no_validity, no_version");
		echo "Common Name:";
		echo ""; # newline
		echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
		echo ""; # newline
		echo "Subject Alternative Name(s):";
		echo ""; # newline
		echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
			| sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
		return 0;
	else
		echo "ERROR: Certificate not found.";
		return 1;
	fi;
}

# Normalize `open` across Linux, macOS, and Windows.
# This is needed to make the `o` function (see below) cross-platform.
if [ ! $(uname -s) = 'Darwin' ]; then
	if grep -q Microsoft /proc/version; then
		# Ubuntu on Windows using the Linux subsystem
		alias open='explorer.exe';
	else
		alias open='xdg-open';
	fi
fi

# `o` with no arguments opens the current directory, otherwise opens the given
# location
function o() {
	if [ $# -eq 0 ]; then
		open .;
	else
		open "$@";
	fi;
}

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
function tre() {
	tree -aC -I '.git|node_modules|bower_components' --dirsfirst "$@" | less -FRNX;
}

# Update your package managers including NPM, Homebrew, Yarn, Ruby Gems and Composer.
# Use the flag -g to update global packages.
# Usage: update-packages npm -g
function update-packages () {
  local package="${1:-0}"
  local env="${2:-0}"

  if [ $package == 'node' ]; 
  then
    sudo npm cache clean -f
    sudo npm install -g n
    sudo n stable
    sudo chown -R $(whoami):admin ~/.npm
    sudo chown -R $(whoami):admin ~/.config
  elif [ $package == 'npm' ]; 
  then
    if [ $env == '-g' ] || [ $env == '-G' ];
    then
      npm i -g npm
      npm update -g
    else
      npm update
    fi
  elif [ $package == 'yarn' ]; 
  then
    if [ $env == '-g' ] || [ $env == '-G' ];
    then
    	yarn global upgrade
    else
    	yarn upgrade
    fi
  elif [ $package == 'apps' ]; 
  then
    sudo softwareupdate -i -a
  elif [ $package == 'gem' ];
  then
    if [ $env == '-g' ] || [ $env == '-G' ];
    then
		gem update --system
    	gem update
    else
    	bundle update --all
    fi
  elif [ $package == 'brew' ];
  then
    brew update
    brew upgrade
    brew cleanup
  elif [ $package == 'composer' ];
  then
    if [ $env == '-g' ] || [ $env == '-G' ];
    then
      composer selfupdate
      composer global upgrade
    else
      composer upgrade
    fi
  elif [ $package == 'wp-cli' ];
  then
    wp cli update
  elif [ $package == 'all' ];
  then
    if [ $env == '-g' ] || [ $env == '-G' ];
    then
      printf "###\n"
      printf "\n"
      echo "Warning: This will update everything including Node! Continue update y/N"
      printf "\n"
      printf "###\n"
      read everything
      if [ $everything == 'y' ] || [ $everything == 'Y' ];
      then
        echo '### Updating Brew. ###'
        printf "\n"
        brew update
        brew upgrade
        brew cleanup
        echo '### Updating Ruby Gems. ###'
        printf "\n"
		gem update --system
        gem update
        echo '### Updating Composer and Composer packages. ###'
        printf "\n"
        composer selfupdate
        composer global upgrade
        echo '### Updating WP-CLI. ###'
        printf "\n"
        wp cli update
        echo '### Updating macOS apps. ###'
        printf "\n"
		sudo softwareupdate -i -a
        echo '### Updating Node and NPM. ###'
        printf "\n"
        sudo npm cache clean -f
        echo '// Now starting Node upgrade.'
        sudo npm i -g n
        sudo n stable
        echo '// Starting NPM upgrade.'
        npm i -g npm
        sudo chown -R $(whoami):admin ~/.npm
        sudo chown -R $(whoami):admin ~/.config
        npm update -g
        printf "###\n"
        printf "\n"
        echo "Success: All your systems development environments and packages have been updated!"
        printf "\n"
        printf "###\n"
      else
        printf "###\n"
        printf "\n"
        echo "Cancelled: You chose to stop the upgrading of your environments."
        printf "\n"
        printf "###\n"
      fi
    else
      yarn upgrade
      bundle update --all
      composer upgrade
    fi
  else
    printf "###\n"
    printf "\n"
    echo "Upgrading packages with default options."
    printf "\n"
    printf "###\n"
    brew update
    brew upgrade
    brew cleanup
    npm i -g npm
    npm update -g
	gem update --system
    gem update
    composer selfupdate
    composer global upgrade
    wp cli update
	sudo softwareupdate -i -a
  fi
}

# Git, commit, pull & push
function gcp () {
  local conflict="$(git ls-files -u | wc -l)"

  git add .
  git commit -am"$*"
  git pull
  if [ $conflict -gt 0 ]; then
    echo "There is a merge conflict. Aborting"
    git merge --abort
    exit 1
  else
    git push
  fi
}

# Git config
function config () {
  local usrEmail="mathew.teague@yewtreeweb.co.uk"
  git config –-global user.name "${1:-$USER}"
  git config –-global user.email "${2:-$usrEmail}"
}

# Git diff
function diff () {
  local check="${1:-0}"

  if [ $check == 'staged' ];
  then
    git diff -staged
  else
    git diff ${*}
  fi
}

# Git commit
function commit () {
  git commit -am"${*}"
}

# Git checkout
function checkout () {
  local checkout="${1:-0}"

  if [ $checkout == 'new' ];
  then
    git checkout -b ${2}
  else
    git checkout ${checkout}
  fi
}

# Git fetch
function fetch () {
  git fetch ${*}
}

# Git pull
function pull () {
  git pull ${*}
}

# Git push
function push () {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local remote="${1:-origin}"
  local push="${2:-$branch}"

  if [ $remote == 'new' ];
  then
    git push -u ${2:-origin} ${3:-$branch}
  else
    git push ${remote} ${push}
  fi
}

# Git merge
function merge () {
  if [ $1 == 'nohistory' ];
  then
    git merge --squash ${2}
  else
    git merge ${*}
  fi
}


# Git reset
function greset () {
  local action="${1:-0}"

  if [ $action == 'hard' ];
  then
    git reset -hard ${2}
  else
    git reset ${*}
  fi
}

# Git clone
function clone () {
  local repository="${1:-0}"

  if [ $repository == 'kubix' ] || [ $repository == 'kbx' ];
  then
    git clone git@github-kubixmedia:kubixmedia/${2}.git
  elif [ $repository == 'other' ];
  then
    git clone git@github.com:${2}.git
  else
    git clone git@github.com:YewTreeWeb/${1}.git
  fi
}

# Git switch
function switch () {
  git switch ${*}
}

# Git remote
function remote () {
  local option="${1:-0}"

  if [ $option == 'add' ];
  then
    git remote add ${2} ${3}
  elif [ $option == 'remove' ];
  then
    git remote remove ${2}
  elif [ $option == 'rename' ];
  then
    git remote rename ${2} ${3}
  elif [ $option == 'update' ];
  then
    git remote -v update
  elif [ $option == 'delete' ];
  then
    if [ $2 == 'dry'];
    then
      git remote prune --dry-run ${3}
    else
      git remote prune ${2}
    fi
  else
    git remote -v
  fi
}

## themkit
function shopifykit () {
  local command="${1:-0}"

  if [ $command == 'get' ];
  then
    theme get --password=${2} --store=${3} --themeid=${4} --env=${4:-development} --dir=src/theme
  elif [ $command == 'download' ];
  then
    theme download --env=${2:-development} --dir=src/theme
  elif [ $command == 'download:files' ];
  then
    theme download --env=${2:-development} ${*} --dir=src/theme
  elif [ $command == 'config' ];
  then
    theme configure --password=${2} --store=${3} --themeid=${4}
  elif [ $command == 'deploy' ];
  then
    theme deploy --env=${2:-production} --dir=dist
  elif [ $command == 'deploy:safe' ];
  then
    theme deploy --env=${2:-production} --dir=dist --nodelete
  elif [ $command == 'new' ];
  then
    theme new --password=${2} --store=${3} --name="${4}"
  elif [ $command == 'open' ];
  then
    theme open --env=${2:-production} --${2:-edit}
  elif [ $command == 'remove' ];
  then
    theme remove ${*}
  elif [ $command == 'watch' ];
  then
    theme watch --dir=${2:-dist} --env=${3:-development}
  else
    theme help
  fi
}

## SSH key
function ssh-copy () {
  pbcopy < ~/.ssh/${*}.pub
  ssh-add ~/.ssh/${*}
  printf "Copied and added SSH key ${*}."
}

# Shopify Kubi
function kubi () {
  local init="${1:-init}"

  if [ $init == 'init' ];
  then
    git remote add upstream git@github-kubixmedia:kubixmedia/shopify-kubi.git
    git fetch upstream
    git merge upstream/master
    sh kubimini.sh
  else
    git fetch upstream
    git merge upstream/master
    sh kubimini.sh
  fi
}

# WordPress Project
function wpproject () {
  local project="${1:-0}"
  local theme="${2:-0}"
  local start="${3:-0}"

  wordpress && cd ${project}/wp-content/themes/${theme}
  if [ $start == 'gulp' ];
  then
    gulp
  elif [ $start == 'git' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
  elif [ $start == 'update' ];
  then
    wp core update
    wp plugin update --all
    wp theme update --all
    wp language core update
    wp language plugin update --all
    wp language theme update --all
  elif [ $start == 'gitgulp' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      gulp
    fi
  elif [ $start == 'all' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      wp core update
      wp plugin update --all
      wp theme update --all
      wp language core update
      wp language plugin update --all
      wp language theme update --all
      gulp
    fi
  fi
}
# Shopify Project
function shproject () {
  local project="${1:-0}"
  local start="${2:-0}"

  shopify && cd ${project}
  if [ $start == 'gulp' ];
  then
    gulp
  elif [ $start == 'git' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
  elif [ $start == 'update' ];
  then
    rm -rf yarn.lock
    yarn upgrade
  elif [ $start == 'gitgulp' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      gulp
    fi
  elif [ $start == 'all' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      rm -rf yarn.lock
      yarn upgrade
      gulp
    fi
  fi
}

# Jekyll Project
function jekproject () {
  local project="${1:-0}"
  local start="${2:-0}"

  hyde && cd ${project}
  if [ $start == 'gulp' ];
  then
    gulp
  elif [ $start == 'git' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
  elif [ $start == 'update' ];
  then
    rm -rf yarn.lock
    yarn upgrade
    bundle update --all
  elif [ $start == 'gitgulp' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      gulp
    fi
  elif [ $start == 'all' ];
  then
    git add .
    git commit -am"${4:-Auto Commit}"
    git pull
    if [ $conflict -gt 0 ]; then
      echo "There is a merge conflict. Aborting"
      git merge --abort
      exit 1
    else
      rm -rf yarn.lock
      yarn upgrade
      bundle update --all
      gulp
    fi
  fi
}

# SSH files to servers
function transfer() {
  local send="${1:-LuckyMonkey}"
  local localhost="${2:-0}"

  if [[ $send =~ ^([lmLM][luckymonkeyLuckyMonkey]|[lmLM])$ ]];
  then
    local dest="${3:-0}"
    if [ $dest != "0" ];
    then
      scp -P 22 -r $localhost admin@192.168.1.245:/var/services/homes/admin/$dest
    else
      scp -P 22 -r $localhost admin@192.168.1.245:/var/services/homes/admin/
    fi
  else
    scp -P -r ${4:-22} $localhost ${3:-0}
  fi
}

# Change Shell ENV
function changeshell() {
  local shell="${*:-0}"
  sudo chsh -s "/usr/local/bin/$shell" "$USER"
}