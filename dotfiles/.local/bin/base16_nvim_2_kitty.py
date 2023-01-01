#!/usr/bin/env python3

import argparse
from io import TextIOWrapper
import os
from pathlib import Path
import re
import sys

COLOR_DEF = re.compile(r'base(?P<name>[\dA-Z]{2}) = \'(?P<value>#[\da-z]+)\'')
KITTY_CONFIG_DIR = Path('~/.config/kitty').expanduser()
COLORS_MAP: dict[str, int] = {
    '00': 0,
    '01': 18,
    '02': 19,
    '03': 8,
    '04': 20,
    '05': 7,
    '06': 21,
    '07': 15,
    '08': 1,
    '09': 16,
    '0A': 3,
    '0B': 2,
    '0C': 6,
    '0D': 4,
    '0E': 5,
    '0F': 17,
}
COLORS_ADD = {
    9: 1,
    10: 2,
    11: 3,
    12: 4,
    13: 5,
    14: 6,
}


def main():
    if not KITTY_CONFIG_DIR.exists():
        print('Directory', KITTY_CONFIG_DIR, 'not found')
        exit(1)

    parser = argparse.ArgumentParser(description=(
        'nvim-base16 vim script to kitty color scheme converter.'
    ))
    parser.add_argument(
        'source_script', type=argparse.FileType('r'),
        help='nvim-base16 vim script',
    )
    args = parser.parse_args(sys.argv[1:])
    file: TextIOWrapper = args.source_script

    source_colors: dict[str, str] = {}
    for line in file:
        for re_match in COLOR_DEF.finditer(line):
            color = re_match.groupdict()
            source_colors[color['name']] = color['value']

    colors: dict[int, str] = {}
    for name_base, name_ansi in COLORS_MAP.items():
        colors[name_ansi] = source_colors[name_base]

    for target, source in COLORS_ADD.items():
        colors[target] = colors[source]

    ordered = dict()
    for key in sorted(colors.keys()):
        ordered[f'color{key}'] = colors[key]

    output = "# Converted from base16-shell script\n"
    output += "\n".join(map(lambda kv: f'{kv[0]} {kv[1]}', ordered.items()))
    source_path = Path(file.name)
    themes_dir = KITTY_CONFIG_DIR / 'themes'
    if not themes_dir.exists():
        os.mkdir(themes_dir)
    filename = source_path.name
    if source_path.suffix == '.vim':
        filename = filename[::-1].replace('.vim'[::-1], '.conf'[::-1], 1)[::-1]
    with open(themes_dir / filename, 'w') as file:
        file.write(output)
    print(themes_dir / filename)


if __name__ == '__main__':
    main()
