# Role: adambware.zsh

Configures the built-in ZSH shell with Oh My Zsh for an optimal command-line experience.

## Requirements

- macOS (Big Sur or later, which includes ZSH by default)
- Ansible 2.10+

## Role Variables

The role primarily uses variables from the main playbook:

```yaml
# System ZSH path
zsh_path: "/bin/zsh"
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.zsh
```

## Notes

- Uses the macOS system ZSH (already installed by default since macOS Catalina)
- Verifies ZSH is set as the default shell
- Installs Oh My Zsh with sensible defaults
- Deploys custom configuration files:
  - Shell aliases
  - Environment variables
  - Completions
  - Custom ZSH theme
  - Oh My Zsh configuration

## Idempotence

This role is designed to be fully idempotent:

- Checks if ZSH is already the default shell before attempting to change it
- Verifies if Oh My Zsh is already installed before installation
- Uses Ansible's file management modules with proper ownership and permissions
- Uses the `changed_when` directive to properly track changes
- All configuration file deployments use the `copy` module which is naturally idempotent
- Respects check mode for all operations

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
