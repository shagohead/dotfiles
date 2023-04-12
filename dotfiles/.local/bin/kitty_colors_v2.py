#!/usr/bin/env python3

import argparse
import colorsys
from io import TextIOWrapper
import re
import sys
from typing import Tuple


SPECIAL_DEF = re.compile(r'^(?P<name>[^\s]+)[\s]+(?P<spec>#?\w+)$')
COLOR_DEF = re.compile(r'^(?P<idx>color\d+)[\s]+(?P<spec>#?\w+)$')
HLS = tuple[float, float, float]
MAX_LIGHTNESS = 0.9
SPECIAL_COLORS = {
    "background": "color0",
    "foreground": "color7",
    "selection_background": "color7",
    "selection_foreground": "color0",
    # "url_color": "color20",
    "cursor": "color7",
    "active_border_color": "color6",
    "inactive_border_color": "color8",
    "bell_border_color": "color5",
    "active_tab_background": "color0",
    "active_tab_foreground": "color7",
    # "inactive_tab_background": "color19",
    # "inactive_tab_foreground": "color20",
    # "tab_bar_background": "color18",
    "mark1_foreground": "color0",
    "mark1_background": "color1",
}
# TEMPLATE = """
# cursor_text_color background
# """


def hex_to_hls(colors: dict[str, str], source: str) -> HLS:
    return colorsys.rgb_to_hls(*[int(colors[source][s:s+2], 16)/255 for s in [1, 3, 5]])

def set_lightness(hls: HLS, lightness: float, increase: bool = False) -> HLS:
    if increase:
        mod = 0.1
        if lightness >= 0.5:
            mod *= -1
        lightness = lightness + mod
    return (hls[0], lightness, hls[2])

def hls_to_hex(hls: HLS) -> str:
    return '#' + ''.join([hex(round(255 * x))[2:].rjust(2, '0') for x in colorsys.hls_to_rgb(*hls)])

def main():
    parser = argparse.ArgumentParser(description=(
        'Kitty color scheme patcher that rewrites color scheme file with replacing '
        'kitty special colors with values from ANSI colors in sourced scheme file. '
    ))
    parser.add_argument('source_conf', type=argparse.FileType('r+'), help='Source theme file')
    args = parser.parse_args(sys.argv[1:])
    file: TextIOWrapper = args.source_conf

    output: list[str] = []
    colors: dict[str, str] = {}
    specials: dict[str, str] = {}
    for line in file:
        line = line.strip()
        output.append(line)
        if match := COLOR_DEF.match(line):
            color = match.groupdict()
            colors[color['idx']] = color['spec']
        elif match := SPECIAL_DEF.match(line):
            color = match.groupdict()
            specials[color['name']] = color['spec']

    added: list[str] = []
    for name, source_idx in SPECIAL_COLORS.items():
        if name not in specials:
            if source_idx not in colors:
                raise KeyError(f'Missing color {source_idx}, that needs for {name}')
            added.append(f'{name} {colors[source_idx]}')

    bg_lightness = min(hex_to_hls(colors, 'color0')[1], MAX_LIGHTNESS)
    new_colors: dict[str, str] = {}

    lightness_colors: dict[str, Tuple[str, bool]] = {}

    # Diff: удаление
    # lightness_colors['color52'] = ('color1', False) # red
    # lightness_colors['color88'] = ('color1', True) # red

    # # Diff: добавление
    # lightness_colors['color22'] = ('color2', False) # green
    # lightness_colors['color28'] = ('color2', True) # green

    # # Diff: изменение
    # lightness_colors['color27'] = ('color4', False) # blue
    # lightness_colors['color53'] = ('color5', False) # magenta
    # lightness_colors['color220'] = ('color3', False) # yellow

    for color, spec in lightness_colors.items():
        if color not in colors:
            source, increase = spec
            new_colors[color] = hls_to_hex(
                set_lightness(
                    hex_to_hls(colors, source),
                    bg_lightness,
                    increase
                )
            )

    # FIXME: генерация серых цветов

    added += list(map(lambda kv: f'{kv[0]} {kv[1]}', new_colors.items()))
    if added:
        output.append("\n# added by kitty_colors_v2")
        output += added
    file.seek(0)
    file.write("\n".join(output))
    print(file.name)

if __name__ == '__main__':
    main()
