# 新能源投资收益计算器 - 构建指南

## 方式一: Docker构建 (最简单，推荐)

### 前置条件
- 安装 Docker Desktop

### 构建步骤

```bash
# 1. 下载项目到本地
cd nev_investment_calculator

# 2. 运行构建脚本 (macOS/Linux)
./build_apk.sh

# 或手动执行:
docker build -t nev-calculator .
docker create --name temp nev-calculator
docker cp temp:/app/build/app/outputs/flutter-apk/app-release.apk ./
docker rm temp
```

**输出**: `nev_investment_calculator.apk`

---

## 方式二: 本地Flutter构建

### 前置条件

#### macOS
```bash
# 1. 安装 Flutter
brew install flutter

# 2. 安装 Android Studio
# 下载: https://developer.android.com/studio

# 3. 配置Android SDK
flutter config --android-sdk=/path/to/android-sdk

# 4. 同意协议
flutter doctor --android-licenses
```

#### Windows
1. 下载 Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. 解压到 `C:\flutter`
3. 添加环境变量: `C:\flutter\bin`
4. 安装 Android Studio
5. 配置 Android SDK

#### Linux
```bash
# 1. 下载 Flutter
cd ~/development
curl -o flutter_linux_3.24.0-stable.tar.xz \
  https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
tar xf flutter_linux_3.24.0-stable.tar.xz

# 2. 添加PATH
echo 'export PATH="$HOME/development/flutter/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 3. 安装Android Studio
# 下载: https://developer.android.com/studio
```

### 验证安装
```bash
flutter doctor
```

应该显示所有对勾 ✅

### 构建APK
```bash
cd nev_investment_calculator

# 获取依赖
flutter pub get

# 运行测试
flutter test

# 构建Release APK
flutter build apk --release

# 输出位置
# build/app/outputs/flutter-apk/app-release.apk
```

### 构建Windows EXE
```bash
flutter build windows --release

# 输出位置
# build/windows/x64/runner/Release/
```

---

## 方式三: 使用GitHub Actions自动构建

项目根目录创建 `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.0'
    
    - run: flutter pub get
    - run: flutter test
    - run: flutter build apk --release
    
    - name: Upload APK
      uses: actions/upload-artifact@v3
      with:
        name: release-apk
        path: build/app/outputs/flutter-apk/app-release.apk
```

推送代码到GitHub后，自动构建APK。

---

## 安装测试

### Android手机安装
1. 将APK传输到手机
2. 文件管理器点击安装
3. 允许"未知来源"安装
4. 打开应用测试

### 可能的问题

**问题1: 解析包错误**
- 原因: APK下载不完整
- 解决: 重新传输文件

**问题2: 安装被阻止**
- 解决: 设置 → 安全 → 允许未知来源

**问题3: Flutter doctor显示X**
- 运行: `flutter doctor -v` 查看详情
- 根据提示安装缺失组件

---

## 快速测试清单

- [ ] 省份选择是否正常
- [ ] 参数输入是否保存
- [ ] 点击"计算收益"是否有结果
- [ ] IRR/NPV数值是否合理
- [ ] 敏感性分析图表是否显示
- [ ] 现金流明细是否完整

---

## 技术参数

| 项目 | 值 |
|------|-----|
| Flutter版本 | 3.24.0 |
| Dart版本 | 3.4.0 |
| 最小Android版本 | API 21 (Android 5.0) |
| 目标Android版本 | API 34 (Android 14) |
| 包名 | com.example.nev_investment_calculator |

---

## 发布到应用商店 (可选)

### 华为应用市场
1. 注册华为开发者账号
2. 创建应用，上传APK
3. 填写应用信息
4. 提交审核

### 其他应用商店
- 小米应用商店
- OPPO/vivo应用商店
- 应用宝

需要准备:
- 应用图标 (512x512 PNG)
- 应用截图 (1080x1920)
- 隐私政策链接
- 应用简介

---

## 联系与支持

项目问题反馈:
1. 检查README.md
2. 查看PROJECT_DELIVERY.md
3. 检查agents_config.yaml
