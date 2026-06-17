# FatCatBreak（胖猫休息）

一个常驻 Dock 的原生 macOS 强制屏幕休息应用。它会按设置窗口中指定的小时周期触发透明休息窗口，让一只胖橘猫在桌面上走来走去；停留指定秒数后恢复桌面并等待下一次休息。

## 功能

- 默认 30 秒休息倒计时，可设置 1 至 600 秒并从设置窗口立即触发
- 每次休息随机播放一个胖猫小剧场：散步、打盹、举牌提醒、喝水或转动脖子
- 休息期间按 ESC 可立即恢复桌面并退出应用
- 可设置 0.1 至 168 小时的触发周期，支持 `0.5` 等小数
- 胖猫停留时间可设置为 1 至 600 秒，默认 30 秒
- 可在设置窗口启用登录时自动启动或退出应用
- 登录启动复选框点击后立即生效，无需再按 Apply
- 启动后默认只驻留 Dock，不自动弹出设置窗口
- 自定义胖猫风格应用图标
- 背景完全透明，不再使桌面变暗
- 覆盖所有显示器、桌面空间和全屏应用
- 休息期间拦截鼠标和键盘输入，并隐藏 Dock 与菜单栏
- 原生矢量胖猫，60 FPS 行走和身体起伏动画
- 无图片资源、无网络请求、无第三方依赖
- 结束后自动恢复系统界面并等待下一次休息

> macOS 始终保留系统级安全退出能力（例如电源键等）。普通应用无法也不应该绕过操作系统的最终安全控制。

## 系统要求

- macOS 10.15 Catalina 或更高版本
- 无需 Xcode、Command Line Tools 或其他开发工具

## 构建 `.app`

在终端中运行：

```bash
./scripts/build_app.sh
open dist/FatCatBreak.app
```

构建脚本通过 macOS 自带的 `/usr/bin/osacompile -s` 把 AppleScriptObjC 脚本保存为常驻 applet。运行时使用系统 AppKit 和 WebKit，不调用 `clang`、Swift、`xcrun`、SDK 或 `xctest`，因此不受本机 Command Line Tools 版本混装影响。

打开应用后默认只驻留 Dock，不会自动显示设置窗口。点击或双击 Dock 中的“胖猫休息”即可打开设置；点击 Apply 保存后，设置窗口会关闭并回到 Dock 常驻状态。默认触发周期为 2 小时，默认停留时间为 30 秒，设置会在后续启动中保留。

第一次打开未签名的本地构建时，如果 macOS 阻止启动，可在 Finder 中右键应用并选择“打开”。正式分发时应使用 Apple Developer 证书签名并公证。

如果执行 `open` 后没有出现窗口，请运行：

```bash
./scripts/run_debug.sh
```

调试脚本会在前台显示 AppleScriptObjC 错误；应用本身也会把启动和异常信息写入 macOS 统一日志。

当前发布入口不再使用 JXA 的 Objective-C Bridge，因此不会触发旧版 macOS 在解析 `CGRect`/`NSScreen.frame` 时出现的 `NSGetSizeAndAlignment` 崩溃。AppleScriptObjC 调用也已拆成逐步变量，避免旧版 AppleScript 解析器无法处理 `object()’s method()` 链式语法；内容视图尺寸使用 `frame()` 获取，避免旧版解析器把 `bounds` 识别成 AppleScript 内置属性并在 `bounds()` 处报 `-2741`。NSApplication 实例使用 `breakApplication` 保存，而不使用 `app`，因为部分旧版解析器会把 `app` 规范化成只读的 `application` 术语并报 `-10003`。日志通过 Foundation `NSLog` 写入 macOS 统一日志，避免 Tahoe 的 AppleScript 解析器在旧式 `path to library folder from user domain` 和 `do shell script` 语句处报 `-2741`。

打包脚本兼容不同 macOS 版本生成的 applet：如果 `Info.plist` 缺少 `CFBundleIdentifier` 等字段，会自动创建，而不是因 `PlistBuddy Set` 失败而中止。

透明背景同时应用于 `NSWindow`、`WKWebView` 的 under-page 底色和 HTML 页面，可避免 macOS Tahoe 上 WebKit 默认白底或窗口底色透出的情况。

## 开发

```bash
swift run FatCatBreak
# 单元测试需要完整 Xcode 中的 xctest
swift test
```

`scripts/build_app.sh` 打包的是 `Native/main.applescript` 中的免编译版本。Swift Package 仅保留给拥有现代 Xcode 的开发者进行源码开发与倒计时单元测试；普通用户构建和运行应用不需要 Swift。
