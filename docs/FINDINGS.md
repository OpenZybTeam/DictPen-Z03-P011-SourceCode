# Findings

## Developer mode

`source/ZybQmlFiles/ZybSet/SetDevInfo.qml` implements a hidden developer-mode entry:

1. Open the about-device page and tap the SN row repeatedly.
2. After more than five taps the virtual keyboard opens.
3. The entered text is compared directly with a hard-coded string at line 210.
4. On a match, `debugPage.visible` is set to true.

The comparison is a plain string equality check. There is no hashing, rate limit or server-side validation.

## Debug page

`source/ZybQmlFiles/ZybSet/SetDebugPage.qml` exposes:

- ADB status and enable/disable calls
- Online/offline server switch, persisted with `saveConfigFile` and applied after restart
- Build time and version display

## Recording crash

`source/ZybQmlFiles/ZybSet/SetUserReport.qml` calls `engineSocket.sendEnableSysAutoOffScreen(...)` from `startRecord()` at line 514. The context property `engineSocket` is not registered, so the call raises:

```
ReferenceError: engineSocket is not defined
```

The process then faults inside `libQt5Quick.so.5.10.1` (`SIGSEGV`, PC and LR in the same library). The timing in the runtime log matches the call site, making the missing context property the trigger for the subsequent Quick scene-graph failure.

The same property is also referenced during component completion at lines 222 and 227.
