# GitHubClientApp


[![Swift Version](https://img.shields.io/badge/Swift-5.5-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/cocoapods/p/Alamofire.svg?style=flat)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

一个使用 UIKit 和 MVVM 架构开发的 GitHub 官方 API 客户端应用，支持查看仓库、搜索、个人资料等功能。

![App Screenshot](Resources/screenshots/app_preview.png)

## 功能特性

- ✅ 认证登录（支持基本认证和生物识别）
- 🔍 仓库搜索与浏览
- 👤 GitHub 个人资料查看
- 🏠 个人仓库列表展示
- 🌗 深色/浅色模式支持
- 🔒 安全的凭据存储
- 🛠 自定义 UI 组件

## 技术栈

- **架构**: MVVM + Coordinator
- **UI**: UIKit (Programmatic UI)
- **网络**: Alamofire
- **图片加载**: Kingfisher
- **安全存储**: KeychainSwift
- **依赖管理**: CocoaPods

## 要求

- iOS 14.0+
- Xcode 13+
- Swift 5.5+

## 安装

### 1. 克隆仓库

```bash
git clone https://github.com/yourusername/github-ios-client.git
cd github-ios-client
