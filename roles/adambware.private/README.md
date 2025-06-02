# Role: adambware.private

Installs and configures personal, private settings and files.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+

## Role Variables

The role uses variables from the main playbook.

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
