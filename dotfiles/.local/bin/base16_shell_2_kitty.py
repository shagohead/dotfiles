#!/usr/bin/env python3

import argparse
from io import TextIOWrapper
import os
from pathlib import Path
import re
import sys


COLOR_DEF = re.compile(r'(?P<name>color\d+)=(?P<spec>[^\s]+)')
COLOR_NAME = re.compile(r'^color(\d+)$')
KITTY_CONFIG_DIR = Path('~/.config/kitty').expanduser()


def main():
    if not KITTY_CONFIG_DIR.exists():
        print('Directory', KITTY_CONFIG_DIR, 'not found')
        exit(1)

    parser = argparse.ArgumentParser(description=(
        'Base16 shell script to kitty color scheme converter.'
    ))
    parser.add_argument(
        'source_script', type=argparse.FileType('r'),
        help='Base16 shell script',
    )
    args = parser.parse_args(sys.argv[1:])
    file: TextIOWrapper = args.source_script

    colors: dict[str, str] = {}
    deferred: dict[str, str] = {}
    metainfo: list[str] = []
    for line in file:
        match = COLOR_DEF.match(line)
        if match:
            color = match.groupdict()
            spec: str = color['spec']
            if spec.startswith('$'):
                deferred[color['name']] = spec[1:]
            else:
                colors[color['name']] = '#' + spec.replace('/', '').replace('"', '')
        elif not colors and line.startswith('#') and not line.startswith('#!'):
            metainfo.append(line)
    for name, ref in deferred.items():
        colors[name] = colors[ref]

    output = "# Converted from base16-shell script\n"
    if metainfo:
        output += "".join(metainfo) + "\n"
    ordered = dict()
    for key in sorted(colors.keys()):
        match = COLOR_NAME.match(key)
        if not match:
            raise ValueError(f'Key "{key}" not matched regexp')
        newkey = f'color{int(match.group(1))}'
        ordered[newkey] = colors[key]
    output += "\n".join(map(lambda kv: f'{kv[0]} {kv[1]}', ordered.items()))
    source_path = Path(file.name)
    themes_dir = KITTY_CONFIG_DIR / 'themes'
    if not themes_dir.exists():
        os.mkdir(themes_dir)
    filename = source_path.name
    if source_path.suffix == '.sh':
        filename = filename[::-1].replace('.sh'[::-1], '.conf'[::-1], 1)[::-1]
    with open(themes_dir / filename, 'w') as file:
        file.write(output)
    print(themes_dir / filename)


if __name__ == '__main__':
    main()
