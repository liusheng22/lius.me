---
title: "export-wechat-emoji：一键把微信收藏表情包导出来（方便导入飞书/企微/钉钉）"
date: 2026-01-19
draft: false
tags: ["微信", "表情包", "飞书", "企微", "钉钉", "Tauri", "macOS"]
categories: ["工具", "效率"]
description: "一个 macOS 小工具：自动读取本机微信收藏表情包并批量导出到本地，按 50 张分组，方便导入飞书/企微/钉钉，也可以用来备份。"
---

很多人都有同一个烦恼：微信里收藏了一堆顺手的表情包，但到了飞书/企微/钉钉这些工作 IM 里就用不上了。手动一张张保存太折磨，截图又糊。

所以我做了个小工具：`export-wechat-emoji`，目标就一句话——把「微信收藏」里的表情包，尽量省事地导出到本地: [下载地址](https://github.com/liusheng22/export-wechat-emoji/releases)。

## 它能干嘛

- 自动找到 macOS 上微信的数据目录，支持多账号选择
- 解析微信的收藏表情包数据（`Stickers/fav.archive`），把表情包的图片链接扒出来
- 一键批量下载到本地
- 默认按「每 50 张」分文件夹保存（因为很多平台一次最多导入 50 张）
- 导出完成后自动打开导出目录

## 怎么用（大概三步）

1. 去 GitHub Releases 下载最新版本（macOS）：<https://github.com/liusheng22/export-wechat-emoji/releases>
2. 打开软件，选账号（如果你有多个微信账号）
3. 点导出，然后去导出目录里按文件夹分批导入到飞书/企微/钉钉

## 注意事项

- 目前主要支持 macOS（我自己日常用的环境）
- 需要你电脑上装了微信客户端，并且登录过、收藏里确实有表情包
- 微信客户端升级后数据结构可能会变；如果导出失败，欢迎提 Issue 我来跟进

## 我比较在意的点

- 全程本地处理，不会把任何东西上传到服务器
- 这是个「搬运/备份」工具：你导出后怎么用（导入到哪个平台）由你决定

## 项目地址

- GitHub：<https://github.com/liusheng22/export-wechat-emoji>
