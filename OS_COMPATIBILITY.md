# OS Version Compatibility

This playbook supports multiple macOS versions with an approach focused on compatibility.

## Supported Versions

- **macOS Monterey (12.x)** - Fully supported
- **macOS Ventura (13.x)** - Fully supported
- **macOS Sonoma (14.x)** - Fully supported
- **Future macOS versions** - Basic compatibility likely but not guaranteed
- **Older versions** - Limited support, may work but not officially tested

## Architecture Support

The playbook supports both Intel (x86_64) and Apple Silicon (arm64) Macs:

- **Apple Silicon**: Uses `/opt/homebrew` path
- **Intel**: Uses `/usr/local` path

## Version Detection

The playbook automatically detects your macOS version and architecture:

```yaml
# In the adambware.osx role
- name: Check macOS version and set feature flags
  ansible.builtin.include_tasks: version_check.yml
  tags: ['osx', 'osx-version']
```

## Testing

```bash
# Run OS compatibility tests
./setup.sh --test --os-compat-test

# Test a specific role
./setup.sh --test --role=adambware.osx
```

## Future Compatibility

This playbook uses an approach that should work with future macOS versions:

1. **Version detection**: Automatically adapts to your macOS version
2. **Conservative defaults**: Uses settings compatible across versions where possible
3. **Testing framework**: Verifies compatibility on different macOS versions
