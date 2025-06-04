# OS Version Compatibility

This playbook supports multiple macOS versions with a simplified, version-agnostic approach.

## Supported Versions

- **macOS Monterey (12.x)** - Fully supported
- **macOS Ventura (13.x)** - Fully supported
- **macOS Sonoma (14.x)** - Fully supported
- Older versions may work but are not officially supported

## Version Detection

The playbook detects your macOS version but applies the same settings regardless of version, focusing on compatibility:

```yaml
# In the adambware.osx role
- name: Check macOS version and set feature flags
  ansible.builtin.include_tasks: version_check.yml
  tags: ['osx', 'osx-version']
```

## Testing Version Compatibility

Use the test playbook to verify compatibility with your macOS version:

```bash
# Test the OSX role on your current macOS version
./setup.sh --test --role=adambware.osx
```

## Future Compatibility

This role uses a simplified, version-agnostic approach that should work with future macOS versions without modifications in most cases. If version-specific settings become necessary, they can be added to the appropriate task files.
