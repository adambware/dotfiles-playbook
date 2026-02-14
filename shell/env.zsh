#
# Environment & PATH
#

export PAGER=less
export EDITOR=vim

# PATH
export PATH="/usr/local/bin:$HOME/.rbenv/shims:$HOME/.n/bin:/usr/bin:/bin:/usr/sbin:/sbin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
fi

# rbenv
export RBENV_ROOT="$HOME/.rbenv"
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init -)"
fi

# n (Node version manager)
export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

# Google Cloud SDK
if [[ -f "$(brew --prefix 2>/dev/null)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]]; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi
