# iOS Dev Kit Plugin

**Version:** 1.0.0
**Platform:** iOS 17+, Swift 6.0
**UI Framework:** UIKit (Primary) + SwiftUI (Secondary)

iOS Dev Kit 是一个完整的iOS开发工具包，提供专业化Agent、全面的知识技能、本地Git工作流和XcodeBuildMCP集成。

## 特性

| 特性 | 说明 |
|------|------|
| **10个专业化Agent** | 规划、UIKit工程、SwiftUI工程、网络、数据层 |
| **16个知识技能** | UIKit、SwiftUI、Modern Swift、Testing、Diagnostics等 |
| **本地Git工作流** | 本地分支和提交，无远程推送 |
| **XcodeBuildMCP集成** | 通过MCP构建和测试 |
| **PRD驱动开发** | PRD → Spec → Tasks 工作流 |
| **模型分层** | Opus规划 / Inherit实现 / Haiku工具 |

## 安装

```bash
# 添加本地marketplace
/plugins add-marketplace local --directory /path/to/ios-dev-kit

# 安装插件
/plugins add ios-dev-kit@local

# 验证安装
/ios:start
```

## 快速开始

```bash
# 1. 开始新任务
/ios:start TASK-001 "实现用户登录功能"

# 2. 创建任务分解
@feature-planner

# 3. 架构设计
@ios-architect

# 4. 实现代码
@uikit-engineer

# 5. 构建和测试
/ios:build
/ios:test

# 6. 本地提交
/ios:commit
```

## 目录结构

```
ios-dev-kit/
├── .claude-plugin/           # 插件配置
│   ├── plugin.json
│   └── marketplace.json
├── agents/                   # 10个Agent
│   ├── planning/             # 规划层 (Opus, 只读)
│   │   ├── ios-architect.md
│   │   ├── uikit-specialist.md
│   │   └── feature-planner.md
│   ├── implementation/       # 实现层 (Inherit)
│   │   └── uikit-engineer.md
│   └── utilities/            # 工具层 (Haiku)
│       └── ios-searcher.md
├── skills/                   # 16个知识技能
│   ├── uikit-core/
│   ├── swiftui-patterns/
│   ├── modern-swift/
│   ├── swift-testing/
│   └── ... (more skills)
├── commands/                 # 命令
│   ├── workflow/             # 工作流命令
│   ├── planning/             # 规划命令
│   ├── development/          # 开发命令
│   └── utilities/            # 工具命令
├── hooks/                    # Hooks
│   ├── hooks.json
│   ├── session-start.sh
│   └── post-swift-edit.sh
├── templates/                # 文件模板
│   ├── plan-template.md
│   └── uikit/
├── docs/                     # 文档
│   └── WORKFLOW.md
└── CLAUDE.md                 # 插件说明
```

## 核心命令

### 工作流命令

| 命令 | 说明 |
|------|------|
| `/ios:start` | 开始新任务 (创建分支+账本) |
| `/ios:commit` | 创建本地提交 |
| `/ios:status` | 显示任务状态 |

### 开发命令

| 命令 | 说明 |
|------|------|
| `/ios:build` | 构建项目 |
| `/ios:test` | 运行测试 |
| `/ios:run` | 构建并运行 |
| `/ios:fix-build` | 修复构建错误 |

## 核心Agent

### 规划Agent (Opus, 只读)

- `@ios-architect` - iOS架构设计
- `@uikit-specialist` - UIKit专家
- `@feature-planner` - 功能规划

### 实现Agent (Inherit)

- `@uikit-engineer` - UIKit实现
- `@swiftui-engineer` - SwiftUI实现
- `@networking-engineer` - 网络层
- `@data-layer-engineer` - 数据持久化

### 工具Agent (Haiku)

- `@ios-searcher` - Swift代码搜索

## 知识技能

### 核心技能

| 技能 | 说明 |
|------|------|
| **uikit-core** | UIKit核心开发 |
| **swiftui-patterns** | SwiftUI 17+模式 (@Observable) |
| **modern-swift** | Swift 6现代特性 |
| **swift-testing** | Swift Testing框架 |
| **swift-diagnostics** | 系统化调试 |

### 更多技能

- swift-style, ios-architecture, ios-networking
- ios-persistence, concurrency, ios-hig
- localization, haptics, grdb, accessibility
- foundation-models

## 工作流

```
/ios:start TASK-XXX → 创建分支+账本
    ↓
@feature-planner → 创建任务分解
    ↓
@ios-architect → 架构设计（只读）
    ↓
@uikit-engineer → 实现
    ↓
/ios:build + /ios:test → 验证
    ↓
/ios:commit → 本地提交
```

## 设计原则

1. **UIKit优先** - 主要支持UIKit，SwiftUI作为辅助
2. **本地开发** - 专注本地工作流，无远程操作
3. **Reference架构** - 渐进式技能加载
4. **模型分层** - Opus规划/Inherit实现/Haiku工具
5. **只读规划** - 规划Agent不能修改代码

## Hooks

- **SessionStart**: 显示项目信息、工具状态
- **PostToolUse**: Swift文件编辑后运行SwiftLint

## 文档

- [WORKFLOW.md](docs/WORKFLOW.md) - 完整工作流指南
- [CLAUDE.md](CLAUDE.md) - 插件说明

## 许可证

MIT License

## 致谢

- [Claude Code](https://claude.ai/code) - AI编码助手
- [dev-flow](https://github.com/lazyman-ian/dev-flow) - 工作流设计参考
- [claude-swift-engineering](https://github.com/johnrogers/claude-swift-engineering) - Swift技能参考
