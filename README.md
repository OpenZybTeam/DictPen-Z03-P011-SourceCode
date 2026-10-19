# Z03 词典笔 P011 源代码

从 Z03 词典笔 P011 固件中还原的 QML 与 JavaScript 源码。

应用界面使用 QML 编写，JavaScript 模块同样打包在 Qt 资源中。本仓库包含从 `Z03` 可执行文件内完整提取的 QML/JS 资源，内容为原始源码。

## 状态

- 191 个 `.qml` 文件与 8 个 `.js` 文件，合计 2,439,642 字节
- 原始 UTF-8 文本，表达式、注释和字符串字面量完整
- 无 `TODO(compiled)` 占位，无重建表达式
- 已与设备 coredump 中的明文 QML 交叉校验

## 目录结构

```
.
├── README.md
├── docs/
│   ├── FINDINGS.md          # 运行时与安全相关观察
│   └── RECOVERY.md          # 资源提取方法与格式说明
├── source/
│   ├── main.qml
│   ├── NaviPanel.qml
│   ├── polyfill.min.js
│   ├── ZybQmlFiles/
│   │   ├── Funcs/           # UILogics.js、ScanViewLogics.js
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
│   └── MANIFEST.tsv         # 每个文件的路径、大小与 SHA256
└── tools/
    ├── extract_qrc.py       # 从固件 ELF 重建源码目录
    └── decompile_qmlc.py    # 解析 Qt qmlc 缓存（骨架模式）
```

## 模块统计

| 模块 | 文件数 |
|------|------:|
| ZybControls | 57 |
| ZybPages | 54 |
| ZybSet | 31 |
| ZybCamera | 13 |
| ZybInit | 8 |
| 根目录 | 8 |
| ZybStore | 7 |
| ZybVoiceTrans | 7 |
| ZybLayoutViews | 3 |
| ZybScanForTid | 3 |
| ZybPhone | 2 |
| ZybVirturlKeyBoard | 2 |
| Funcs | 2 |
| Global | 1 |
| Style | 1 |

## 固件信息

- 目标设备：Z03 词典笔，P011 版本
- 可执行文件：`/usr/bin/Z03`
- 文件格式：ELF32 ARM EABI5，hard-float，Qt 5.10.1
- QML 与 JavaScript 编译进 Qt 资源系统，设备上没有散落的源文件
- 资源数据为未压缩的 UTF-8 文本，前置 4 字节大端长度；部分二进制资源使用 qCompress（4 字节原始长度加 zlib 流）

完整的 ELF 偏移与记录格式见 `docs/RECOVERY.md`。

## 提取源码

```bash
# 仅提取 QML 与 JavaScript
python3 tools/extract_qrc.py Z03 -o extracted

# 提取全部内嵌资源，包括图片与 HTML
python3 tools/extract_qrc.py Z03 -o extracted --all
```

默认偏移面向 P011 版本。其他采用相同资源布局的版本可通过 `--struct-offset`、`--names-offset`、`--data-offset` 和 `--nodes` 指定。

设备上的 `qmlc` 缓存无法还原原始源码：其函数体为 AOT/JIT 生成的 ARM 机器码。只有缓存可用时，`tools/decompile_qmlc.py` 仍可重建对象树、绑定和别名。

## 校验

`source/MANIFEST.tsv` 记录每个文件的路径、大小与 SHA256。提取结果也已与 `Z03` coredump 中的明文 QML 对比，除 coredump 副本末尾缺少换行外，内容逐字节一致。

## 关键代码位置

- `source/ZybQmlFiles/ZybSet/SetDevInfo.qml`：开发者模式密码校验
- `source/ZybQmlFiles/ZybSet/SetDebugPage.qml`：ADB 开关与在线/离线服务器切换
- `source/ZybQmlFiles/ZybSet/SetUserReport.qml`：`startRecord()` 调用未定义的 `engineSocket`，与崩溃前的 `ReferenceError` 及 `libQt5Quick` 中的 SIGSEGV 对应

详细说明见 `docs/FINDINGS.md`。

## 范围

本仓库仅包含应用源码资源，不包含固件二进制、qmlc 缓存、coredump、运行日志和设备标识信息。第三方打包文件（`jquery.min.js`、`canvg.js`、`html2canvas.js`、`tex-mml-chtml.js`、`qwebchannel.js`、`polyfill.min.js`）遵循各自的许可证。

## 免责声明

本项目用于互操作、维修与安全研究。厂商代码与商标归各自权利人所有。本项目不提供任何担保，使用风险由使用者自行承担。
