#!/usr/bin/env python3

import argparse
import colorsys
from io import TextIOWrapper
import re
import sys


COLOR_DEF = re.compile(r'^(?P<idx>color\d+)[\s]+(?P<spec>#?\w+)$')
HLS = tuple[float, float, float]
MAX_LIGHTNESS = 0.9
TEMPLATE = """

background {color0}
foreground {color7}

selection_background {color7}
selection_foreground {color0}

url_color {color20}

cursor {color7}
cursor_text_color background

active_border_color {color8}
inactive_border_color {color18}

active_tab_background {color0}
active_tab_foreground {color7}
inactive_tab_background {color19}
inactive_tab_foreground {color20}
tab_bar_background {color18}

mark1_foreground {color0}
mark1_background {color1}
"""


def main():
    parser = argparse.ArgumentParser(description=(
        'Kitty color scheme patcher that rewrites color scheme file with replacing '
        'kitty special colors with values from ANSI colors in sourced scheme file. '
        'Patcher awaits file with at least 21 defined ANSI colors (like in base16).'
    ))
    parser.add_argument(
        'source_conf', type=argparse.FileType('r+'),
        help='Source theme file that have only color* definitions',
    )
    args = parser.parse_args(sys.argv[1:])
    file: TextIOWrapper = args.source_conf

    colors: dict[str, str] = {}
    comments: list[str] = []
    for line in file:
        match = COLOR_DEF.match(line)
        if match:
            color = match.groupdict()
            colors[color['idx']] = color['spec']
        elif line.startswith('#'):
            comments.append(line)

    def hex_to_hls(source: str) -> HLS:
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

    bg_lightness = hex_to_hls('color0')[1]
    if bg_lightness > MAX_LIGHTNESS:
        bg_lightness = MAX_LIGHTNESS

    colors['color52'] = hls_to_hex(set_lightness(hex_to_hls('color1'), bg_lightness))
    colors['color22'] = hls_to_hex(set_lightness(hex_to_hls('color2'), bg_lightness))
    colors['color88'] = hls_to_hex(set_lightness(hex_to_hls('color1'), bg_lightness, True))
    colors['color28'] = hls_to_hex(set_lightness(hex_to_hls('color2'), bg_lightness, True))
    colors['color27'] = hls_to_hex(set_lightness(hex_to_hls('color4'), bg_lightness))
    colors['color53'] = hls_to_hex(set_lightness(hex_to_hls('color5'), bg_lightness))

    output = ""
    if comments:
        output += "".join(comments) + "\n"
    output += "\n".join(map(lambda kv: f'{kv[0]} {kv[1]}', colors.items()))
    output += TEMPLATE.format(**colors)
    file.seek(0)
    file.write(output)
    print(file.name)

if __name__ == '__main__':
    main()
