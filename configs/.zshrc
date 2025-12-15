#!/usr/bin/env zsh

# Author: Santhosh Siva
# Date Created: 15-12-2025
# Description:
# Main Zsh configuration file for development environment setup
# Configures PATH, environment variables, keybindings, and aliases

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

setup_environment_variables() {
    export TERM='xterm-256color'
    export EDITOR='nvim'
    export VISUAL='nvim'
}

setup_homebrew_paths() {
    if [ -d "/opt/homebrew/bin" ]; then
        prepend_path "/opt/homebrew/bin"
    fi

    if [ -d "/opt/homebrew/sbin" ]; then
        prepend_path "/opt/homebrew/sbin"
    fi

    if [ -d "$HOME/.rd/bin" ]; then
        prepend_path "$HOME/.rd/bin"
    fi
}

setup_go_environment() {
    if [ -d "$HOME/go/bin" ]; then
        export GOPATH="$HOME/go"
        append_path "$HOME/go/bin"
    fi
}

setup_rust_environment() {
    if [ -d "$HOME/.cargo/bin" ]; then
        append_path "$HOME/.cargo/bin"
    fi
}

setup_ruby_environment() {
    if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
        prepend_path "/opt/homebrew/opt/ruby/bin"
        export LDFLAGS="$LDFLAGS -L/opt/homebrew/opt/ruby/lib"
        export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/ruby/include"

        # Add user gem bin directory to PATH
        if [ -n "$(command -v ruby)" ] && [ -n "$(command -v gem)" ]; then
            GEM_HOME=$(ruby -e 'puts Gem.user_dir')
            if [ -d "$GEM_HOME/bin" ]; then
                prepend_path "$GEM_HOME/bin"
            fi
        fi
    fi
}

setup_python_environment() {
    if [ -n "$(command -v python3)" ]; then
        PYTHON_USER_BASE=$(python3 -m site --user-base)
        if [ -d "$PYTHON_USER_BASE/bin" ]; then
            append_path "$PYTHON_USER_BASE/bin"
        fi
    fi
}

setup_java_environment() {
    if [ -d "/opt/homebrew/opt/openjdk/" ]; then
        append_path "/opt/homebrew/opt/openjdk/bin"

        if [ -d "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/bin" ]; then
            append_path "/Library/Java/JavaVirtualMachines/zulu-8.jdk/Contents/Home/bin"
        fi

        export CPPFLAGS="$CPPFLAGS -I/opt/homebrew/opt/openjdk/include"
    fi

    if [ -d "/opt/homebrew/Cellar/openjdk/21.0.1/libexec/openjdk.jdk/Contents/Home" ]; then
        export JAVA_HOME="/opt/homebrew/Cellar/openjdk/21.0.1/libexec/openjdk.jdk/Contents/Home"
    fi
}

setup_node_environment() {
    # Load NVM
    if [ -d "$HOME/.nvm" ]; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi

    # Switch to node version (silent with error handling)
    if [ -n "$(command -v nvm)" ]; then
        if ! nvm use node >/dev/null 2>&1; then
            echo "Warning: Failed to switch to node version"
        fi
    fi

    # Yarn global bin
    if [ -n "$(command -v yarn)" ]; then
        append_path "$(yarn global bin)"
    fi

    # Node configuration
    export NODE_PATH=$(npm root -g)
    export NODE_OPTIONS="--use-system-ca"
}

setup_custom_bins() {
    if [ -d "$HOME/.local/bin" ]; then
        append_path "$HOME/.local/bin"
    fi

    if [ -d "$HOME/bin" ]; then
        append_path "$HOME/bin"
    fi

    if [ -d "$HOME/.config/bin" ]; then
        append_path "$HOME/.config/bin/android"
        append_path "$HOME/.config/bin/dev"
        append_path "$HOME/.config/bin/dev/setup"
    fi

    if [ -d "$HOME/.config/gitsy" ]; then
        append_path "$HOME/.config/gitsy"
    fi

    # Add custom project paths here if needed
    # Example:
    # if [ -d "$HOME/projects/custom-tools" ]; then
    #     append_path "$HOME/projects/custom-tools"
    # fi
}

setup_shell_integrations() {
    # Zoxide - must be after PATH setup
    if [ -n "$(command -v zoxide)" ]; then
        eval "$(zoxide init zsh)"
    fi
}

setup_keybindings() {
    bindkey '^n' expand-or-complete
    bindkey '^p' reverse-menu-complete
    bindkey '^j' history-substring-search-down
    bindkey '^k' history-substring-search-up
}

setup_ssh_agent() {
    if [ -f ~/.config/bin/dev/setup-ssh-agent ]; then
        source ~/.config/bin/dev/setup-ssh-agent
    fi
}

setup_aliases() {
    alias g-wl="git worktree list"
    alias sed='gsed'
    alias gcs='gh copilot suggest'
    alias gce='gh copilot explain'
    alias g3_config='cd ~/.config'
    alias g2_notes="cd ~/notes; nvim"
    alias g2_icloud="cd ~/Library/Mobile\ Documents/com~apple~CloudDocs/"
}

main() {
    setup_environment_variables
    setup_homebrew_paths
    setup_go_environment
    setup_rust_environment
    setup_ruby_environment
    setup_python_environment
    setup_java_environment
    setup_custom_bins
    setup_node_environment
    setup_shell_integrations
    setup_keybindings
    setup_ssh_agent
    setup_aliases
}

main
