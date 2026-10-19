# Resource Recovery Notes

The Z03 application ships its QML and JavaScript inside the ELF executable through the Qt resource system. This note documents the layout used to rebuild `source/`.

## Input

- Device executable: `/usr/bin/Z03`
- Size: 4,103,844 bytes
- ELF32 ARM EABI5, hard-float
- Qt runtime: 5.10.1

## Resource arrays

The Qt resource compiler emits three arrays. Their locations in this build are:

| Array | File offset | Contents |
|-------|-------------|----------|
| `qt_resource_struct` | `0x1a3acc` | 421 tree nodes, 22 bytes each |
| `qt_resource_name` | `0x1a5efc` | 419 name records |
| `qt_resource_data` | `0x1a9f54` | concatenated file payloads |

The resource tree is walked breadth-first. Each directory node stores the absolute index of its first child.

## Name records

```
u16  length          number of UTF-16 code units
u32  hash            Qt string hash
u16  chars[length]   UTF-16 big-endian
```

Name offsets in tree nodes are relative to the start of `qt_resource_name`.

## Tree nodes

All nodes are 22 bytes. The first fields differ by node type, followed by an eight-byte timestamp.

Directory:

```
u32 name_offset
u16 flags            0x02 Directory, 0x01 Compressed
u32 child_count
u32 first_child      absolute node index
u64 timestamp
```

File:

```
u32 name_offset
u16 flags
u16 country
u16 language
u32 data_offset      relative to qt_resource_data
u64 timestamp
```

## Data payloads

```
u32 length           payload length in bytes
u8  payload[length]
```

If the compressed flag is set, the payload uses the `qCompress` format:

```
u32 uncompressed_size
u8  zlib_stream
```

## Extraction

`tools/extract_qrc.py` implements this layout. Resource keys that contain a query string (for example `polyfill.min.js?features=es6`) are written without the query suffix.

```bash
# QML and JavaScript only
python3 tools/extract_qrc.py Z03 -o extracted

# All embedded resources
python3 tools/extract_qrc.py Z03 -o extracted --all
```

## Verification

Three QML files were also present as plaintext in a device coredump:

- `ZybQmlFiles/ZybSet/SetDevInfo.qml`
- `ZybQmlFiles/ZybSet/SetUserReport.qml`
- `ZybQmlFiles/ZybVirturlKeyBoard/ZybDigitalKeyBoard.qml`

Their resource copies match the coredump copies byte for byte apart from a missing trailing newline in the coredump copies.

## Why qmlc caches were not used

The device also stores compiled QML caches (`qv4cdata`, cache version `0x14`). These units have flags `0x27`, including `ContainsMachineCode`, and use the `jit` code generator with the `arm-little_endian-ilp32-eabi-hardfloat` architecture. Function bodies are ARM Thumb machine code (for example `4d f8 04 ed`), so they contain neither Moth bytecode nor the original source text. The cache is useful for structure recovery only; the resource bundle is the authoritative source.
