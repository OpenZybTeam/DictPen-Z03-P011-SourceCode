#!/usr/bin/env python3
"""Extract text resources from the Qt resource section of the Z03 firmware.

The Z03 ELF embeds a Qt resource tree (qt_resource_data / _name / _struct).
Resource names are UTF-16BE; file payloads are length-prefixed and may be
zlib-compressed (qCompress format: 4-byte big-endian size + zlib stream).

Offsets below match the P011 build analysed in this repository. They can be
overridden for other builds that use the same layout.
"""

import argparse
import os
import struct
import sys
import zlib

DEFAULT_STRUCT = 0x1A3ACC
DEFAULT_NAMES = 0x1A5EFC
DEFAULT_DATA = 0x1A9F54
DEFAULT_NODES = 421
NODE_SIZE = 22


def read_name_table(blob, base):
    names = {}
    pos = base
    while pos + 6 <= len(blob):
        length = struct.unpack_from(">H", blob, pos)[0]
        end = pos + 6 + length * 2
        if length > 255 or end > len(blob):
            break
        try:
            name = blob[pos + 6:end].decode("utf-16-be")
        except UnicodeDecodeError:
            break
        if any(ord(ch) < 32 for ch in name):
            break
        names[pos - base] = name
        pos = end
    return names


def read_nodes(blob, base, count):
    nodes = []
    for index in range(count):
        pos = base + index * NODE_SIZE
        if pos + NODE_SIZE > len(blob):
            break
        name_offset, flags = struct.unpack_from(">IH", blob, pos)
        field_a, field_b = struct.unpack_from(">II", blob, pos + 6)
        nodes.append((name_offset, flags, field_a, field_b))
    return nodes


def walk_tree(nodes, names):
    paths = {}
    seen = set()

    def visit(index, prefix):
        if index in seen or index >= len(nodes):
            return
        seen.add(index)
        name_offset, flags, child_count, child_offset = nodes[index]
        name = names.get(name_offset, "?%d" % name_offset)
        current = prefix + "/" + name if prefix else ("" if index == 0 else name)
        if index:
            paths[index] = current
        if flags & 0x02:
            for child in range(child_count):
                visit(child_offset + child, current)

    visit(0, "")
    return paths, seen


def load_payload(blob, data_base, offset, compressed):
    if data_base + offset + 4 > len(blob):
        raise ValueError("data offset out of range: 0x%x" % offset)
    length = struct.unpack_from(">I", blob, data_base + offset)[0]
    payload = blob[data_base + offset + 4:data_base + offset + 4 + length]
    if compressed:
        expected = struct.unpack_from(">I", payload, 0)[0]
        payload = zlib.decompress(payload[4:])
        if len(payload) != expected:
            raise ValueError("decompressed size mismatch")
    return payload


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("binary", help="Z03 ELF file")
    parser.add_argument("-o", "--output", default="qrc_out", help="output directory")
    parser.add_argument("--struct-offset", type=lambda x: int(x, 0), default=DEFAULT_STRUCT)
    parser.add_argument("--names-offset", type=lambda x: int(x, 0), default=DEFAULT_NAMES)
    parser.add_argument("--data-offset", type=lambda x: int(x, 0), default=DEFAULT_DATA)
    parser.add_argument("--nodes", type=int, default=DEFAULT_NODES)
    parser.add_argument(
        "--extensions",
        default=".qml,.js",
        help="comma-separated suffixes to extract; empty means every resource",
    )
    parser.add_argument("--all", action="store_true", help="extract every resource")
    args = parser.parse_args()

    with open(args.binary, "rb") as handle:
        blob = handle.read()
    if blob[:4] != b"\x7fELF":
        sys.exit("not an ELF file")

    names = read_name_table(blob, args.names_offset)
    nodes = read_nodes(blob, args.struct_offset, args.nodes)
    paths, reached = walk_tree(nodes, names)
    if not paths:
        sys.exit("resource tree not found; check the offset options")

    extensions = tuple(
        item.strip().lower() for item in args.extensions.split(",") if item.strip()
    )
    written = 0
    for index, path in paths.items():
        name_offset, flags, _, data_offset = nodes[index]
        if flags & 0x02:
            continue
        clean = path.split("?", 1)[0]
        if not args.all and extensions and not clean.lower().endswith(extensions):
            continue
        try:
            payload = load_payload(blob, args.data_offset, data_offset, flags & 0x01)
        except Exception as exc:
            print("skip %s: %s" % (path, exc), file=sys.stderr)
            continue
        target = os.path.join(args.output, clean.lstrip("/"))
        os.makedirs(os.path.dirname(target) or ".", exist_ok=True)
        with open(target, "wb") as handle:
            handle.write(payload)
        written += 1

    print(
        "names=%d nodes=%d reachable=%d written=%d"
        % (len(names), len(nodes), len(reached), written)
    )


if __name__ == "__main__":
    main()
