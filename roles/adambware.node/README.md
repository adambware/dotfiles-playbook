# Role: adambware.node

Installs Node.js and related tools on macOS.

## Requirements

- macOS (Big Sur or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

The role primarily uses variables from the main playbook, but you can customize the following in your own variables:

```yaml
# Node.js version
node_lts_version: "lts"

# Global NPM packages to install
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

- Uses tj/n (Node Version Manager) for managing Node.js versions
- Does not install Node.js via Homebrew as it's redundant when using n
- Configures n in your shell configuration
- Installs common global npm packages

## Why tj/n Instead of NVM?

This role uses tj/n instead of NVM for several reasons:

1. **Simplicity**: n is simpler and more lightweight than NVM
2. **Performance**: n has less overhead and faster shell initialization
3. **Ease of use**: n has a more straightforward command syntax
4. **Maintenance**: n requires less configuration and management

## Idempotence

This role has been enhanced for better idempotence:

- Checks if npm packages are already installed before installation
- Properly registers shell command outputs to avoid unnecessary changes
- Uses appropriate `changed_when` directives for shell commands
- Only installs packages that aren't already installed
- Respects check mode for all operations

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
