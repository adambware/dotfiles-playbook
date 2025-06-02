# Role: adambware.homebrew-install

Installs Homebrew package manager on macOS with support for both Intel and Apple Silicon Macs.

## Requirements

- macOS (Big Sur or later)
- Ansible 2.10+
- Administrator access

## Role Variables

Available variables are listed below:

```yaml
# These are typically set in the main vars file:
is_apple_silicon: "{{ ansible_architecture == 'arm64' }}"
homebrew_prefix: "{{ '/opt/homebrew' if is_apple_silicon else '/usr/local' }}"
homebrew_bin: "{{ homebrew_prefix }}/bin"
homebrew_brew_bin: "{{ homebrew_bin }}/brew"
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.homebrew-install
```

## Notes

- The role automatically detects the Mac architecture (Intel vs Apple Silicon)
- For Apple Silicon Macs, Homebrew is installed to `/opt/homebrew`
- For Intel Macs, Homebrew is installed to `/usr/local`
- The role adds Homebrew to your PATH via `.zshrc` for Apple Silicon Macs
