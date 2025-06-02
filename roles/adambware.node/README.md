# Role: adambware.node

Installs Node.js and related tools on macOS.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

The role primarily uses variables from the main playbook, but you can customize the following in your own variables:

```yaml
# Global npm packages to install
npm_global_packages:
  - yarn
  - typescript
  - ts-node
  - npm-check-updates
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.node
```

## Notes

- Installs Node.js via Homebrew for system-wide use
- Also installs NVM (Node Version Manager) for managing multiple Node.js versions
- Configures NVM in your shell configuration
- Installs common global npm packages
