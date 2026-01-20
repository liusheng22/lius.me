---
title: "macOS 提示「已损坏，无法打开」怎么办？（Gatekeeper 解决办法）"
date: 2026-01-20
draft: false
tags: ["macOS", "Gatekeeper", "应用安装", "安全"]
categories: ["macOS"]
description: "安装第三方 App 时遇到「xxx 已损坏，无法打开。你应该将它移到废纸篓。」的常见解决办法：右键打开、隐私与安全允许、移除 quarantine 等。"
---

有时你从浏览器下载一个 `.app`（或从压缩包/DMG 拖出来），双击打开时 macOS 会弹窗：

> “xxx 已损坏，无法打开。你应该将它移到废纸篓。”

![已损坏无法打开弹窗](/images/macos-app-is-damaged-fix/00-image.png)

这个弹窗经常不是“文件真的坏了”，而是 Gatekeeper 把这个 App 标记成了“来自互联网下载”，然后直接拦截（常见触发点就是 `com.apple.quarantine` 这个扩展属性）。

下面给一个“按步骤走就行”的通用处理流程（更贴近这个弹窗本身）。

## 推荐流程（按顺序来）

### 1) 确认 App 在 /Applications（可选，但建议）

把应用拖到「应用程序（/Applications）」再试一次打开，避免路径/权限带来的额外干扰。

如果还是弹“已损坏”，继续下一步。

### 2) 移除 quarantine（核心步骤）

如果你确认应用来源可信（例如 GitHub Releases / 自己构建 / 可信网站下载），接下来的操作就可以移除它的 quarantine 标记（以解决「已损坏」提示）。

```bash
sudo xattr -dr com.apple.quarantine 
```

全选上面的命令，复制后粘贴到你的`终端` 然后在 `com.apple.quarantine ` 后面加上你的 App 路径(直接把你的 App 拖到终端就会自动粘贴路径)。输入后的示例如下👇👇👇

```bash
sudo xattr -dr com.apple.quarantine "/Applications/导出微信表情包.app"
```

![终端执行 xattr 命令](/images/macos-app-is-damaged-fix/01-image.png)

执行时系统可能会弹出 sudo 授权（输入密码/Touch ID 允许即可）：

![sudo 授权弹窗](/images/macos-app-is-damaged-fix/02-image.png)

如果你的 App 不在 `应用程序(Applications)` 目录下，把 `.app` 直接拖进 Terminal 会自动粘贴路径（再在前面补上 `sudo xattr -dr com.apple.quarantine ` 回车即可）。

### 3) 再次打开 App

这时回到 Finder 再双击打开（或执行下面这行）：

```bash
open "/Applications/应用名称.app"
```

## 如果你看到的是别的拦截提示

有时弹窗不是“已损坏”，而是下面这类：

- “无法打开，因为 Apple 无法检查其是否包含恶意软件”
- “来自身份不明的开发者”

这类通常可以在「系统设置」->「隐私与安全」里（如图所示的地方👇👇👇）找到“仍要打开/允许打开”（不同 macOS 版本文案略有差异）：

![隐私与安全-安全性区域](/images/macos-app-is-damaged-fix/03-image.png)

## 安全提醒

- 只对你信任来源的应用做“移除 quarantine/允许打开”，这等同于让系统不再拦它。
- 如果你从未知来源拿到的安装包反复触发拦截，建议先别打开，换官方渠道下载。
