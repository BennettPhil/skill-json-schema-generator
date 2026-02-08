---
name: json-schema-generator
description: A tool that infers a valid JSON Schema from sample JSON data.
version: 0.1.0
license: Apache-2.0
---

# JSON Schema Generator

## Purpose
This skill helps developers quickly bootstrap JSON Schema definitions by analyzing existing JSON data. It recursively traverses the input to detect types, required fields, and nested structures.

## Quick Start

```bash
$ echo '{"name": "test"}' | ./scripts/run.py
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "name": {
      "type": "string"
    }
  },
  "required": ["name"]
}
```

## Usage Examples

### Example: Nested Objects

```bash
$ echo '{"meta": {"version": 1}}' | ./scripts/run.py
```

### Example: Arrays

```bash
$ echo '[{"id": 1}]' | ./scripts/run.py
```

## Options Reference
- `file`: Path to a JSON file (positional argument). If omitted, reads from stdin.

## Validation
This skill's correctness is validated by `scripts/test.sh`, which verifies inference for all primary JSON types and nested structures.
