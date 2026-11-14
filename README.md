# dotfiles

This repository contains my dotfiles and scripts to quickly bootstrap and configure a development environment on Debian/Ubuntu-based systems.

What does this project do?
- Installs base dependencies: curl, git, vim, tmux, ripgrep.
- Sets up Zsh as the shell and Starship as the prompt.
- Configures Tmux.
- Installs and configures Neovim.
- Creates symlinks for configuration files (.zshrc, .tmux.conf and nvim/tmux/zsh/starship.toml under ~/.config). Existing files are never overwritten silently: you choose replace / backup / skip.
- Asks, one by one, whether to install optional tools: Claude Code, FNM (Node), Java (SDKMAN + Maven), Bun, Docker (Linux), OrbStack (macOS), Go, pyenv, tmuxifier. Each one writes its own zsh snippet to .config/zsh/conf.d/ (git-ignored, loaded by .zshrc).

Main structure
- init.sh: main script that orchestrates installation and configuration.
- tools/install_dependencies.sh: installs base dependencies and triggers configurations.
- tools/scripts/*.sh: helper scripts (zsh, starship, tmux, commons, base_dependencies, ui).
- tools/scripts/ui.sh: output helpers: numbered step banners, spinner for long commands (output goes to ~/.dotfiles-install.log), final summary.
- tools/gitconfig.sh: interactive ~/.gitconfig generator with per-folder profiles (work, personal, ...): each profile sets the email and SSH key via `includeIf "gitdir:<folder>/"`. Profiles live in ~/.config/git/profiles/. Run by init.sh, or `bash tools/gitconfig.sh`.
- tools/manual/ideavim.sh: links ~/.ideavimrc, only for IntelliJ + IdeaVim users (not run by init.sh).
- tools/neovim_install.sh: Neovim build from source (macOS: brew).
- tools/link_config.sh: standalone, interactive linker for ~/.config (`bash tools/link_config.sh`).
- tools/optional/*.sh: optional tool installers, orchestrated by tools/optional/all.sh.
- tools/doctor.sh: read-only health check (commands, symlinks, zsh/nvim/tmux/starship config load, optional tools). `bash tools/doctor.sh`, exits 1 if something fails.

Requirements
- Debian/Ubuntu (apt) or macOS (Homebrew). On macOS, Homebrew will be installed automatically if not present.
- Sudo privileges (apt flows).
- Internet connection.

How to use
1. Clone the repository:
   git clone https://github.com/your-username/dotfiles.git
   cd dotfiles
2. Run the initializer (it may ask for your sudo password):
   bash init.sh            # spinner, command output in ~/.dotfiles-install.log
   bash init.sh --verbose  # show every command's output live

Notes
- The current script assumes apt and may not work on macOS or other distros without changes.
- Review the scripts in tools/scripts/ to customize any configuration to your needs.
