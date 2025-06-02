# Role: adambware.homebrew-casks

Installs GUI applications via Homebrew Casks on macOS.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

Available variables are listed below:

```yaml
casks:
  # List of applications to install via Homebrew Cask
  - firefox
  - google-chrome
  - visual-studio-code
  # etc.
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.homebrew-casks
```

## Notes

- All applications are installed to the `/Applications` directory
- The role automatically updates Homebrew before installing casks
