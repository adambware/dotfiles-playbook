# Role: adambware.python

Installs Python via pyenv with support for managing multiple Python versions.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Python version to install
python_version: "3.12.0"

# Path to pyenv installation
pyenv_root: "{{ ansible_env.HOME }}/.pyenv"

# Common Python packages to install
python_packages:
  - ipython
  - jupyter
  - black
  - flake8
  # etc.
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.python
```

## Notes

- Installs Python via Homebrew for system-wide use
- Also installs pyenv for managing multiple Python versions
- Sets up pyenv in your shell configuration
- Installs the specified Python version via pyenv
- Sets the installed version as the global default
- Updates pip to the latest version
- Installs common Python packages
