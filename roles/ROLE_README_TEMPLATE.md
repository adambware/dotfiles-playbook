# Role: {{ role_name }}

{{ role_description }}

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+

## Role Variables

Available variables are listed below, along with default values (if any):

```yaml
# Example variable
example_var: default_value
```

## Structure

This role follows Ansible best practices:

- User-configurable variables go in `defaults/main.yml`
- Only include a `vars` directory if you have internal variables that shouldn't be overridden
- Keep tasks organized in logical groups in `tasks/main.yml`
- Include proper documentation in this README

## Example

```yaml
- hosts: localhost
  roles:
    - role: {{ role_name }}
```

## Notes

- Add any special notes or considerations here
- Document any important behaviors
- List any side effects or dependencies

## Idempotence

This role is designed to be fully idempotent:

- Describe specific idempotence considerations for this role
- List any checks in place to prevent unnecessary changes
- Mention any specific patterns used to ensure idempotence
- Document any potential idempotence issues or edge cases

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
