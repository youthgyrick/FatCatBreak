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
- 本地构建需要 Swift toolchain（Command Line Tools 或 Xcode）


## Todo List 与系统设置

Swift/AppKit 主应用启动后会打开 `FatCatBreak` 主窗口，默认进入 **Todo** Tab。Todo 页包含今日焦点卡片、胖猫品牌图、今日任务统计、下一次休息提示、`Take Break Now` 按钮，以及 `Today` / `All Tasks` / `Completed` 三个任务视图。任务支持标题、可选 due date、完成状态、删除和本地持久化；已完成任务不会从 Today 视图消失，而是以 checked checkbox 和删除线展示。

**System Settings** Tab 承接休息提醒设置：`Trigger interval` 保持 0.1–168 小时范围，`Stay duration` 保持 1–600 秒范围，并保留 `Launch FatCatBreak at login`、`Take Break Now`、`Quit`、`Apply` 操作。

## 构建 `.app`

在终端中运行：

```bash
./scripts/build_app.sh
open dist/FatCatBreak.app
```

构建脚本会编译 Swift/AppKit 主应用，并打包为正规的 `.app`。打开后默认进入 **Todo** Tab，可切换到 **System Settings** 管理休息提醒。

第一次打开未签名的本地构建时，如果 macOS 阻止启动，可在 Finder 中右键应用并选择“打开”。正式分发时应使用 Apple Developer 证书签名并公证。

如果执行 `open` 后没有出现窗口，请先确认 Swift toolchain 可用，并运行 `swift build` 查看编译错误。

## 开发

```bash
swift run FatCatBreak
# 单元测试需要完整 Xcode 中的 xctest
swift test
```

`scripts/build_app.sh` 打包的是 Swift/AppKit 主应用；`Native/main.applescript` 保留为旧版 AppleScriptObjC 休息遮罩参考实现。默认休息时长为 20 秒。
