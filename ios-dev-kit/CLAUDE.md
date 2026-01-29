# iOS Dev Kit Plugin

**Version**: 1.0.0
**Target**: iOS 17+, Swift 6.0
**UI Framework**: UIKit (Primary) + SwiftUI (Secondary)

## Quick Start

```bash
# Install plugin
/plugins add ios-dev-kit

# Start a new task
/ios:start TASK-001 "Implement user login feature"

# Build project
/ios:build

# Run tests
/ios:test

# Create local commit
/ios:commit
```

## Core Features

| Feature | Description |
|---------|-------------|
| **10 Specialized Agents** | Planning, UIKit engineering, SwiftUI engineering, networking, data layer |
| **16 Knowledge Skills** | UIKit, SwiftUI, Modern Swift, Testing, Diagnostics, Style, HIG, etc. |
| **Local Git Workflow** | Local branches and commits, no remote push |
| **XcodeBuildMCP Integration** | Build and test via MCP |
| **PRD-Driven Development** | PRD → Spec → Tasks workflow |

## Workflow

```
/ios:start TASK-XXX → Create branch + ledger
    ↓
@feature-planner → Create task breakdown
    ↓
@ios-architect → Architecture design (read-only)
    ↓
@uikit-engineer → Implement
    ↓
/ios:build + /ios:test → Verify
    ↓
/ios:commit → Local commit
```

## Available Agents

### Planning Agents (Opus, Read-Only)
- `@ios-architect` - iOS architecture design
- `@uikit-specialist` - UIKit expert
- `@feature-planner` - Feature planning

### Implementation Agents (Inherit)
- `@uikit-engineer` - UIKit implementation
- `@swiftui-engineer` - SwiftUI implementation
- `@networking-engineer` - Networking layer
- `@data-layer-engineer` - Data persistence

### Utility Agents (Haiku)
- `@ios-searcher` - Swift code search
- `@api-documenter` - API documentation

## Available Skills

| Skill | Description |
|-------|-------------|
| uikit-core | UIKit core development |
| swiftui-patterns | SwiftUI 17+ patterns (@Observable) |
| modern-swift | Swift 6 modern features |
| swift-testing | Swift Testing framework |
| swift-diagnostics | Systematic debugging |
| swift-style | Swift code style guide |
| ios-architecture | iOS architecture patterns |
| ios-networking | Network.framework |
| ios-persistence | Data persistence |
| concurrency | Concurrency programming |
| ios-hig | iOS HIG compliance |
| localization | i18n and l10n |
| haptics | Haptic feedback |
| grdb | GRDB database |
| accessibility | Accessibility support |
| foundation-models | Foundation framework |

## Commands

### Workflow Commands
- `/ios:start` - Start new task (create branch + ledger)
- `/ios:commit` - Create local commit
- `/ios:status` - Show task status

### Planning Commands
- `/ios:plan` - Create implementation plan
- `/ios:create-prd` - Create PRD
- `/ios:create-spec` - Create feature spec

### Development Commands
- `/ios:build` - Build project
- `/ios:test` - Run tests
- `/ios:run` - Build and run app
- `/ios:fix-build` - Fix build errors

### Utility Commands
- `/ios:search` - Search Swift code
- `/ios:review` - Code review
- `/ios:docs` - Generate API docs

## Architecture

```
ios-dev-kit/
├── agents/           # 10 specialized agents
├── skills/           # 16 knowledge skills (Reference Architecture)
├── commands/         # 15+ commands
├── hooks/            # Session and edit hooks
├── templates/        # File templates
└── mcp-server/       # Optional MCP server (8 tools)
```

## Principles

1. **UIKit First** - Primary support for UIKit with SwiftUI as secondary
2. **Local Development** - Focus on local workflow, no remote operations
3. **Reference Architecture** - Progressive skill loading
4. **Model Stratification** - Opus for planning, Inherit for implementation, Haiku for utilities
5. **Read-Only Planning** - Planning agents cannot modify code

## Documentation

- [ARCHITECTURE.md](docs/ARCHITECTURE.md) - Complete architecture documentation
- [WORKFLOW.md](docs/WORKFLOW.md) - Workflow guide
- [AGENT_HANDOFF.md](docs/AGENT_HANDOFF.md) - Agent coordination patterns
