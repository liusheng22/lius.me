---
title: "uni-app (App) 的全局组件注入工具（Vue2/Vue3 都支持）"
date: 2026-01-21
draft: false
tags: ["uni-app", "Vue2", "Vue3", "Webpack", "Vite", "插件", "工程化"]
categories: ["uni-app"]
description: "一个 uni-app 全局组件注入工具：用 pages.json 配置，把指定组件自动注入到所有页面（可按平台生效、可排除页面），同时支持 Vue2(Webpack) 和 Vue3(Vite)。"
---

写 uni-app 的 App 端时，难免会遇到这种产品需求：

- 全局操作弹窗
- 全局 Toast
- 全局消息通知

然而现实是：uni-app 并没有像 Vue 那样的“全局组件注入机制”。

即使你用了 `easycom` 做到组件“随用随引”，你还是得在每个页面都写一遍：

```vue
<CustomModal :title="title" :content="content" />
```

但这样显然不优雅，而且容易漏加/加错，工程量也大，不利于维护。

所以我做了 `uni-global-component-inject` 这个 loader：**用配置的方式，把全局组件自动注入到每个页面里**，并且同时支持：

- uni-app Vue2（Webpack）
- uni-app Vue3（Vite）

## 这个项目解决什么痛点

- 全局组件不用“每页复制粘贴”了：一次配置，全站注入
- 可控：可以排除某些页面不注入（比如登录页/纯展示页）
- 可按平台生效：比如只在 `app-plus` 注入，不影响小程序/H5
- 注入的不只是一个“空标签”：你可以自定义注入的 element（带 props / 事件）

## 怎么用？

1) 在构建侧接入（Vue2 用 loader，Vue3 用 Vite plugin）  
2) 在 `pages.json` 里加一段 `injectLoader` 配置，告诉它要注入哪些组件

### Vue3（Vite）用法

安装：

```bash
pnpm add uni-global-component-inject -D
```

`vite.config.js`：

```js
import uni from '@dcloudio/vite-plugin-uni'
import uniGlobalComponentPlugin from 'uni-global-component-inject/vite'
import { defineConfig } from 'vite'

export default defineConfig({
  plugins: [
    uni(),
    uniGlobalComponentPlugin({
      platforms: ['app-plus'],
    }),
  ],
})
```

`pages.json`（示例）：

```json
{
  "injectLoader": {
    "injectTags": [
      { "name": "CustomModal" }
    ],
    "rootEle": "view"
  }
}
```

### Vue2（Webpack）用法

安装：

```bash
npm install uni-global-component-inject -D
```

`vue.config.js`（示例，按你的工程路径调整）：

```js
const path = require('node:path')
const { defineConfig } = require('@vue/cli-service')

const projectRoot = path.resolve(__dirname, '../')
const injectLoader = path.resolve(projectRoot, 'node_modules/uni-global-component-inject/loader.js')

module.exports = defineConfig({
  configureWebpack: {
    module: {
      rules: [
        {
          test: /\.vue$/,
          loader: injectLoader,
          options: {
            platforms: ['app-plus'],
          },
        },
      ],
    },
  },
})
```

`pages.json` 配置和 Vue3 一样。

## pages.json 能配什么

下面这些都是我写这个工具时觉得“必须得有”的能力：

```json
{
  "injectLoader": {
    "injectTags": [
      {
        "name": "CustomModal",
        "element": "<CustomModal :title=\\\"title\\\" @close=\\\"closeHandle\\\" />",
        "excludes": ["pages/about"]
      }
    ],
    "excludeTagsPaths": ["pages/setting"],
    "rootEle": "view"
  }
}
```

- `injectTags[].name`：必填，你的组件名（按 uni-app easycom 约定放在 `components/`）
- `injectTags[].element`：可选，自定义注入的标签内容（props/事件都能写）
- `injectTags[].excludes`：可选，哪些页面不注入这个组件
- `excludeTagsPaths`：可选，哪些页面不注入任何全局组件
- `rootEle`：必填，你页面根元素是 `view` 还是 `div`（不同端/不同写法会影响注入位置）

> 更多配置请参考详细配置文档 [Vue2](https://github.com/liusheng22/uni-global-component-inject/blob/main/packages/global-inject/README.md) / [Vue3](https://github.com/liusheng22/uni-global-component-inject/blob/main/packages/global-inject/README_VUE3.md)

## 示例项目

我在仓库里放了一个 monorepo 示例，包含 Vue2/Vue3 两套 playground，你可以直接跑起来看效果 [vue2&vue3 示例项目](https://github.com/liusheng22/uni-global-component-inject/tree/main/packages/playground)：

1. `git clone https://github.com/liusheng22/uni-global-component-inject.git`
2. `pnpm i`
3. 用 HBuilderX 打开：
   - Vue2：`packages/playground/vue2`
   - Vue3：`packages/playground/vue3`

## 最后

如果你也正在 uni-app 里折腾全局弹窗/悬浮组件，欢迎来试试这个 loader：

- github：[全局组件注入](https://github.com/liusheng22/uni-global-component-inject)
- npm 包：[uni-global-component-inject](https://www.npmjs.com/package/uni-global-component-inject)
- 示例项目：[vue2/vue3 示例项目](https://github.com/liusheng22/uni-global-component-inject/tree/main/packages/playground)