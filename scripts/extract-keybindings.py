#!/usr/bin/env python3
"""Extract keybindings from Neovim Lua configuration files."""

import os
import re
import glob
from collections import defaultdict

def extract_keybindings_from_file(filepath):
    """Extract keybindings from a single Lua file."""
    keybindings = []

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        # Pattern to match vim.keymap.set calls
        pattern = r'vim\.keymap\.set\s*\(\s*["\']([^"\']*)["\'],\s*["\']([^"\']*)["\'][^}]*desc\s*=\s*["\']([^"\']*)["\']'

        matches = re.findall(pattern, content, re.MULTILINE)

        for mode, key, desc in matches:
            keybindings.append({
                'file': os.path.basename(filepath),
                'mode': mode,
                'key': key,
                'description': desc
            })

    except Exception as e:
        print(f"Error processing {filepath}: {e}")

    return keybindings

def main():
    """Generate keybinding documentation."""

    # Find all Lua files
    lua_files = glob.glob('lua/**/*.lua', recursive=True)
    lua_files.extend(glob.glob('*.lua'))

    all_keybindings = []

    for filepath in lua_files:
        keybindings = extract_keybindings_from_file(filepath)
        all_keybindings.extend(keybindings)

    # Group by mode
    keybindings_by_mode = defaultdict(list)
    for kb in all_keybindings:
        keybindings_by_mode[kb['mode']].append(kb)

    # Generate markdown
    os.makedirs('docs', exist_ok=True)

    with open('docs/KEYBINDINGS.md', 'w') as f:
        f.write("# Keybindings Reference\n\n")
        f.write("*Auto-generated from configuration files*\n\n")

        # Mode descriptions
        mode_descriptions = {
            'n': 'Normal Mode',
            'i': 'Insert Mode',
            'v': 'Visual Mode',
            'x': 'Visual Block Mode',
            't': 'Terminal Mode',
            'c': 'Command Mode'
        }

        for mode in sorted(keybindings_by_mode.keys()):
            mode_desc = mode_descriptions.get(mode, f"Mode '{mode}'")
            f.write(f"## {mode_desc}\n\n")
            f.write("| Key | Description | Source |\n")
            f.write("|-----|-------------|--------|\n")

            # Sort by key
            sorted_bindings = sorted(keybindings_by_mode[mode], key=lambda x: x['key'])

            for kb in sorted_bindings:
                key = kb['key'].replace('|', '\\|')  # Escape pipes for markdown
                desc = kb['description'].replace('|', '\\|')
                source = kb['file'].replace('.lua', '')
                f.write(f"| `{key}` | {desc} | {source} |\n")

            f.write("\n")

    print(f"Generated keybinding documentation with {len(all_keybindings)} keybindings")

if __name__ == '__main__':
    main()
