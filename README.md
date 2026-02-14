# Dotfiles

macOS development environment setup. No frameworks, no dependencies beyond Homebrew — just shell scripts and config files.

## Quick Start

```bash
git clone https://github.com/adambware/dotfiles-playbook.git ~/dotfiles
cd ~/dotfiles
./setup
```

## Selective Setup

```bash
./setup homebrew     # Install Homebrew and packages
./setup shell        # Set up ZSH, Oh My Zsh, and dotfiles
./setup git          # Set up git config and global gitignore
./setup macos        # Apply macOS system preferences
./setup languages    # Install Python (pyenv), Ruby (rbenv), Node (n)
./setup private      # Symlink private configs
```

Combine commands: `./setup homebrew shell git`

## Structure

```text
setup                   # Main runner script
config/
  Brewfile              # Homebrew packages and casks
  macos.sh              # macOS system preferences (defaults write)
  languages.sh          # Python, Ruby, Node version manager setup
shell/
  zshrc                 # Main ZSH config (symlinked to ~/.zshrc)
  aliases.zsh           # Shell aliases
  env.zsh               # Environment variables and PATH
  config.zsh            # ZSH options and history settings
  completion.zsh        # Completion settings
  themes/
    adambware.zsh-theme # Custom Oh My Zsh theme
git/
  gitconfig             # Git config (symlinked to ~/.gitconfig)
  gitignore_global      # Global gitignore
private/                # .gitignored — your personal configs
private.example/        # Templates for private/ setup
```

## Private Configs

The `private/` directory is gitignored for secrets and personal settings. See `private.example/` for templates.

Supported private files:

- `private/gitconfig.local` — Git name, email, signing key (included via `[include]` in gitconfig)
- `private/env.local.zsh` — Private env vars, tokens, aliases (sourced by zshrc)
- `private/Brewfile.private` — Extra Homebrew packages for work tools
- `private/ssh_config` — SSH config (symlinked to `~/.ssh/config`)

## Customization

- **Add/remove packages**: Edit `config/Brewfile`
- **Change macOS settings**: Edit `config/macos.sh`
- **Update language versions**: Edit the variables at the top of `config/languages.sh`
- **Modify shell config**: Edit files in `shell/`

## License

MIT
