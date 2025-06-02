# Role: adambware.test

A testing role that validates the successful installation and configuration of your macOS environment.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+
- All other roles must be applied first

## Role Variables

The role uses variables from the main playbook to check that everything was properly installed.

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.test
```

## Notes

- This role performs validation tests only
- It checks that core components are installed and working
- Run this role after all other roles to verify your setup
- No changes are made to your system by this role

## Tests Performed

- Verifies Homebrew installation
- Verifies ZSH installation and configuration
- Verifies Node.js and npm installation
- Verifies Ruby installation
- Checks for critical Homebrew packages
- Checks for important GUI applications
