# Role: adambware.auto-updates

Configures macOS automatic updates for security and system maintenance.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+
- Administrator access

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Set to true to enable automatic updates
enable_auto_updates: true

# Set to true to auto-install macOS updates (restarts may occur)
auto_install_macos_updates: false
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.auto-updates
      vars:
        auto_install_macos_updates: true
```

## Notes

- Configures the built-in macOS software update mechanism
- Enables daily update checks
- Can be configured to automatically install app updates
- Can be configured to automatically install macOS system updates
- Always installs security updates by default
