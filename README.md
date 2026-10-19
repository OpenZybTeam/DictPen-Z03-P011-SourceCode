# DictPen Z03 P011 Source Code

Recovered QML and JavaScript sources from the Z03 dictionary pen firmware (P011 build).

The application UI is written in QML and loads JavaScript modules from the same Qt resource bundle. This repository contains the complete set of QML/JS resources extracted from the `Z03` executable, not a rewrite or skeleton.

## Status

- 191 `.qml` files and 8 `.js` files, 2,439,642 bytes in total
- Original UTF-8 text, including expressions, comments and string literals
- No `TODO(compiled)` placeholders and no reconstructed expressions
- Cross-checked against plaintext QML copies found in a device coredump

## Repository layout

```
.
├── README.md
├── docs/
│   ├── FINDINGS.md          # Runtime and security-relevant observations
│   └── RECOVERY.md          # How the resources were extracted
├── source/
│   ├── main.qml
│   ├── NaviPanel.qml
│   ├── polyfill.min.js
│   ├── ZybQmlFiles/
│   │   ├── Funcs/           # UILogics.js, ScanViewLogics.js
│   │   ├── Global/
│   │   ├── Style/
│   │   ├── ZybCamera/
│   │   ├── ZybControls/
│   │   ├── ZybInit/
│   │   ├── ZybLayoutViews/
│   │   ├── ZybPages/
│   │   ├── ZybPhone/
│   │   ├── ZybScanForTid/
│   │   ├── ZybSet/
│   │   ├── ZybStore/
│   │   ├── ZybVirturlKeyBoard/
│   │   └── ZybVoiceTrans/
│   ├── jquery.min.js
│   ├── canvg.js
│   ├── html2canvas.js
│   ├── tex-mml-chtml.js
│   ├── qwebchannel.js
│   └── MANIFEST.tsv         # Path, size and SHA256 for every file
└── tools/
    ├── extract_qrc.py       # Rebuild the source tree from the firmware ELF
    └── decompile_qmlc.py    # Inspect Qt qmlc caches (skeleton mode)
```

## Source statistics

| Module | Files |
|--------|------:|
| ZybControls | 57 |
| ZybPages | 54 |
| ZybSet | 31 |
| ZybCamera | 13 |
| ZybInit | 8 |
| Root | 8 |
| ZybStore | 7 |
| ZybVoiceTrans | 7 |
| ZybLayoutViews | 3 |
| ZybScanForTid | 3 |
| ZybPhone | 2 |
| ZybVirturlKeyBoard | 2 |
| Funcs | 2 |
| Global | 1 |
| Style | 1 |

## Firmware

- Target: Z03 dictionary pen, P011 build
- Executable: `/usr/bin/Z03`
- Format: ELF32 ARM EABI5, hard-float, Qt 5.10.1
- QML and JavaScript are compiled into the Qt resource system, not stored as loose files
- Resource data is uncompressed UTF-8 with a 4-byte big-endian length prefix; some binary resources use qCompress (4-byte size plus zlib)

The exact ELF offsets and record layouts are documented in `docs/RECOVERY.md`.

## Extracting the sources

```bash
# Extract QML and JavaScript from a full Z03 binary
python3 tools/extract_qrc.py Z03 -o extracted

# Extract every embedded resource, including images and HTML
python3 tools/extract_qrc.py Z03 -o extracted --all
```

The default offsets target the P011 build. Use `--struct-offset`, `--names-offset`, `--data-offset` and `--nodes` for other builds with the same resource layout.

The `qmlc` caches on the device are not a source of original code: their function bodies are AOT/JIT ARM machine code. `tools/decompile_qmlc.py` can still reconstruct object trees, bindings and aliases when only caches are available.

## Verification

`source/MANIFEST.tsv` lists every file with its size and SHA256. The extracted files were also compared with the plaintext QML copies recovered from a `Z03` coredump; the only difference was a trailing newline in the coredump copies.

## Notable code paths

- `source/ZybQmlFiles/ZybSet/SetDevInfo.qml` contains the developer-mode password check.
- `source/ZybQmlFiles/ZybSet/SetDebugPage.qml` exposes ADB enable/disable and the online/offline server switch.
- `source/ZybQmlFiles/ZybSet/SetUserReport.qml` calls an undefined `engineSocket` from `startRecord()`; this matches the logged `ReferenceError` before a SIGSEGV in `libQt5Quick`.

See `docs/FINDINGS.md` for details.

## Scope

This repository contains application source resources only. Firmware binaries, qmlc caches, coredumps, runtime logs and device-specific identifiers are not included. Third-party bundles (`jquery.min.js`, `canvg.js`, `html2canvas.js`, `tex-mml-chtml.js`, `qwebchannel.js`, `polyfill.min.js`) remain under their respective licenses.

## Disclaimer

Published for interoperability, repair and security research. Vendor code and trademarks remain the property of their respective owners. No warranty is provided; use at your own risk.
