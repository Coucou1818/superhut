# SuperHUT - 湖南工业大学学生一站式服务APP

<div align="center">

![SuperHUT Logo](assets/icon/logo.png)

**为湖南工业大学学生打造的第三方一站式服务应用**

[![Flutter](https://img.shields.io/badge/Flutter-3.7.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.0+-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/GPL-3.0-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.1.1-brightgreen.svg)](pubspec.yaml)

</div>

## 📱 项目简介

SuperHUT 是专为湖南工业大学学生开发的第三方一站式服务应用。由于官方APP用户体验不佳，我们开发了这个功能更完善、界面更友好的替代方案。

## 🌟 本 Fork 专属优化说明 (Material 3 重构版)

本项目 (`Coucou1818/superhut`) 是基于原仓库的界面焕新版本，主要进行了以下核心体验优化：

- 🎨 **纯正 Material 3 风格**：全面升级至原生 Material 3 (M3) 视觉规范，应用色彩与组件呈现更现代的质感。
- 📱 **Edge-to-Edge 沉浸体验**：全局配置沉浸式状态栏与底部导航栏，去除突兀边界，让内容充分填满屏幕。
- 🧭 **全新导航栏**：摒弃老旧的 `google_nav_bar`，替换为 Flutter 原生的 M3 `NavigationBar`，交互更加丝滑流畅。
- ✨ **动态色彩卡片**：重构了“功能页”与“我的页面”的卡片组件，全面采用 `ColorScheme` 系统级颜色映射（如 PrimaryContainer, TertiaryContainer 等），让应用色彩体系和谐且极具层次感。

## ✨ 主要功能

### 🎓 学习服务
- **📅 课表查询** - 查看个人课程安排，支持桌面小部件
- **📊 成绩查询** - 实时查询各学期成绩和学分
- **📝 考试安排** - 查看考试时间表和考场信息
- **🏫 空教室查询** - 快速查找可用教室，支持按教学楼筛选

### 🏠 生活服务
- **💧 宿舍喝水** - 一键购买宿舍饮用水
- **🚿 洗澡服务** - 便捷的洗澡卡充值和管理
- **⚡ 电费充值** - 宿舍电费查询和在线充值
- **💧 水费管理** - 宿舍水费查询和充值服务

### 📋 其他功能
- **📝 学生评教** - 参与课程评价和教学质量反馈
- **🔐 统一登录** - 支持HUT统一身份认证系统
- **🌙 深色模式** - 支持明暗主题切换
- **📱 桌面小部件** - 课表信息快速查看
- **🔔 智能提醒** - 电费预警、课程提醒等功能

## 🛠️ 技术栈

- **框架**: Flutter 3.7.0+
- **状态管理**: GetX
- **网络请求**: Dio
- **本地存储**: SharedPreferences
- **WebView**: flutter_inappwebview
- **UI组件**: Material Design 3
- **主题**: FlexColorScheme
- **图标**: Ionicons
- **二维码**: qr_code_scanner

## 📦 安装说明

### 环境要求
- Flutter SDK 3.7.0 或更高版本
- Dart SDK 3.7.0 或更高版本
- Android Studio / VS Code
- Android SDK (Android 5.0+)
- iOS SDK (iOS 11.0+) - 仅iOS开发需要

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/cc2562/superhut.git
cd superhut
```

2. **安装依赖**
```bash
flutter pub get
```

3. **运行项目**
```bash
# 调试模式
flutter run

# 发布模式
flutter run --release
```

### 构建发布版本

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

```

## 🚀 开发指南

### 添加新功能
1. 在 `lib/pages/` 下创建新的功能模块
2. 在 `lib/home/Functionpage/view.dart` 中添加功能入口
3. 更新路由配置和状态管理

### 代码规范
- 使用 GetX 进行状态管理
- 遵循 Flutter 官方代码规范
- 使用有意义的方法和变量命名
- 添加适当的注释和文档

## 🤝 贡献指南

我们欢迎所有形式的贡献！

1. Fork 本项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 开启 Pull Request

## 📄 许可证

本项目采用 GPL-3.0 license - 查看 [LICENSE](https://github.com/cc2562/superhut/blob/master/LICENSE) 文件了解详情

## ⚖️ 法律

- [用户协议](assets/UserAgreement.md)
- [隐私政策](assets/PrivacyAgreement.md)

## 🙏 致谢

- 感谢原作者 [@cc2562](https://github.com/cc2562) 的开源精神与构建的优秀基础架构。
- 感谢 **湖南工业大学校园系统工作团队** 为同学们提供如此便捷的第三方校园生活服务平台与工作支持。
- 感谢 **Flutter** 团队打造的极其卓越且富有表现力的跨平台开发框架。

## 📞 联系我们

- **项目主页**: [GitHub Repository](https://github.com/Coucou1818/superhut)
- **问题反馈**: [Issues](https://github.com/Coucou1818/superhut/issues)
- **邮箱**: syywqs@foxmail.com


---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给我们一个星标！**

Made with ❤️ for HUT Students
</div>
