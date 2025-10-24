# dotfiles

This repository contains my dotfiles and scripts to quickly bootstrap and configure a development environment on Debian/Ubuntu-based systems.

What does this project do?
- Installs base dependencies: curl, git, vim, tmux, ripgrep.
- Sets up Zsh as the shell and Starship as the prompt.
- Configures Tmux.
- Installs and configures Neovim.
- Creates symlinks for configuration files (for example, .ideavimrc and folders under .config).

Main structure
- init.sh: main script that orchestrates installation and configuration.
- tools/install_dependencies.sh: installs base dependencies and triggers configurations.
- tools/scripts/*.sh: helper scripts (zsh, starship, tmux, commons, base_dependencies, ideavim).
- tools/neovim_install.sh: Neovim installation and configuration.

Requirements
- Debian/Ubuntu (apt) or macOS (Homebrew). On macOS, Homebrew will be installed automatically if not present.
- Sudo privileges (apt flows).
- Internet connection.

How to use
1. Clone the repository:
   git clone https://github.com/your-username/dotfiles.git
   cd dotfiles
2. Run the initializer (it may ask for your sudo password):
   bash init.sh

Notes
- The current script assumes apt and may not work on macOS or other distros without changes.
- Review the scripts in tools/scripts/ to customize any configuration to your needs.
