# Role: adambware.ruby

Installs Ruby via rbenv with support for both Intel and Apple Silicon Macs.

## Requirements

- macOS (Monterey 12.0 or later)
- Homebrew installed (provided by adambware.homebrew-install role)
- Ansible 2.10+

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Ruby version to install
ruby_version: "3.3.0"

# Common Ruby gems to install
ruby_gems:
  - bundler
  - rake
  - rails
  - solargraph
  - rubocop
  - pry
```

## Example

```yaml
- hosts: localhost
  roles:
    - role: adambware.ruby
```

## Notes

- Installs rbenv and ruby-build via Homebrew
- Sets up rbenv in your shell configuration
- Installs the specified Ruby version
- Sets the installed version as the global default
- Updates RubyGems to the latest version
- Installs common Ruby gems

## Idempotence

This role has been enhanced for better idempotence:

- Checks if Ruby gems are already installed before installation
- Properly registers shell command outputs to avoid unnecessary changes
- Uses appropriate `changed_when` directives for shell commands
- Only installs gems that aren't already installed

You can test the idempotence of this role using:

```bash
./setup.sh --idempotence
```
