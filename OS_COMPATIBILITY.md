# OS Version Compatibility

This playbook supports multiple macOS versions with a comprehensive testing approach to ensure compatibility across different environments.

## Supported Versions

- **macOS Monterey (12.x)** - Fully supported
- **macOS Ventura (13.x)** - Fully supported
- **macOS Sonoma (14.x)** - Fully supported
- **Future macOS versions** - Basic compatibility with testing required
- **Older versions** - Limited support, may work but not officially tested

## Architecture Support

The playbook supports both Intel (x86_64) and Apple Silicon (arm64) Macs with architecture-specific optimizations:

- **Apple Silicon**: Uses `/opt/homebrew` path and arm64-native binaries
- **Intel**: Uses `/usr/local` path and x86_64-native binaries

## Version Detection

The playbook automatically detects your macOS version and architecture:

```yaml
# In the adambware.osx role
- name: Check macOS version and set feature flags
  ansible.builtin.include_tasks: version_check.yml
  tags: ['osx', 'osx-version']
```

## Comprehensive Testing

### OS-Specific Testing

Use the enhanced testing commands to verify compatibility with your specific macOS version:

```bash
# Run OS compatibility tests
./setup.sh --test --os-compat-test

# Test a specific role on your macOS version
./setup.sh --test --role=adambware.osx --os-compat-test
```

### Architecture Testing

The tests automatically verify that the correct architecture-specific configurations are applied:

```bash
# Testing specific architecture configurations
./setup.sh --test --tags=homebrew
```

## Version-Specific Features

Role implementations contain version-specific code for handling differences between macOS versions:

- **Monterey (12.x)**: Full support for all features
- **Ventura (13.x)**: Includes Ventura-specific UI and security settings 
- **Sonoma (14.x)**: Supports Sonoma's new features and settings

## Future Compatibility

This playbook uses a future-proof approach:

1. **Version detection**: Automatically adapts to your macOS version
2. **Conservative defaults**: Uses settings compatible across versions where possible
3. **Graceful degradation**: Falls back to compatible options on unsupported features
4. **Testing framework**: Verifies compatibility on each macOS version

## Testing on Multiple OS Versions

If you maintain multiple Macs with different macOS versions:

```bash
# Get a detailed compatibility report
./setup.sh --test --os-compat-test --output=~/Desktop/os_compat_report.txt
```

For detailed information on testing across multiple macOS versions, see the [Testing Guide](TESTING.md).
