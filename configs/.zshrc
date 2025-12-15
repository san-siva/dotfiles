source ~/.config/configs/.zshrc_pre

typeset -aU path

prepend_path() {
    if [ -d "$1" ]; then
        path=("$1" $path)
    fi
}

append_path() {
    if [ -d "$1" ]; then
        path=($path "$1")
    fi
}

export TERM='xterm-256color'

export EDITOR='nvim'
export VISUAL='nvim'

if [ -d "/opt/homebrew/bin" ]
then
		prepend_path "/opt/homebrew/bin"
fi

if [ -d "/opt/homebrew/sbin" ]
then
		prepend_path "/opt/homebrew/sbin"
fi

if [ -d "$HOME/.rd/bin" ]
then
    prepend_path "$HOME/.rd/bin"
fi

if [ -n "$(command -v yarn)" ]
then
    append_path "$(yarn global bin)"
fi

if [ -d "$HOME/go/bin" ]
then
    export GOPATH="$HOME/go"
    append_path "$HOME/go/bin"
fi

if [ -d "$HOME/.cargo/bin" ]
then
    append_path "$HOME/.cargo/bin"
fi

if [ -d "/opt/homebrew/opt/ruby/bin" ]
then
    append_path "/opt/homebrew/opt/ruby/bin"
    export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/ruby/lib"
    export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/ruby/include"
fi

if [ -d "/opt/homebrew/opt/openjdk/" ]
then
    append_path "/opt/homebrew/opt/openjdk/bin"
		if [ -d "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/bin" ]
		then
			append_path "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/bin"
		fi
    export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/openjdk/include"
fi

if [ -d "/opt/homebrew/Cellar/openjdk/21.0.1/libexec/openjdk.jdk/Contents/Home" ]
then
    export JAVA_HOME="/opt/homebrew/Cellar/openjdk/21.0.1/libexec/openjdk.jdk/Contents/Home"
fi

if [ -d "$HOME/.local/bin" ]
then
    append_path "$HOME/.local/bin"
fi

if [ -d "$HOME/bin" ]
then
    append_path "$HOME/bin"
fi

if [ -d "$HOME/.config/bin" ]
then
    append_path "$HOME/.config/bin/android"
    append_path "$HOME/.config/bin/dev"
    append_path "$HOME/.config/bin/dev/setup"
fi

if [ -d "$HOME/.config/gitsy" ]
then
    append_path "$HOME/.config/gitsy"
fi

# Add custom project paths here if needed
# Example: if [ -d "$HOME/projects/custom-tools" ]; then
#     append_path $HOME/projects/custom-tools
# fi

if [ -d "$HOME/.nvm" ]
then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -n "$(command -v nvm)" ]
then
    if ! nvm use node >/dev/null 2>&1; then
        echo "Warning: Failed to switch to node version"
    fi
fi

# NOTE: should be here after append_paths
if [ -n "$(command -v zoxide)" ]
then
    eval "$(zoxide init zsh)"
fi


bindkey '^n' expand-or-complete
bindkey '^p' reverse-menu-complete

bindkey '^j' history-substring-search-down
bindkey '^k' history-substring-search-up

# Setup SSH agent and add keys
if [ -f ~/.config/bin/dev/setup-ssh-agent ]; then
    source ~/.config/bin/dev/setup-ssh-agent
fi


alias g-wl="git worktree list"
alias sed='gsed'
alias gcs='gh copilot suggest'
alias gce='gh copilot explain'
alias g3_config='cd ~/.config'
alias g2_notes="cd ~/notes; nvim"
alias g2_icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"

export NODE_PATH=$(npm root -g)
export NODE_OPTIONS="--use-system-ca"
