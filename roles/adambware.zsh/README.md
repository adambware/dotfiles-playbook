# Role: adambware.zsh

Installs and configures ZSH shell with Oh My Zsh for an optimal command-line experience.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+
- Administrator access (for changing the default shell)

## Role Variables

The role primarily uses variables from the main playbook:

```yaml
# ZSH path based on architecture
zsh_path: "{{ homebrew_bin }}/zsh"
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.zsh
```

## Notes

- Installs ZSH via Homebrew
- Sets ZSH as the default shell
- Installs Oh My Zsh with sensible defaults
- Deploys custom configuration files:
  - Shell aliases
  - Environment variables
  - Completions
  - Custom ZSH theme
  - Oh My Zsh configuration
