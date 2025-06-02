# Role: adambware.homebrew-packages

Installs command-line packages via Homebrew on macOS.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

Available variables are listed below:

```yaml
# Homebrew taps to add
brew_taps:
  - homebrew/core
  - homebrew/cask
  # etc.

# Packages to install
brew_packages:
  - git
  - wget
  - python
  # etc.
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.homebrew-packages
```

## Notes

- The role automatically updates Homebrew before installing packages
- The default packages focus on development tools and utilities
