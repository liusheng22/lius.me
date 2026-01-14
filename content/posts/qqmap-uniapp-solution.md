---
title: "腾讯地图 SDK 接入到 uniapp 的多端解决方案"
date: 2025-11-27
draft: false
tags: ["uniapp", "腾讯地图", "SDK", "Vue3", "Vite"]
categories: ["uniapp", "SDK", "Vue3", "Vite"]
description: "基于腾讯官方微信小程序JavaScript SDK v1.2，专为现代化开发环境打造的ES模块版本"
---

## qqmap-uniapp：腾讯地图SDK的现代化解决方案

> 基于腾讯官方微信小程序JavaScript SDK v1.2，专为现代化开发环境打造的ES模块版本

### 背景：为什么需要这个包？

在开发基于 Vue3 + Vite 的 uni-app 项目时，笔者遇到了两个关键问题：

#### 问题1：模块格式不兼容

腾讯官方提供的 qqmap-wx-jssdk.min.js 是一个 **CommonJS** 格式的文件，而现代构建工具如 Vite、Webpack 5+ 默认使用 **ES Module（ESM）** 格式。

```javascript
// ❌ 官方SDK使用CommonJS格式
var QQMapWX = require('qqmap-wx-jssdk.min.js');

// ✅ Vue3 + Vite需要ESM格式
import QQMapWX from 'qqmap-uniapp';
```

**问题表现：**

* Vite 无法正确解析 `module.exports`，导致导入失败
* 编译错误：`require is not defined` or `ReferenceError: Can't find variable: require __ERROR`

#### 问题2：平台限制过于严格

官方SDK只支持微信小程序环境，使用了 `wx.request` 进行网络请求，这限制了其在其他平台的使用：

```javascript
// 官方SDK中只使用wx.request
wx.request({
  url: 'https://apis.map.qq.com/ws/...',
  success: function(res) { /* ... */ }
});
```

在 uni-app 跨平台开发中，我们需要使用 `uni.request` 来实现一套代码多端运行。

**问题表现：**

* 无法在 H5、APP、支付宝小程序等平台使用
* 被迫使用条件编译，增加了维护成本

### qqmap-uniapp 的解决方案

#### 核心特性

1. **ESM 支持**  
   * 完整的 ES Module 格式，支持 `import/export` 语法  
   * 与 Vite、Webpack 5+ 等现代构建工具完美兼容  
   * 支持 Tree-shaking，减少打包体积

2. **跨平台兼容**  
   * 使用 `uni.request` 替代 `wx.request`  
   * 支持 uni-app 的所有平台：H5、小程序、APP  
   * 保持与官方 API 完全一致的接口

3. **API 完全兼容**  
   * 基于腾讯官方 v1.2 版本  
   * 8 个核心方法全部保留：  
     * `search()` - 地点搜索  
     * `getSuggestion()` - 关键词输入提示  
     * `reverseGeocoder()` - 逆地址解析  
     * `geocoder()` - 地址解析  
     * `direction()` - 路线规划  
     * `getCityList()` - 获取城市列表  
     * `getDistrictByCityId()` - 获取城市区县  
     * `calculateDistance()` - 距离计算

### 使用示例

#### 保持与腾讯官方 API 示例完全一致

```javascript
// 示例和参数与原版完全相同：
const qqmapsdk = new QQMapWX({
  key: 'YOUR_KEY'
});

// 使用方法完全一致
qqmapsdk.search({
  keyword: '酒店',
  location: '39.908823,116.397470',
  success: function(res) {
    console.log(res);
  }
});
```

#### 在 uni-app 项目中使用

```javascript
// 1. 安装
npm install qqmap-uniapp

// 2. 引入
import QQMapWX from 'qqmap-uniapp';

// 3. 初始化
const qqmapsdk = new QQMapWX({
  key: '您的开发者密钥'
});

// 4. 使用API
onMounted(() => {
  // 地点搜索
  qqmapsdk.search({
    keyword: '酒店',
    location: '39.908823,116.397470',
    success: (res) => {
      console.log('搜索结果：', res);
    },
    fail: (err) => {
      console.error('搜索失败：', err);
    }
  });
});
```

#### 在 Vue3 + Vite 项目中使用

> 查看更多实际用法示例，欢迎访问案例仓库：[demo 代码 & 预览（GitHub）](https://github.com/liusheng22/qqmap-uniapp)

### 对比：官方 SDK vs qqmap-uniapp

| 特性           | 官方SDK      | qqmap-uniapp |
| ------------ | ---------- | ------------ |
| 模块格式         | CommonJS   | ES Module    |
| 导入方式         | require()  | import       |
| 构建工具支持       | 需要额外配置     | 开箱即用         |
| 平台支持         | 仅微信小程序     | uni-app 全平台  |
| 网络请求         | wx.request | uni.request  |
| Tree-shaking | ❌          | ✅            |
| Vite 兼容      | ❌          | ✅            |
| 体积优化         | -         | 支持按需引入       |
| 现代 JS 语法     | 旧语法        | 现代语法         |

> 如果您正在使用 Vue3 + Vite 或 uni-app 开发项目，需要集成腾讯地图功能，欢迎尝试 qqmap-uniapp。

### 相关链接

* 📦 [npm 包](https://www.npmjs.com/package/qqmap-uniapp)
* 📚 [使用文档](https://github.com/liusheng22/qqmap-uniapp)
* 🏢 [腾讯地图官方文档](https://lbs.qq.com/service/webService/webServiceGuide/webServiceOverview)
* 💾 [GitHub 源码](https://github.com/liusheng22/qqmap-uniapp)

---

*原文发布于 [掘金](https://juejin.cn/post/7565708613970018331)*

