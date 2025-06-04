# Role: adambware.osx

Configures macOS system preferences and defaults for optimal development experience with a modular, organized structure.

## Requirements

- macOS (Monterey 12.0 or later)
- Ansible 2.10+
- Administrator access

## Role Variables

The role uses variables defined in `defaults/main.yml` which can be overridden in your playbook.

### General UI

```yaml
# Enable dark mode
enable_dark_mode: true
```

### Input Device Settings

```yaml
# Configure input devices (keyboard, trackpad, etc.)
configure_input_devices: true
configure_trackpad: true
keyboard_auto_capitalize: false
keyboard_auto_smart_dashes: false
keyboard_auto_smart_periods: false
keyboard_auto_smart_quotes: false
trackpad_tap_to_click: true
trackpad_right_click: true
```

### Screen Settings

```yaml
# Configure screenshot and screen behavior
screenshot_location: "{{ ansible_env.HOME }}/Desktop"
screenshot_format: "png"
screenshot_disable_shadow: true
require_password_after_sleep: true
password_delay_seconds: 0
```

### Finder Settings

```yaml
# Configure Finder behavior
show_hidden_files: true
show_file_extensions: true
show_path_in_title_bar: true
show_status_bar: true
finder_default_view: "Nlsv"  # List view
```

### Dock Settings

```yaml
# Configure Dock appearance and behavior
dock_position: "right"  # Options: left, bottom, right
dock_auto_hide: true
dock_magnification: false
dock_minimize_effect: "genie"
dock_show_only_active: false
```

### Safari Settings

```yaml
# Configure Safari
configure_safari: true
safari_show_full_url: true
safari_enable_developer_menu: true
safari_autofill_contacts: false
safari_autofill_passwords: false
```

### Security Settings

```yaml
# Configure security features
enable_filevault: false
enable_firewall: true
disable_remote_login: true
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.osx
      vars:
        enable_dark_mode: true
        dock_position: "left"
        dock_auto_hide: true
        show_hidden_files: true
```

## Structure

The role has been organized into modular task files:

```
tasks/
  ├── main.yml         # Main entry point that includes task files
  ├── version_check.yml # Detects macOS version and sets compatibility warnings
  ├── general_ui.yml   # General UI/UX settings
  ├── input_devices.yml # Keyboard, trackpad, etc. settings
  ├── screen.yml       # Screen and screenshot settings
  ├── finder.yml       # Finder configurations
  ├── dock.yml         # Dock preferences
  ├── safari.yml       # Safari settings
  └── security.yml     # Security and privacy settings
```

## Features

- **Modular Organization**: Settings grouped by function for easier management
- **Comprehensive Customization**: Extensive variables for personalization
- **Improved Idempotence**: Better state detection before making changes
- **Enhanced Testing**: Dedicated test playbook to verify settings

## Testing

The role includes a dedicated test playbook:

```bash
# Run the osx role tests
ansible-playbook roles/adambware.osx/tests/test_osx.yml
```

## Tagging

Individual setting groups can be applied using tags:

```bash
# Apply only Finder settings
ansible-playbook osx.yml --tags="osx-finder"

# Apply Dock and Safari settings
ansible-playbook osx.yml --tags="osx-dock,osx-safari"
```

## Idempotence

This role has been optimized for idempotence:

- All tasks check the current state before making changes
- File operations use proper Ansible modules instead of shell commands
- Visibility settings for folders include checks for current state
- All shell commands include proper `changed_when` directives

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
