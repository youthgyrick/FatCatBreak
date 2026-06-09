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
- Xcode Command Line Tools（无需完整 Xcode）

## 构建 `.app`

在终端中运行：

```bash
./scripts/build_app.sh
open dist/FatCatBreak.app
```

构建脚本使用 Command Line Tools 中的 `clang` 编译 Objective-C/AppKit 发布入口，不调用 Swift 或 `xctest`。这样可以避开旧版 Command Line Tools 中 Swift 编译器与 SDK 模块版本不一致（例如 Swift 5.4 编译器读取 Swift 5.5 SDK）的问题。

如果系统找不到编译器，可先运行 `xcode-select --install`。若已经安装但工具损坏，可先执行 `sudo rm -rf /Library/Developer/CommandLineTools`，再重新运行安装命令。

第一次打开未签名的本地构建时，如果 macOS 阻止启动，可在 Finder 中右键应用并选择“打开”。正式分发时应使用 Apple Developer 证书签名并公证。

## 开发

```bash
swift run FatCatBreak
# 单元测试需要完整 Xcode 中的 xctest
swift test
```

`scripts/build_app.sh` 打包的是 `Native/main.m` 中不依赖 Swift 运行时的兼容版本。Swift Package 保留用于现代 Xcode 下的开发与倒计时单元测试。两个入口的默认休息时长均为 20 秒。
