# 📱 APK构建指南 - 使用GitHub Actions (最简单)

## 概述
本指南教你用 GitHub Actions 免费自动构建 APK，无需安装任何开发环境。

**总耗时**: 约 5 分钟  
**难度**: ⭐ (非常简单)

---

## 步骤一：注册GitHub账号

1. 打开 https://github.com
2. 点击右上角 **"Sign up"**
3. 输入邮箱 → 设置密码 → 创建账号
4. 验证邮箱（查收邮件点链接）

✅ **完成后**: 你有了GitHub账号

---

## 步骤二：创建代码仓库

1. 登录GitHub后，点击右上角 **+** → **New repository**

2. 填写信息：
   - **Repository name**: `nev-calculator` (随便取名)
   - **Description**: 新能源投资收益计算器
   - 选择 **Public** (公开)
   - 勾选 **Add a README file**

3. 点击 **Create repository**

✅ **完成后**: 你有了一个代码仓库

---

## 步骤三：上传代码文件

### 方法A: 网页上传 (推荐，最简单)

1. 在仓库页面，点击 **"Add file"** → **"Upload files"**

2. 把解压后的项目文件夹里的所有文件拖进去：
   ```
   nev_investment_calculator/
   ├── lib/
   ├── test/
   ├── .github/workflows/
   ├── pubspec.yaml
   └── ...
   ```

3. 等上传完成后，点 **"Commit changes"**

### 方法B: 上传压缩包

1. 把 `nev_investment_calculator.tar.gz` 解压
2. 进解压后的文件夹，选中所有文件
3. 拖进GitHub网页上传区域

✅ **完成后**: 代码在GitHub上了

---

## 步骤四：自动构建APK

**神奇的事情发生了！**

上传代码后，GitHub会自动开始构建APK，大约需要 **3-5分钟**。

### 查看构建进度

1. 在你的仓库页面，点击 **"Actions"** 标签
2. 看到 **"Build Android APK"** 正在运行（黄色圆圈）
3. 等待变成绿色对勾 ✅

---

## 步骤五：下载APK

构建完成后，有两种方式获取APK：

### 方式1: 下载Artifacts (推荐)

1. 点击 **Actions** → 点击最新的成功构建
2. 页面下方看到 **Artifacts** 区域
3. 点击 **release-apk** 下载
4. 解压下载的zip文件，里面的 `app-release.apk` 就是安装包

### 方式2: 下载Release版本

1. 点击仓库页面的 **Releases** (右侧)
2. 看到最新的Release版本
3. 下载里面的APK文件

---

## 步骤六：安装到手机

1. 把APK传到手机（微信/QQ/数据线）
2. 在手机上点击APK文件
3. 允许"安装未知应用"权限
4. 完成安装！

---

## 常见问题

### Q: 构建失败了怎么办？
A: 点击Actions，查看失败原因。通常是文件没传全，重新上传即可。

### Q: 构建需要多久？
A: 通常3-5分钟，GitHub服务器免费额度。

### Q: 可以构建多次吗？
A: 可以，每次上传新代码都会自动构建。

### Q: APK安装不了？
A: 安卓设置 → 安全 → 允许安装未知来源应用。

---

## 视频教程参考

如果文字看不懂，可以在B站搜索：  
**"GitHub Actions自动构建APK教程"**

---

## 快速检查清单

- [ ] 注册GitHub账号
- [ ] 创建仓库
- [ ] 上传代码文件
- [ ] 等待Actions构建完成
- [ ] 下载Artifacts中的APK
- [ ] 安装到手机测试

---

## 技术支持

如果按照步骤操作有问题：
1. 截图报错页面
2. 描述操作到哪一步
3. 反馈给开发团队

**祝使用愉快！** 🎉
