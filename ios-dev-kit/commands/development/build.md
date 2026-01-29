---
description: 智能构建iOS项目
allowed-tools: mcp__xcodebuildmcp__*, Bash(xcodebuild *), Read
---

# /ios:build - 构建项目

检测项目类型并使用XcodeBuildMCP构建。

## 执行流程

### Step 1: 检测项目类型

```bash
# 检查.xcworkspace或.xcodeproj
if [ -f "*.xcworkspace" ]; then
    PROJECT_TYPE="workspace"
elif [ -f "*.xcodeproj" ]; then
    PROJECT_TYPE="project"
else
    echo "❌ 未找到Xcode项目"
    return 1
fi
```

### Step 2: 列出可用schemes

```bash
# 使用XcodeBuildMCP
mcp__xcodebuildmcp__list_schemes
```

### Step 3: 构建项目

```swift
// 使用XcodeBuildMCP构建
mcp__xcodebuildmcp__build_sim_name_proj
```

或者使用xcodebuild：

```bash
xcodebuild -workspace MyApp.xcworkspace \
           -scheme MyApp \
           -configuration Debug \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 15' \
           clean build
```

### Step 4: 报告结果

| 状态 | 输出 |
|------|------|
| 成功 | ✅ 构建成功 |
| 警告 | ⚠️ 构建成功但有警告 |
| 失败 | ❌ 构建失败，显示错误 |

## 输出示例

### 成功

```
🔨 构建项目

| 项目 | 值 |
|------|---|
| Workspace | MyApp.xcworkspace |
| Scheme | MyApp |
| Configuration | Debug |
| 目标 | iPhone 15 (iOS 17.0) |

✅ 构建成功

Build Succeeded
  0 warning(s)
  0 error(s)
```

### 失败

```
❌ 构建失败

错误: 不可解析的符号
  File: Features/Auth/LoginViewController.swift:45
  Code: Use of unresolved identifier 'undefinedMethod'

修复建议:
- 检查方法名拼写
- 确认方法在作用域内可用
- 检查import语句
```

## 构建选项

```bash
# 默认构建
/ios:build

# 清理后构建
/ios:build --clean

# Release构建
/ios:build --release

# 指定scheme
/ios:build --scheme MyApp
```

## 常见问题

### 1. DerivedData问题

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
/ios:build
```

### 2. Scheme问题

```bash
# 列出可用schemes
xcodebuild -workspace MyApp.xcworkspace -list

# 指定scheme
/ios:build --scheme MyScheme
```

### 3. 证书问题

```bash
# 检查证书
security find-identity -v -p codesigning

# 或跳过代码签名（仅用于模拟器）
CODE_SIGN_IDENTITY="" xcodebuild ...
```
