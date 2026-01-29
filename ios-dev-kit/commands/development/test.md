---
description: 运行相关测试
allowed-tools: mcp__xcodebuildmcp__*, Bash(xcodebuild *), Bash(swift test *)
---

# /ios:test - 运行测试

根据当前上下文运行测试。

## 执行流程

### Step 1: 检测项目类型

```bash
# 检测项目类型
if [ -f "Package.swift" ]; then
    PROJECT_TYPE="swift-package"
elif [ -f "*.xcodeproj" ] || [ -f "*.xcworkspace" ]; then
    PROJECT_TYPE="xcode"
fi
```

### Step 2: 运行测试

**Swift Package:**
```bash
swift test --enable-code-coverage
```

**Xcode项目:**
```swift
// 使用XcodeBuildMCP
mcp__xcodebuildmcp__test_sim_name_proj
```

或使用xcodebuild：
```bash
xcodebuild test \
    -workspace MyApp.xcworkspace \
    -scheme MyApp \
    -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Step 3: 报告结果

| 状态 | 输出 |
|------|------|
| 全部通过 | ✅ 所有测试通过 |
| 部分失败 | ❌ 有测试失败，显示详情 |
| 跳过 | ⚠️ 部分测试被跳过 |

## 输出示例

### 全部通过

```
🧪 运行测试

| 项目 | 值 |
|------|---|
| 测试套件 | MyAppTests |
| 运行测试 | 42 |
| 通过 | 42 |
| 失败 | 0 |
| 跳过 | 0 |

✅ 所有测试通过

Test Suite 'MyAppTests' passed
  42 tests passed
```

### 有失败

```
❌ 测试失败

| 测试 | 状态 |
|------|------|
| testLoginSuccess | ✅ 通过 |
| testLoginFailure | ✅ 通过 |
| testPasswordValidation | ❌ 失败 |

失败详情:
Test Case: testPasswordValidation
  File: Features/Auth/Tests/AuthViewModelTests.swift:45
  Error: #expect(Validator.isValid("short") == true) failed

修复建议:
- 检查密码验证逻辑
- 更新测试用例
- 验证边界条件
```

## 测试选项

```bash
# 运行所有测试
/ios:test

# 运行特定测试
/ios:test --test "testLoginSuccess"

# 生成覆盖率报告
/ios:test --coverage

# 仅单元测试（不运行UI测试）
/ios:test --unit

# 仅UI测试
/ios:test --ui
```

## 测试覆盖

```bash
# 生成覆盖率
swift test --enable-code-coverage

# 查看覆盖率报告
xcrun llvm-cov report
```

## Swift Testing框架

如果项目使用Swift Testing：

```bash
# 运行所有测试
swift test

# 运行特定suite
swift test --filter "AuthTests.*"

# 运行特定test
swift test --filter "testLoginSuccess"
```

## 最佳实践

1. **先运行快速测试**
   ```bash
   /ios:test --tags .fast
   ```

2. **运行特定模块测试**
   ```bash
   /ios:test --module "AuthTests"
   ```

3. **并行运行测试**
   - Swift Testing默认并行运行
   - 注意测试间的独立性

## 常见问题

### 1. 模拟器未启动

```bash
# 启动默认模拟器
xcrun simctl boot "iPhone 15"

# 然后运行测试
/ios:test
```

### 2. 测试超时

```bash
# 增加超时时间
swift test --timeout 120
```

### 3. 并发测试冲突

```swift
// 禁用并行测试
@Suite(.serialized)
struct ConflictTests { }
```
