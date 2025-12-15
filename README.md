# Sankit Dotfiles

Personal dotfiles and development environment configuration for macOS.

## Structure

```
.
├── assets/              # Static assets (fonts, themes)
├── bin/                 # Custom scripts and utilities
│   ├── android/         # Android development scripts
│   ├── dev/             # Development utilities
│   │   └── setup/       # Environment setup scripts
│   └── utils.sh         # Shared utility functions
├── configs/             # Configuration files
│   ├── .eslintrc.json   # ESLint configuration
│   ├── .p10k.zsh        # Powerlevel10k theme
│   ├── .prettierrc.json # Prettier configuration
│   ├── .tmux.conf       # Tmux configuration
│   ├── .vimrc           # Vim configuration
│   ├── .zshrc           # Zsh configuration
│   ├── eslint.config.ts # ESLint flat config (modern)
│   ├── eslint-utilities.ts # ESLint shared utilities
│   ├── prettier.config.js  # Prettier config (modern)
│   ├── tsconfig.base.json  # TypeScript base config
│   └── tsconfig.json       # TypeScript project config
├── alacritty/           # Alacritty terminal config
├── fish/                # Fish shell configuration
├── gitsy/               # Git workflow automation tools
├── nvim/                # Neovim configuration
└── LICENSE              # MIT License
```

## Installation

### Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles ~/.config
   cd ~/.config
   ```

2. Run the setup scripts:
   ```bash
   # Install development environment
   ./bin/dev/setup/setup-environment

   # Install global dependencies
   ./bin/dev/setup/install-global-deps

   # Create symlinks for dotfiles
   ./bin/dev/setup/link-dotfiles
   ```

## Scripts

All scripts follow a consistent structure with a \`main\` function and use the shared \`utils.sh\` library for common operations.

### Android Development

- \`bin/android/wireless-adb\` - Enable wireless ADB debugging
- \`bin/android/adb-install\` - Install React Native app with custom port/env
- \`bin/android/adb-uninstall\` - Uninstall app from Android device
- \`bin/android/adb-reverse\` - Setup reverse port forwarding

### Development Utilities

- \`bin/dev/kill-port\` - Kill process running on specified port
- \`bin/dev/setup/setup-environment\` - Install development tools and packages
- \`bin/dev/setup/install-global-deps\` - Install global npm/brew dependencies
- \`bin/dev/setup/link-dotfiles\` - Create symlinks for config files

### Git Workflow (Gitsy)

See \`gitsy/README.md\` for detailed git automation tools.

## Configuration Files

### TypeScript / JavaScript

The repo includes generic TypeScript and ESLint configurations suitable for React projects:

- **tsconfig.base.json** - Base TypeScript configuration with strict settings
- **tsconfig.json** - Project-specific TypeScript config
- **eslint.config.ts** - Modern flat ESLint configuration
- **eslint-utilities.ts** - Shared ESLint rules and plugins (React, Jest, TypeScript)

### Code Formatting

- **prettier.config.js** - Prettier configuration with 4-space tabs
- **.prettierrc.json** - Alternative JSON format

### Terminal

- **.zshrc** - Zsh configuration with Oh My Zsh and Powerlevel10k
- **.p10k.zsh** - Powerlevel10k theme customization
- **alacritty/** - Alacritty terminal emulator config

### Editors

- **.vimrc** - Vim editor configuration
- **nvim/** - Neovim configuration with modern plugins

## Script Architecture

All scripts use a consistent pattern:

\`\`\`bash
#!/usr/bin/env bash

source "\$(dirname "\${BASH_SOURCE[0]}")/../utils.sh"

main() {
    validate_dependencies figlet lolcat
    print_banner  # Shows "Sankit" banner
    # Script logic here
}

main "\$@"
exit 0
\`\`\`

### Available Utilities

From \`bin/utils.sh\`:

- \`print_banner()\` - Display ASCII art banner with "Sankit"
- \`print_message(message, step_number)\` - Formatted console output
- \`indent()\` - Indent piped output
- \`validate_dependencies(...)\` - Check and install required commands
- \`prompt_user(default_yes, message, step)\` - Interactive user prompts
- \`is_git_repo(dir)\` - Check if directory is a git repository

## Usage Examples

### Kill a process on port 3000
\`\`\`bash
~/.config/bin/dev/kill-port --port=3000
\`\`\`

### Install React Native app on Android
\`\`\`bash
~/.config/bin/android/adb-install --port=8081 --env=.env.dev
\`\`\`

### Setup wireless ADB
\`\`\`bash
~/.config/bin/android/wireless-adb
\`\`\`

## Requirements

- macOS (scripts are macOS-specific)
- Homebrew
- Zsh (default shell)
- Git
- Node.js / npm
- Optional: figlet, lolcat (for banners)

## Customization

1. Fork this repository
2. Update personal information in configs
3. Modify \`bin/utils.sh\` banner if desired
4. Add your own scripts to \`bin/\`
5. Update configurations in \`configs/\`

## License

MIT License - See LICENSE file for details

## Credits

- Author: Santhosh Siva
- Inspired by the dotfiles community
