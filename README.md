# 胖猫休息（FatCatBreak）

一个原生 macOS 强制屏幕休息小应用。启动后，半透明遮罩会覆盖所有显示器，一只胖橘猫在桌面上走来走去；20 秒倒计时结束后，应用自动关闭并恢复桌面。

## 功能

- 固定 20 秒休息倒计时
- 覆盖所有显示器、桌面空间和全屏应用
- 休息期间拦截鼠标和键盘输入，并隐藏 Dock 与菜单栏
- 原生矢量胖猫，60 FPS 行走和身体起伏动画
- 无图片资源、无网络请求、无第三方依赖
- 结束后自动恢复系统界面并退出

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

构建脚本通过 macOS 自带的 `/usr/bin/osacompile` 把 JXA（JavaScript for Automation）保存为正规的 applet。运行时使用系统 AppKit 和 WebKit，不调用 `clang`、Swift、`xcrun`、SDK 或 `xctest`，因此不受本机 Command Line Tools 版本混装影响。

第一次打开未签名的本地构建时，如果 macOS 阻止启动，可在 Finder 中右键应用并选择“打开”。正式分发时应使用 Apple Developer 证书签名并公证。

如果执行 `open` 后没有出现窗口，请运行：

```bash
./scripts/run_debug.sh
cat ~/Library/Logs/FatCatBreak.log
```

调试脚本会在前台显示 JXA 错误；应用本身也会把启动和异常信息写入日志。

打包脚本兼容不同 macOS 版本生成的 applet：如果 `Info.plist` 缺少 `CFBundleIdentifier` 等字段，会自动创建，而不是因 `PlistBuddy Set` 失败而中止。

## 开发

```bash
swift run FatCatBreak
# 单元测试需要完整 Xcode 中的 xctest
swift test
```

`scripts/build_app.sh` 打包的是 `Native/main.js` 中的免编译版本。Swift Package 仅保留给拥有现代 Xcode 的开发者进行源码开发与倒计时单元测试；普通用户构建和运行应用不需要 Swift。两个入口的默认休息时长均为 20 秒。
