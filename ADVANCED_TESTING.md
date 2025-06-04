# Advanced Testing

This document describes the advanced testing capabilities added to the dotfiles-playbook.

## Quick Start

Run all tests with detailed logging:
```bash
./test_all.sh
```

## Available Test Types

### Individual Role Tests
Test specific roles independently:
```bash
./setup.sh --test --role=adambware.node
```

### Integration Tests
Test interactions between related roles:
```bash
./setup.sh --integration-test
```

### macOS Version Tests
Test version-specific features:
```bash
./setup.sh --version-test
```

### Idempotence Tests
Verify that running the playbook twice makes no changes on the second run:
```bash
./setup.sh --idempotence
```

## Test Results

All test results are saved to:
- `~/dotfiles-test-results/TIMESTAMP/` when using `test_all.sh`
- Specified output file when using `--output=FILE`

## Troubleshooting

If tests fail:
1. Check detailed logs 
2. Try running with `-v` for more verbosity
3. Run specific tests or roles to isolate the issue

See [TESTING.md](TESTING.md) for more detailed information.
