# Role: adambware.osx

Configures macOS system preferences and defaults for optimal development experience.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+
- Administrator access

## Role Variables

The role primarily uses variables from the main playbook.

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.osx
```

## Notes

- The role modifies various macOS system preferences for productivity
- Changes include Finder settings, dock preferences, and security settings
- All changes are made using the `defaults` command through Ansible
- Some changes may require a restart to take effect

## Features

- Finder enhancements (show hidden files, file extensions, etc.)
- Dock customization
- Security settings (screen lock timing, etc.)
- System performance tweaks
- Application-specific settings (Safari, Terminal, etc.)

## Idempotence

This role has been optimized for idempotence:

- All tasks check the current state before making changes
- File operations use proper Ansible modules instead of shell commands
- Visibility settings for folders use the `community.general.osx_defaults` module
- All shell commands include proper `changed_when` directives

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
