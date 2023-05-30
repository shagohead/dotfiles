#!/usr/bin/env python3
# Extended version of color_test script, that can show us HSL or RGB values.
# Correctly works in kitty, and not correctly in Terminal.app.

from collections import namedtuple
import colorsys
import enum
import argparse
import sys
import re
import os


class Mode(enum.Enum):
    table = enum.auto()


HLS = tuple[float, float, float]
RGB = namedtuple("RGB", ["r", "g", "b"])
RGBRE = re.compile(r"^rgb:(?P<red>.{2}).{2}/(?P<green>.{2}).{2}/(?P<blue>.{2}).{2}$")


def getcurrentrgb(cid: int) -> RGB:
    try:
        os.system(
            "stty raw -echo min 0; printf '\\e]4;%s;?\\a'; read -r  -d '\\' tmp; "
            "printf $tmp | sed 's/^.*\\;//;s/[^rgb:0-9a-f/]//g' > ./tmp" % cid
        )
        with open("./tmp") as f:
            if m := RGBRE.match(f.read()):
                v = m.groupdict()
                return RGB(v['red'], v['green'], v['blue'])
            raise RuntimeError("RGB regexp does not match")
    finally:
        os.remove('./tmp')


def rgb2hls(source: RGB) -> HLS:
    return colorsys.rgb_to_hls(*[int(c, 16) / 255 for c in source])


def table(*args):
    parser = argparse.ArgumentParser(prog=" ".join(sys.argv[:2]))
    parser.add_argument("colors", nargs="*", type=int, default=range(255))
    args = parser.parse_args(args)
    for cid in args.colors:
        print("\r", end="")
        os.system("printf '\\e[48;5;%sm%8s\\e[0m'" % (cid, ""))
        print(" %3s " % cid, end="")
        rgb = getcurrentrgb(cid)
        print(f"RGB: #{''.join(rgb)}", end=" ")
        h, l, s = rgb2hls(rgb)
        print(f"HSL: ({round(h * 360)}, {round(s * 100)}%, {round(l * 100)}%)")
    print("\r")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Shell color test script")
    parser.add_argument("mode", choices=list(Mode.__members__.keys()))
    args = parser.parse_args(sys.argv[1:2])
    globals()[args.mode](*sys.argv[2:])
