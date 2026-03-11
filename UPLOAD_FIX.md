# 📤 上传代码到GitHub - 详细图文步骤

## 方法1: 网页上传 (最简单)

### 进入仓库后

1. **确保你在仓库页面**
   - 地址栏应该显示: `https://github.com/你的用户名/nev-calculator`
   - 页面中间有大标题 "nev-calculator"

2. **找到 "Add file" 按钮**
   - 在页面**右上角**，绿色按钮 "<> Code" 的旁边
   - 写着 **"Add file"** 的下拉菜单
   - 点击它会展开两个选项：
     - 📝 Create new file
     - 📤 Upload files ← 点这个

   图示：
   ```
   [<> Code]  [Add file ▼]  [□ 绿点]
                ↓
         Create new file
         Upload files ← 点这个
   ```

3. **上传文件**
   - 点击 "Upload files" 后
   - 中间会出现一个**虚线框区域**
   - 写着 "Drag files here to add them to your repository"
   - 把解压后的文件夹里的**所有文件**拖进去
   - 或者点 "choose your files" 选择文件

4. **提交文件**
   - 页面往下滚动
   - 看到 "Commit changes" 按钮
   - 直接点这个绿色按钮

---

## 方法2: 拖拽上传 (更简单)

不用点 "Add file"，直接拖！

1. 打开你的仓库页面
2. 打开文件管理器，找到解压后的 `nev_investment_calculator` 文件夹
3. **选中文件夹里的所有文件** (Ctrl+A)
4. **直接拖到浏览器窗口里**
5. 自动跳转到上传页面
6. 点 "Commit changes"

---

## 方法3: 如果还是找不到

### 检查是不是在正确的页面
- ❌ 错误: 你在GitHub首页 `github.com`
- ✅ 正确: 你在仓库页面 `github.com/用户名/nev-calculator`

### 备用入口
如果在右上角找不到 "Add file"，试试：
1. 页面中间找 **"README.md"**
2. 点进去
3. 点右上角的 **铅笔图标** (编辑)
4. 然后点 **"Upload files"** 标签

---

## 方法4: 命令行上传 (适合技术背景)

如果网页实在找不到，用命令行：

```bash
# 1. 安装git (如果还没有)
# Windows: https://git-scm.com/download/win
# Mac: 自带或 brew install git

# 2. 打开命令行，进入项目文件夹
cd nev_investment_calculator

# 3. 初始化git
git init

# 4. 添加所有文件
git add .

# 5. 提交
git commit -m "Initial commit"

# 6. 连接远程仓库 (把下面的URL换成你的)
git remote add origin https://github.com/你的用户名/nev-calculator.git

# 7. 推送
git push -u origin main
```

---

## 常见问题

### Q: 页面上只有 "README.md"，没有上传按钮？
**A**: 点 "README.md" 进去，然后点右上角的 **铅笔图标** 编辑，再点 "Upload files" 标签。

### Q: 提示 "This file is empty"？
**A**: 文件没选上，重新拖一次。

### Q: 上传后页面没变？
**A**: 等几秒，GitHub在上传，看页面顶部有没有进度条。

### Q: 找不到 "Commit changes" 按钮？
**A**: 页面往下滚动，它在 "Optional extended description" 下面。

---

## 验证上传成功

上传成功后：
1. 页面会自动刷新
2. 看到你上传的所有文件列表
3. 文件数量应该在 10+ 个左右
4. 包含 `lib/` 文件夹、`pubspec.yaml` 等

---

## 还是不行？

告诉我：
1. 你现在看到的页面是什么样？（截图或描述）
2. 地址栏显示的URL是什么？
3. 页面中间显示什么内容？

我帮你定位问题！
