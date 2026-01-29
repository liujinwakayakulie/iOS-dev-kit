---
description: 创建本地Git提交 - 自动格式化和推断scope
allowed-tools: Bash(git *), Bash(swiftformat *), Bash(swiftlint *)
---

# /ios:commit - 本地提交

自动创建本地Git提交（不推送到远程）。

## 执行流程

### Step 1: 代码格式化

检查并运行格式化工具：

```bash
# SwiftFormat（如果配置）
if command -v swiftformat &> /dev/null; then
    swiftformat --lint **/*.swift
    swiftformat **/*.swift
fi

# SwiftLint（如果配置）
if command -v swiftlint &> /dev/null; then
    swiftlint --fix **/*.swift
fi
```

### Step 2: 分析变更

```bash
git diff --cached --name-only
git diff --name-only
```

根据变更的文件路径推断scope：

| 目录 | Scope |
|------|-------|
| `Features/Auth/` | auth |
| `Features/Home/` | home |
| `Features/*/Views/` | ui |
| `Features/*/ViewModels/` | viewmodel |
| `Core/Networking/` | networking |
| `Core/Models/` | models |
| `Core/Services/` | services |

### Step 3: 生成提交消息

格式：

```
<iOS>(scope): subject

body

Co-authored-by: Claude Code <noreply@anthropic.com>
```

类型推断：

| 关键词 | 类型 |
|--------|------|
| 添加/新增/实现 | feat |
| 修复/解决 | fix |
| 重构 | refactor |
| 优化/性能 | perf |
| 文档 | docs |
| 测试 | test |
| 样式/格式 | style |
| 构建/CI | build |

### Step 4: 创建提交

```bash
git add
git commit -m "提交消息"
```

## 输出示例

```
📝 创建本地提交

| 项目 | 值 |
|------|---|
| 类型 | feat |
| Scope | auth |
| 文件数 | 3 |

提交消息:
---
feat(auth): 添加Google登录功能

- 实现Google Sign-In SDK集成
- 添加登录视图控制器
- 实现登录状态管理

Affected files:
- Features/Auth/GoogleLoginViewController.swift
- Features/Auth/AuthViewModel.swift
- Core/Services/GoogleAuthService.swift
---

✅ 提交已创建（本地）
💡 使用 /ios:push 推送到远程
```

## 使用示例

```bash
# 当前状态提交
/ios:commit

# 指定提交消息
/ios:commit 修复登录页面崩溃问题

# 自动格式化 + 提交
/ios:commit
```

## 注意事项

- 此命令只创建本地提交
- 不会自动推送到远程
- 使用 `git push` 或 `/ios:push` 推送到远程
