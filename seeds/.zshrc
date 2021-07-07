# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/mat/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

### Aliases ###
# Easier navigation: .., ..., ...., ....., ~ and -
alias .="cd"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Run Greenhouse script globally
alias greenhouse="/usr/local/bin/greenhouse/greenhouse"

# Source zprofile
alias refresh='source ~/.zshrc'

# zprofile
alias profile='code ~/.zshrc'

# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias developer="cd ~/Developer"
alias sites='cd ~/Sites'
alias shopify='cd ~/Sites/shopify'
alias wordpress='cd ~/Sites/wordpress'
alias hyde='cd ~/Sites/jekyll'
alias lara='cd ~/Sites/laravel'
alias static='cd ~/Sites/static'
alias designs='cd ~/Designs'
alias sshFolder="cd ~/.ssh"
alias g="git"

# create new key
alias new-ssh="cd ~/.ssh && ssh-keygen -t rsa"

# edit ssh config
alias ssh-config="code ~/.ssh/config"

# mysql command form MAMP
alias mysql="mysql -uroot"

# Flush Directory Service cache
alias flush="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"

# Empty the Trash on all mounted volumes and the main HDD.
# Also, clear Apple’s System Logs to improve shell startup speed.
# Finally, clear download history from quarantine. https://mths.be/bum
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Clear Terminal
alias c='clear'

# Git
alias add="git add ."
alias status="git status"

# rbenv
alias rbenvDoc="curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash"

# Remove alias
unalias gcp

# Run Netlify CMS locally
alias netlifycms="npx netlify-cms-proxy-server"

### Exports ###
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Brew
export PATH="/usr/local/sbin:$PATH"

# To opt in to Homebrew analytics, `unset` this in ~/.zshrc.local .
# Learn more about what you are opting in to at
# https://docs.brew.sh/Analytics
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# composer
export PATH="$PATH:~/.composer/vendor/bin"

# sqlite
export PATH="/usr/local/opt/sqlite/bin:$PATH"

# system php
export PATH="/usr/local/opt/php/bin:$PATH"
export PATH="/usr/local/opt/php/sbin:$PATH"

# Make nano the default editor.
export EDITOR='nano'

# Add NVM to shell.
export NVM_DIR="$HOME/.nvm"
NVM_HOMEBREW="/usr/local/opt/nvm/nvm.sh"
[ -s "$NVM_HOMEBREW" ] && \. "$NVM_HOMEBREW"
export PATH="$HOME/.npm-packages/bin:$PATH"
[ -x "$(command -v npm)" ] && export NODE_PATH=$NODE_PATH:`npm root -g`

# Node Memory
export NODE_OPTIONS="--max-old-space-size=8192" #increase to 8gb

# ncurses
export PATH="/usr/local/opt/ncurses/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/ncurses/lib"
export CPPFLAGS="-I/usr/local/opt/ncurses/include"
export PKG_CONFIG_PATH="/usr/local/opt/ncurses/lib/pkgconfig"

# Ruby
export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

### Functions ###
# Git, commit, pull & push
function gcp () {
  git add .
  git commit -am"${*}"
  git pull
  git push
}

# Git commit
function commit () {
  git commit -am"${*}"
}

# Git checkout
function checkout () {
  local checkout="${1:-0}"

  if [[ $checkout = 'new' ]];
  then
    git checkout -b ${2}
  else
    git checkout ${checkout}
  fi
}

# Git push
function push () {
  local branch=$(git rev-parse --abbrev-ref HEAD)
  local remote="${1:-origin}"
  local push="${2:-$branch}"

  if [[ $remote = 'new' ]];
  then
    git push -u ${2:-'origin'} ${3:-$branch}
  else
    git push ${remote} ${push}
  fi
}

# Git merge
function merge () {
  if [[ $1 = 'nohistory' ]];
  then
    git merge --squash ${2}
  else
    git merge ${*}
  fi
}

# Git clone
function clone () {
  local repository="${1:-0}"

  if [[ $repository = 'other' ]];
  then
    git clone git@github.com:${2}.git ${3}
  else
    git clone git@github.com:YewTreeWeb/${1}.git ${2}
  fi
}

## SSH key
function ssh-copy () {
  pbcopy < ~/.ssh/${*}.pub
  ssh-add ~/.ssh/${*}
  printf "Copied and added SSH key ${*}."
}

# SSH files to servers
function transfer() {
  local send="${1:-LuckyMonkey}"
  local localhost="${2:-0}"

  if [[ $send =~ ^([lmLM][luckymonkeyLuckyMonkey]|[lmLM])$ ]];
  then
    local dest="${3:-0}"
    if [[ $dest != "0" ]];
    then
      scp -P 22 -r $localhost admin@192.168.1.245:/var/services/homes/admin/$dest
    else
      scp -P 22 -r $localhost admin@192.168.1.245:/var/services/homes/admin/
    fi
  else
    scp -P -r ${4:-22} $localhost ${3:-0}
  fi
}

# Change node
function switchNode() {
  # Switches Node version with NVM and reinstalls packages
  nvm install node --reinstall-packages-from=${1:-'node'} --latest-npm
}

# Connect to Unifi Controller Device
function sshUnifi() {
    ssh MatTeague@192.168.1.${*}
}

### Other ###
# Eval Ruby env.
eval "$(rbenv init -)"

# ssh keys
ssh-add -K ~/.ssh/github ~/.ssh/gitlab ~/.ssh/id_rsa && clear

# Enable 'fast-syntax-highlighting' plugin in ZSH
source $HOME/.zsh_plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Enable 'completion' plugin in ZSH
source $HOME/.zsh_plugins/completion.zsh

# Enable 'zsh-autosuggestions' plugin in ZSH
source $HOME/.zsh_plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable 'history' config in ZSH
source $HOME/.zsh_plugins/history.zsh

# Enable 'key-bindings' config in ZSH
source $HOME/.zsh_plugins/key-bindings.zsh

### Greenhouse ###
