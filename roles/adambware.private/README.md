# Role: adambware.private

Installs and configures personal, private settings and files with an improved modular structure.

## Requirements

- macOS (Monterey 12.0 or later)
- Ansible 2.10+

## Role Variables

The role uses variables from the main playbook. Copy `vars/main.yml.example` to `vars/main.yml` to customize.

### Core Variables

```yaml
# Homebrew packages and casks
private_brew_packages: []  # List of Homebrew packages to install
private_brew_casks: []     # List of Homebrew casks to install

# Configuration files
private_config_files: []   # List of configuration files to copy
private_ssh_keys: []       # List of SSH keys to copy
private_git_config: {}     # Git configuration key-value pairs
private_shell_aliases: []  # List of shell aliases to add
```

### Enhanced SSH Key Management

```yaml
# SSH key generation (defaults/main.yml)
ssh_keys_to_generate:
  - path: "{{ ansible_env.HOME }}/.ssh/id_ed25519"
    type: "ed25519"
    passphrase: ""
    comment: "your.name@example.com"

# SSH keys to add to the SSH agent
ssh_keys_to_add_to_agent:
  - "{{ ansible_env.HOME }}/.ssh/id_ed25519"
  - "{{ ansible_env.HOME }}/.ssh/id_rsa"

# SSH known hosts to add
ssh_known_hosts:
  - hostname: "github.com"
  - hostname: "gitlab.com"
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.private
```

## Features

- **Modular Design**: Tasks are organized into logical groups
- **Enhanced SSH Key Management**: 
  - Generates SSH keys if not present
  - Adds keys to the SSH agent
  - Configures known hosts
- **Git Configuration**: 
  - Sets up global Git settings
  - Creates a comprehensive global gitignore file
- **Configuration Management**:
  - Copies configuration files with proper permissions
  - Sets up shell aliases

## Structure

```
tasks/
  ├── main.yml      # Main entry point that includes other task files
  ├── homebrew.yml  # Homebrew packages and casks installation
  ├── ssh.yml       # SSH key management
  ├── git.yml       # Git configuration
  └── configs.yml   # Configuration files and shell aliases
defaults/
  └── main.yml      # Default variables
vars/
  └── main.yml      # Your private variables (copy from main.yml.example)
```

## Idempotence

This role has been enhanced for better idempotence:

- Uses Ansible's file management modules with proper ownership and permissions
- Implements proper checking mechanisms before making changes
- Uses appropriate `changed_when` directives for all tasks
- Respects check mode for all operations

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```

## Testing

The role includes specific tests to validate functionality:

### Running Tests

```bash
# Test only the private role
ansible-playbook roles/adambware.private/tests/test_private.yml

# Test the private role within the main playbook in check mode
ansible-playbook osx.yml --tags=private --check
```

### What's Tested

The tests validate:

1. **SSH Configuration**:
   - Directory permissions
   - Key generation
   - Agent integration
   - Known hosts configuration

2. **Git Configuration**:
   - Global Git settings
   - Global gitignore file

3. **Homebrew**:
   - Package installation
   - Cask installation

4. **Configuration**:
   - Config files existence and permissions
   - Shell aliases integration

### Debugging Tests

If a test fails, you can run with verbose output for more details:

```bash
ansible-playbook roles/adambware.private/tests/test_private.yml -vv
```
