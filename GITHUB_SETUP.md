# GitHub 推送和 CI/CD 设置指南

## 快速开始

### 步骤 1: 在 GitHub 创建仓库

1. 访问 https://github.com/new
2. 仓库名: `DrillDown3D`
3. 勾选 "Initialize this repository with a README"
4. 点击 "Create repository"

### 步骤 2: 推送代码

```bash
# 在项目目录执行
cd /path/to/DrillDown3D_Godot

# 添加远程仓库（如果还没添加）
git remote add origin https://github.com/YOUR_USERNAME/DrillDown3D.git

# 推送到 GitHub
git push -u origin main
```

### 步骤 3: 启用 GitHub Actions

1. 访问你的仓库: https://github.com/YOUR_USERNAME/DrillDown3D
2. 点击 "Actions" 标签
3. GitHub Actions 会自动检测 `.github/workflows/godot-ci.yml`
4. 第一次推送后会自动触发构建

---

## 自动化工作流

### 触发条件

| 事件 | 触发条件 |
|------|----------|
| **Lint** | 每次推送到 main/master |
| **Test** | 每次推送到 main/master |
| **Build Android** | 每次推送到 main/master（需要 lint 和 test 通过） |
| **Build Web** | 每次推送到 main/master（需要 lint 和 test 通过） |

### 工作流内容

```
.github/workflows/godot-ci.yml
├── lint          # GDScript 代码检查
├── test          # Python 逻辑测试
├── build-android # Android APK 构建
└── build-web     # Web 构建（可选）
```

---

## 设置 GitHub Token

如果需要推送私有仓库，需要设置 GitHub Token：

### 方法 1: 使用 HTTPS

```bash
git remote set-url origin https://YOUR_USERNAME:YOUR_TOKEN@github.com/YOUR_USERNAME/DrillDown3D.git
```

### 方法 2: 使用 SSH

```bash
# 生成 SSH 密钥（如果没有）
ssh-keygen -t ed25519 -C "your_email@example.com"

# 添加公钥到 GitHub
# 访问 https://github.com/settings/keys

# 设置远程仓库
git remote set-url origin git@github.com:YOUR_USERNAME/DrillDown3D.git
```

---

## 测试结果查看

### 方式 1: GitHub Web 界面

1. 访问仓库
2. 点击 "Actions" 标签
3. 查看运行历史和详情

### 方式 2: 命令行

```bash
# 查看最近的运行
gh run list

# 查看特定运行的日志
gh run watch <run_id>

# 下载构建产物
gh run download <run_id>
```

---

## 常见问题

### Q: 构建失败怎么办？

**A:** 检查以下几点：
1. Godot 版本是否匹配（项目需要 4.2+）
2. 代码是否有语法错误
3. 测试是否通过

### Q: 如何跳过某些步骤？

**A:** 修改 `.github/workflows/godot-ci.yml`，注释掉不需要的步骤。

### Q: 如何添加更多的构建目标？

**A:** 在 `godot-ci.yml` 中添加新的 job：

```yaml
build-windows:
  name: Build Windows
  runs-on: ubuntu-latest
  steps:
    # ... 类似 Android 的步骤
```

---

## GitHub Actions 配置详解

### 环境变量

```yaml
env:
  GODOT_VERSION: 4.2.1
  EXPORT_NAME: DrillDown3D
```

### 缓存

```yaml
- name: Cache Godot Editor
  uses: actions/cache@v4
  with:
    path: ~/godot
    key: ${{ runner.os }}-godot-${{ env.GODOT_VERSION }}
```

### 构建输出

```yaml
- name: Upload APK
  uses: actions/upload-artifact@v4
  with:
    name: apk
    path: Builds/*.apk
    retention-days: 30
```

---

## 后续步骤

1. ✅ 推送代码到 GitHub
2. ✅ 等待自动构建完成
3. ✅ 下载 APK 文件
4. ✅ 在 Android 设备上测试
5. ✅ 修复问题并重新推送

---

*文档版本: v1.0*
*更新时间: 2025-08-28*
