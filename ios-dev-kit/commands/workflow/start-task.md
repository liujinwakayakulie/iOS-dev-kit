---
description: 开始新的iOS开发任务 - 创建本地Git分支和任务账本
argument-hint: <TASK-ID> <description>
allowed-tools: Bash(git *), Read, Write, Edit
---

# /ios:start - 开始新任务

自动创建本地Git分支和任务账本，初始化计划文件。

## 语法

```
/ios:start TASK-001 "实现用户登录功能"
/ios:start TASK-002 "修复图片加载崩溃" --plan
```

## 执行流程

### Step 1: 检查状态

```bash
git status --short
```

| 状态 | 处理 |
|------|------|
| 有未提交更改 | 询问: stash / commit / 取消 |
| 不在main/master | 询问: 是否切换到main/master |
| main/master落后 | 自动 `git pull` |

### Step 2: 解析参数

从描述推断类型：

| 关键词 | 类型 | 分支前缀 |
|--------|------|---------|
| 实现/新增/添加/add/implement | feature | `feature/` |
| 修复/解决/fix | fix | `fix/` |
| 重构/refactor | refactor | `refactor/` |
| 优化/性能/perf | perf | `perf/` |
| 测试/test | test | `test/` |
| 文档/docs | docs | `docs/` |
| 紧急/hotfix | hotfix | `hotfix/` |

### Step 3: 转换分支名

中文 → 英文，空格 → 连字符，小写：

```
"添加 Google 登录验证" → "add-google-login"
"修复图片浏览崩溃" → "fix-image-viewer-crash"
```

### Step 4: 创建分支

```bash
git checkout main
git pull origin main
git checkout -b <type>/TASK-<number>-<description>
```

### Step 5: 创建账本

自动生成 `docs/ledgers/TASK-XXX.md`：

```markdown
# TASK-XXX: [描述]

## Metadata
- **Created**: [当前日期]
- **Status**: In Progress
- **Branch**: [当前分支名]
- **Assignee**: [当前用户]

## Goal
[从描述提取的目标]

## Progress
- [ ] Phase 1: [待规划]
- [ ] Phase 2: [待规划]
- [ ] Phase 3: [待规划]

## Key Decisions
- [待补充]

## Open Questions
- [待补充]

## Commits
| Date | Message | Files |
|------|---------|-------|
```

### Step 6: 初始化计划文件

创建 `docs/plans/TASK-XXX.md`：

```markdown
# Implementation Plan: TASK-XXX

## Overview
[待规划]

## Architecture Decisions
[待规划]

## Implementation Status
[待规划]

## Next Steps
1. 使用 @feature-planner 创建任务分解
2. 或使用 @ios-architect 进行架构设计
```

### Step 7: 可选 - 创建计划

如果带 `--plan` 参数：
```
自动触发 @feature-planner
```

## 输出示例

```
✅ 任务已创建

| 项目 | 值 |
|------|---|
| 分支 | feature/TASK-001-add-google-login |
| 类型 | feature |
| 账本 | docs/ledgers/TASK-001.md |
| 计划 | docs/plans/TASK-001.md |

🎯 下一步:
1. 使用 @feature-planner 创建任务分解
2. 或使用 @ios-architect 进行架构设计
```

## 示例

```bash
# 创建新功能任务
/ios:start TASK-123 "实现用户个人资料编辑"

# 创建修复任务
/ios:start TASK-456 "修复启动时崩溃"

# 创建带计划的任务
/ios:start TASK-789 "添加推送通知" --plan
```
