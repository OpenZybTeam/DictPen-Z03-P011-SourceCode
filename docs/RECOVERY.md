# 资源提取说明

Z03 应用把 QML 与 JavaScript 编译进 ELF 可执行文件的 Qt 资源系统。本文记录重建 `source/` 时使用的布局。

## 输入

- 设备可执行文件：`/usr/bin/Z03`
- 大小：4,103,844 字节
- ELF32 ARM EABI5，hard-float
- Qt 运行时：5.10.1

## 资源数组

Qt 资源编译器生成三个数组。本版本中的位置如下：

| 数组 | 文件偏移 | 内容 |
|------|----------|------|
| `qt_resource_struct` | `0x1a3acc` | 421 个树节点，每个 22 字节 |
| `qt_resource_name` | `0x1a5efc` | 419 条名称记录 |
| `qt_resource_data` | `0x1a9f54` | 连续存放的文件负载 |

资源树按广度优先排列。每个目录节点保存第一个子节点的绝对索引。

## 名称记录

```
u16  length          UTF-16 码元数量
u32  hash            Qt 字符串哈希
u16  chars[length]   UTF-16 大端
```

树节点中的名称偏移相对于 `qt_resource_name` 起点。

## 树节点

所有节点均为 22 字节。前几个字段按节点类型区分，后面是 8 字节时间戳。

目录：

```
u32 name_offset
u16 flags            0x02 Directory，0x01 Compressed
u32 child_count
u32 first_child      子节点绝对索引
u64 timestamp
```

文件：

```
u32 name_offset
u16 flags
u16 country
u16 language
u32 data_offset      相对于 qt_resource_data
u64 timestamp
```

## 数据负载

```
u32 length           负载字节数
u8  payload[length]
```

设置压缩标志时，负载使用 `qCompress` 格式：

```
u32 uncompressed_size
u8  zlib_stream
```

## 提取

`tools/extract_qrc.py` 实现了上述布局。包含查询字符串的资源键（例如 `polyfill.min.js?features=es6`）写出时会去掉查询后缀。

```bash
# 仅提取 QML 与 JavaScript
python3 tools/extract_qrc.py Z03 -o extracted

# 提取全部内嵌资源
python3 tools/extract_qrc.py Z03 -o extracted --all
```

## 校验

设备 coredump 中还有三份明文 QML：

- `ZybQmlFiles/ZybSet/SetDevInfo.qml`
- `ZybQmlFiles/ZybSet/SetUserReport.qml`
- `ZybQmlFiles/ZybVirturlKeyBoard/ZybDigitalKeyBoard.qml`

资源副本与 coredump 副本逐字节一致，唯一差异是 coredump 副本末尾缺少换行。

## 未使用 qmlc 缓存的原因

设备上还保存了编译后的 QML 缓存（`qv4cdata`，缓存版本 `0x14`）。这些单元的 flags 为 `0x27`，包含 `ContainsMachineCode`，代码生成器为 `jit`，架构为 `arm-little_endian-ilp32-eabi-hardfloat`。函数体是 ARM Thumb 机器码（例如 `4d f8 04 ed`），既没有 Moth 字节码，也没有原始源码文本。缓存可用于恢复结构，资源包才是源码的权威来源。
