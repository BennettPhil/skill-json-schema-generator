#!/usr/bin/env python3

import json
import sys
import argparse

def infer_schema(data):
    if isinstance(data, dict):
        schema = {
            "type": "object",
            "properties": {k: infer_schema(v) for k, v in data.items()},
            "required": list(data.keys())
        }
        return schema
    elif isinstance(data, list):
        if not data:
            return {"type": "array", "items": {}}
        # Simple inference from first item
        return {"type": "array", "items": infer_schema(data[0])}
    elif isinstance(data, str):
        return {"type": "string"}
    elif isinstance(data, bool):
        return {"type": "boolean"}
    elif isinstance(data, int):
        return {"type": "integer"}
    elif isinstance(data, float):
        return {"type": "number"}
    elif data is None:
        return {"type": "null"}
    else:
        return {}

def main():
    parser = argparse.ArgumentParser(description="Usage: json-schema-generator [FILE]")
    parser.add_argument("file", nargs="?", help="JSON file to analyze (or stdin)")
    
    args = parser.parse_args()
    
    try:
        if args.file:
            with open(args.file, 'r') as f:
                data = json.load(f)
        else:
            if sys.stdin.isatty():
                parser.print_help()
                sys.exit(1)
            data = json.load(sys.stdin)
            
        schema = {
            "$schema": "http://json-schema.org/draft-07/schema#",
            **infer_schema(data)
        }
        print(json.dumps(schema, indent=2))
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(2)

if __name__ == "__main__":
    main()
