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

- macOS 13 Ventura 或更高版本
- Xcode 15 或 Swift 5.9+

## 构建 `.app`

在终端中运行：

```bash
./scripts/build-app.sh
open dist/FatCatBreak.app
```

第一次打开未签名的本地构建时，如果 macOS 阻止启动，可在 Finder 中右键应用并选择“打开”。正式分发时应使用 Apple Developer 证书签名并公证。

## 开发

```bash
swift run FatCatBreak
swift test
```

核心倒计时逻辑位于 `BreakSession`，界面与猫咪绘制位于 `BreakView`。需要调整休息时长时，修改 `BreakSession.defaultDuration`。
