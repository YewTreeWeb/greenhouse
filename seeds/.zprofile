# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles:
source $HOME/.zsh/aliases.zsh
source $HOME/.zsh/functions.zsh
source $HOME/.zsh/exports.zsh

# Eval Ruby env.
eval "$(rbenv init -)"

# add ssh keys
ssh-add -A 2>/dev/null;

# ssh keys
ssh-add -K ~/.ssh/github ~/.ssh/gitlab ~/.ssh/id_rsa ~/.ssh/kubixGitlab ~/.ssh/kubixGithub ~/.ssh/dev ~/.ssh/alice ~/.ssh/kubix && clear

# Starship
eval "$(starship init zsh)"

# Enable 'fast-syntax-highlighting' plugin in ZSH
source $HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Enable 'completion' plugin in ZSH
source $HOME/.zsh/completion.zsh

# Initialize the completion system
autoload -Uz compinit

# Cache completion if nothing changed - faster startup time
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Enhanced form of menu completion called `menu selection'
zmodload -i zsh/complist

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Enable 'zsh-autosuggestions' plugin in ZSH
source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable 'history' config in ZSH
source $HOME/.zsh/history.zsh

# Enable 'key-bindings' config in ZSH
source $HOME/.zsh/key-bindings.zsh