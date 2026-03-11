# 📱💻 一键获取APK和EXE

## 自动构建双平台安装包

你上传代码后，GitHub会自动帮你构建：
- ✅ Android APK（手机用）
- ✅ Windows EXE（电脑用）

---

## 步骤

### 1. 上传代码到GitHub
（按之前的步骤操作：注册 → 创建仓库 → 上传文件）

### 2. 等待构建完成
- 点 **Actions** 标签
- 看到两个任务在运行：
  - `Build Android APK`
  - `Build Windows EXE`
- 等3-5分钟都变绿色 ✅

### 3. 下载安装包

构建完成后，点 **Releases** 标签，看到：

| 文件 | 用途 | 下载后 |
|------|------|--------|
| `nev-calculator-android.apk` | 安卓手机安装包 | 传到手机安装 |
| `nev-calculator-windows.zip` | Windows电脑安装包 | 解压后运行exe |

---

## Windows EXE 使用说明

1. 下载 `nev-calculator-windows.zip`
2. 解压到任意文件夹
3. 双击里面的 `nev_calculator.exe` 运行
4. 不需要安装，直接用！

---

## 手机APK 使用说明

1. 下载 `nev-calculator-android.apk`
2. 传到手机
3. 点击安装
4. 允许"未知来源"权限

---

**一次上传，同时拿到两个平台的安装包！**
