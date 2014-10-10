#!/usr/bin/python3

import argparse

HEIGHT = 32
WIDTH = 128


def convert(infile, outfile):
    with open(infile, 'rb') as f:
        src = f.read()

    dst = bytearray([0] * (WIDTH * HEIGHT // 8))

    for i in range(HEIGHT // 8):
        for j in range(WIDTH):
            array_idx = i * WIDTH + j
            for k in range(8):
                page_length = WIDTH * i
                index = page_length + (WIDTH * k + j) // 8
                byte = src[index]
                bit = byte & (1 << (j % 8))
                bit = bit >> (j % 8)
                dst[array_idx] |= bit << k

    with open(outfile, 'wb') as f:
        f.write(dst)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('input')
    parser.add_argument('output')
    args = parser.parse_args()

    convert(args.input, args.output)


main()
