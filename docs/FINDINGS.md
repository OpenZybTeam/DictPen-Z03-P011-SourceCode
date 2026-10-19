# 分析发现

## 开发者模式

`source/ZybQmlFiles/ZybSet/SetDevInfo.qml` 实现了隐藏的开发者模式入口：

1. 打开关于设备页面，连续点击 SN 行。
2. 点击超过五次后弹出虚拟键盘。
3. 输入内容在第 210 行与硬编码字符串直接比较。
4. 匹配后设置 `debugPage.visible` 为 true。

该比较是普通字符串相等判断，没有哈希、频率限制或服务端校验。

## 调试页

`source/ZybQmlFiles/ZybSet/SetDebugPage.qml` 提供：

- ADB 状态查询与启停调用
- 在线/离线服务器切换，通过 `saveConfigFile` 持久化，重启后生效
- 构建时间与版本显示

## 录制崩溃

`source/ZybQmlFiles/ZybSet/SetUserReport.qml` 第 514 行在 `startRecord()` 中调用 `engineSocket.sendEnableSysAutoOffScreen(...)`。上下文属性 `engineSocket` 未注册，调用触发：

```
ReferenceError: engineSocket is not defined
```

随后进程在 `libQt5Quick.so.5.10.1` 内部崩溃（`SIGSEGV`，PC 与 LR 均位于该库）。运行日志中的时间与调用点一致，缺失的上下文属性是后续 Quick 场景图故障的触发因素。

该属性在第 222 行和第 227 行的组件完成阶段同样被引用。
