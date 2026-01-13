---
title: "Capacitor + React：iOS 侧滑返回手势（WKWebView 原生方案）"
date: 2026-01-13
draft: false
tags: ["Capacitor", "iOS", "WKWebView", "React", "allowsBackForwardNavigationGestures", "手势返回", "CAPBridgeViewController"]
description: "在 Capacitor iOS 容器中为 React SPA 启用系统原生侧滑返回：allowsBackForwardNavigationGestures + scrollRestoration 配合，避免返回预览白屏。"
---

> 适用对象：用 Capacitor 把 React SPA 打包成 iOS App，二级页面希望支持系统左侧边缘右滑返回（交互式侧滑返回手势）。

## 问题背景

在 WKWebView（Capacitor iOS 容器）里跑 React Router 这类 SPA，经常会遇到：

- 二级页面无法侧滑返回；
- 能侧滑但上级页面预览是白屏/黑屏（看不到上一页内容）；
- 自己实现手势（截图 + 叠层 + `history.back()`）会引入大量时序/兼容性坑。

## 结论：优先用系统能力，而不是自研手势

核心思路：让 WebView 直接启用 WebKit 自带的交互式返回手势。

在 iOS 上，这个开关就是：

```swift
webView.allowsBackForwardNavigationGestures = true
```

这比“自研 edge-pan + snapshot”可靠得多：交互曲线、阈值、上一页预览快照、渲染时机都由系统处理。

## 最小可用改动（3 步）

下面这 3 步就是能通过验收的关键（其余优化都可以后放）。

### 1) 用自定义 `CAPBridgeViewController` 子类接管 WKWebView 配置

文件：`ios/App/App/AppDelegate.swift`

- 新增 `AppViewController: CAPBridgeViewController`
- 在 `viewDidLoad()` 里统一设置背景色（减少“闪白/闪黑”），并启用系统手势

```swift
@objc(AppViewController)
class AppViewController: CAPBridgeViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = UIColor.systemBackground
    self.webView?.isOpaque = true
    self.webView?.backgroundColor = UIColor.systemBackground
    self.webView?.scrollView.backgroundColor = UIColor.systemBackground

    self.webView?.allowsBackForwardNavigationGestures = true
  }
}
```

### 2) storyboard 把初始 VC 指向你的自定义 VC

文件：`ios/App/App/Base.lproj/Main.storyboard`

把初始控制器从 Capacitor 的 `CAPBridgeViewController` 改成你自己的：

- `customClass="AppViewController"`
- `customModule="App"`

示例：

```xml
<viewController id="BYZ-38-t0r" customClass="AppViewController" customModule="App" sceneMemberID="viewController"/>
```

### 3) Web 侧配合(可选)：禁用浏览器自动滚动恢复

文件：`src/App.tsx`

```ts
useEffect(() => {
  if ("scrollRestoration" in history) {
    history.scrollRestoration = "manual"
  }
}, [])
```

原因很简单：系统侧滑返回预览依赖 WebKit 的历史快照，但 SPA 在返回时的“自动滚动恢复”会让快照捕获到不一致/空白的中间态（尤其是列表页、滚动后返回最明显）。

## Web 端跳转配置建议（push / replace）

- Tab 根页面之间（例如首页/我的）建议用 `replace`，避免把 Tab 切换写入回退栈，出现“Tab 之间也能侧滑回退”的反直觉体验  
  - `<Link to="/home" replace />` 或 `navigate("/home", { replace: true })`
- 二级页面（例如设置/资料）保持默认的 `push`，让它进入历史栈，从而可被系统侧滑返回

一句话：该 `push` 的 `push`，该 `replace` 的 `replace`。这决定了 iOS 系统手势到底会回到哪里。

## 经验与踩坑

- 优先使用系统 API：自研手势要处理快照时机、渲染竞态、手势冲突、`webView.isHidden` 黑屏等问题，成本和风险都很高
- Native 与 Web 必须联动：WKWebView 的历史栈 + SPA 的路由栈 + 滚动恢复，是同一个系统
- 真机 + 滚动场景必测：很多“预览白屏”只有在页面滚动后才会暴露
- 背景色是兜底不是解法：它只能减少“闪一下”的主观感受，核心仍是让系统正确拿到历史快照
