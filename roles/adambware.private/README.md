# Role: adambware.private

Installs and configures personal, private settings and files.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+

## Role Variables

The role uses variables from the main playbook. Copy `vars/main.yml.example` to `vars/main.yml` to customize.

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.private
```

## Notes

- This role is for personal, private configurations
- It's skipped by default if `setup_private_configs` is set to `false`
- Customize this role with your personal settings
- Consider keeping this role in a private repository

## Idempotence

This role has been enhanced for better idempotence:

- Uses Ansible's file management modules with proper ownership and permissions
- Implements proper checking mechanisms before making changes
- Includes improved VPN configuration with proper state checking
- Uses appropriate `changed_when` directives for all tasks

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
