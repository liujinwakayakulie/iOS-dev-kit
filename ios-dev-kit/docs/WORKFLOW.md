# iOS Dev Kit - Workflow Guide

## Overview

iOS Dev Kit 提供完整的iOS开发工作流：规划 → 实现 → 本地提交。

## Quick Start Workflow

```
1. /ios:start TASK-XXX "描述"
2. @feature-planner → 创建任务分解
3. @ios-architect → 架构设计
4. @uikit-engineer → 实现
5. /ios:build + /ios:test → 验证
6. /ios:commit → 本地提交
```

## Detailed Workflow

### Phase 1: Task Setup

```bash
# 开始新任务
/ios:start TASK-123 "实现用户登录功能"
```

**执行内容:**
1. 检查工作区状态
2. 创建本地分支: `feature/TASK-123-user-login`
3. 创建任务账本: `docs/ledgers/TASK-123.md`
4. 初始化计划文件: `docs/plans/TASK-123.md`

### Phase 2: Planning

```bash
# 创建功能规格和任务分解
@feature-planner
```

**执行内容:**
1. 读取PRD（如果存在）
2. 创建功能规格: `docs/specs/user-login.md`
3. 创建任务列表: `docs/tasks/user-login-tasks.md`
4. 更新计划文件

### Phase 3: Architecture Design

```bash
# 架构设计
@ios-architect
```

**执行内容:**
1. 分析需求
2. 决定UIKit vs SwiftUI
3. 设计模块结构
4. 更新计划文件中的架构部分

### Phase 4: Implementation

```bash
# 实现
@uikit-engineer
```

**执行内容:**
1. 读取任务文件
2. 实现代码
3. 更新任务状态
4. 更新计划文件

### Phase 5: Verification

```bash
# 构建
/ios:build

# 测试
/ios:test
```

### Phase 6: Commit

```bash
# 本地提交
/ios:commit
```

**执行内容:**
1. 运行代码格式化
2. 分析变更推断scope
3. 生成提交消息
4. 创建本地提交

## File Organization

```
docs/
├── ledgers/
│   └── TASK-XXX.md          # 任务状态追踪
├── specs/
│   └── [feature].md         # 功能规格
├── tasks/
│   └── [feature]-tasks.md   # 任务分解
└── plans/
    └── TASK-XXX.md          # 实施计划
```

## Command Reference

### Workflow Commands

| Command | Description |
|---------|-------------|
| `/ios:start` | 开始新任务 |
| `/ios:commit` | 创建本地提交 |
| `/ios:status` | 显示任务状态 |

### Planning Commands

| Command | Description |
|---------|-------------|
| `/ios:plan` | 创建实施计划 |
| `/ios:create-prd` | 创建PRD |
| `/ios:create-spec` | 创建功能规格 |

### Development Commands

| Command | Description |
|---------|-------------|
| `/ios:build` | 构建项目 |
| `/ios:test` | 运行测试 |
| `/ios:run` | 构建并运行 |
| `/ios:fix-build` | 修复构建错误 |

### Utility Commands

| Command | Description |
|---------|-------------|
| `/ios:search` | 搜索代码 |
| `/ios:review` | 代码审查 |
| `/ios:docs` | 生成API文档 |

## Agent Coordination

### Planning Agents (Opus, Read-Only)

```
@feature-planner
    ↓ 输出: docs/specs/xxx.md, docs/tasks/xxx-tasks.md
@ios-architect
    ↓ 输出: docs/plans/xxx.md (Architecture section)
```

### Implementation Agents (Inherit)

```
@uikit-engineer
    ↓ 更新: docs/plans/xxx.md (Implementation Status)
@networking-engineer
    ↓ 更新: docs/plans/xxx.md
```

### Utility Agents (Haiku)

```
@ios-searcher
    ↓ 返回: 文件位置和行号
```

## Best Practices

### 1. Planning First

- 使用 `@feature-planner` 创建详细任务分解
- 使用 `@ios-architect` 进行架构设计
- 阅读现有代码了解模式

### 2. Incremental Development

- 一次实现一个任务
- 每次更改后测试
- 频繁提交

### 3. Test as You Go

- 先写测试（TDD）
- 运行 `/ios:test` 验证
- 修复失败后再继续

### 4. Clean Code

- Hook自动运行SwiftLint
- 修复所有警告
- 遵循Swift 6严格并发

## Example Session

```bash
# 1. 开始任务
/ios:start TASK-001 "实现用户登录"

# 2. 规划
@feature-planner
# → 创建 docs/specs/login.md
# → 创建 docs/tasks/login-tasks.md

# 3. 架构设计
@ios-architect
# → 更新 docs/plans/TASK-001.md

# 4. 实现第一个任务
@uikit-engineer
# → 实现 LoginViewController
# → 更新任务状态

# 5. 验证
/ios:build
/ios:test

# 6. 提交
/ios:commit

# 7. 继续下一个任务...
```

## Troubleshooting

### 构建失败

```bash
# 清理并重建
rm -rf ~/Library/Developer/Xcode/DerivedData
/ios:build --clean
```

### 测试失败

```bash
# 运行特定测试
/ios:test --test "testLoginSuccess"

# 查看详细输出
swift test --verbose
```

### 状态检查

```bash
# 查看任务状态
cat docs/ledgers/TASK-XXX.md

# 查看Git状态
git status

# 查看当前分支
git branch --show-current
```

## Tips

1. **使用Tab补全** - 命令和文件名支持Tab补全
2. **查看历史** - `git log --oneline` 查看提交历史
3. **切换任务** - 使用 `/ios:switch TASK-YYY` 切换到其他任务
4. **搜索代码** - 使用 `@ios-searcher` 快速定位代码
