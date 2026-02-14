#!/usr/bin/env bash
#
# Language runtime setup: Python (pyenv), Ruby (rbenv), Node (n)
# Run: ./setup languages
#

set -euo pipefail

###############################################################################
# Configuration                                                               #
###############################################################################

PYTHON_VERSION="3.12.0"
PYTHON_PACKAGES=(ipython jupyter black flake8 pylint pytest requests pyyaml pipenv poetry)

RUBY_VERSION="3.3.0"
RUBY_GEMS=(bundler rake rails solargraph rubocop pry)

NODE_VERSION="lts"
NPM_PACKAGES=(yarn typescript ts-node npm-check-updates)

###############################################################################
# Python (pyenv)                                                              #
###############################################################################

echo "--- Python (pyenv) ---"

brew install pyenv 2>/dev/null || true

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

if ! pyenv versions | grep -q "$PYTHON_VERSION"; then
  echo "Installing Python $PYTHON_VERSION..."
  pyenv install "$PYTHON_VERSION"
fi

pyenv global "$PYTHON_VERSION"
pip install --upgrade pip --quiet

for pkg in "${PYTHON_PACKAGES[@]}"; do
  pip install "$pkg" --quiet 2>/dev/null || true
done
echo "Python $PYTHON_VERSION ready."

###############################################################################
# Ruby (rbenv)                                                                #
###############################################################################

echo "--- Ruby (rbenv) ---"

brew install rbenv ruby-build 2>/dev/null || true

export RBENV_ROOT="$HOME/.rbenv"
eval "$(rbenv init -)"

if ! rbenv versions | grep -q "$RUBY_VERSION"; then
  echo "Installing Ruby $RUBY_VERSION..."
  rbenv install -s "$RUBY_VERSION"
fi

rbenv global "$RUBY_VERSION"
gem update --system --quiet 2>/dev/null || true

for gem in "${RUBY_GEMS[@]}"; do
  gem install "$gem" --quiet 2>/dev/null || true
done
echo "Ruby $RUBY_VERSION ready."

###############################################################################
# Node.js (n)                                                                 #
###############################################################################

echo "--- Node.js (n) ---"

export N_PREFIX="$HOME/.n"
export PATH="$N_PREFIX/bin:$PATH"

if [[ ! -d "$N_PREFIX" ]]; then
  echo "Installing n and Node.js..."
  curl -fsSL https://raw.githubusercontent.com/tj/n/master/bin/n-install | bash -s -- -y "$NODE_VERSION"
else
  n "$NODE_VERSION" 2>/dev/null || true
fi

for pkg in "${NPM_PACKAGES[@]}"; do
  npm install -g "$pkg" --silent 2>/dev/null || true
done
echo "Node.js ready."
