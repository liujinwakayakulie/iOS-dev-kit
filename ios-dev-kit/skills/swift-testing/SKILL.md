---
name: swift-testing
description: Swift Testing框架。使用@Test、#expect、#require编写测试、迁移XCTest、实现async测试、参数化测试时。
allowed-tools: Read, Write, Edit, Bash
---

# Swift Testing Framework

Swift Testing是Apple的现代测试框架，使用宏和结构化并发替代XCTest。核心原则：如果学了XCTest，请忘记它——Swift Testing工作方式不同。

## Overview

```swift
import Testing
@testable import YourApp

@Suite
struct FeatureTests {
    @Test("Feature performs correctly")
    func testFeature() {
        let result = performFeature()
        #expect(result == expected)
    }
}
```

## Core Concepts

### Assertions

| Macro | Use Case | Description |
|-------|----------|-------------|
| `#expect(expression)` | 大多数断言 | 软检查 - 失败继续 |
| `#require(expression)` | 前置条件 | 硬检查 - 失败停止 |

### 基本结构

```swift
import Testing
@testable import YourApp

@Suite
struct MyFeatureTests {
    let sut: MyFeature

    init() throws {
        // Setup before each test
        sut = MyFeature()
    }

    @Test("Example test description")
    func exampleBehavior() {
        // Arrange
        let input = "test"

        // Act
        let result = sut.process(input)

        // Assert
        #expect(result == "expected")
    }
}
```

## Test Types

### 基本测试

```swift
@Test("Addition works correctly")
func testAddition() {
    #expect(2 + 2 == 4)
}
```

### 异步测试

```swift
@Test("Async data fetch")
func testAsyncFetch() async throws {
    let data = try await fetchData()
    #expect(!data.isEmpty)
}
```

### Optional展开

```swift
@Test("Unwrap optional")
func testUnwrap() async throws {
    let user = try #require(await fetchUser())
    #expect(user.id == "123")
}
```

### 参数化测试

```swift
@Test("Validation works", arguments: [
    ("valid@email.com", true),
    ("invalid-email", false),
    ("", false)
])
func testValidation(email: String, expected: Bool) {
    #expect(Validator.isValid(email) == expected)
}
```

### 多参数测试（使用zip配对）

```swift
@Test("Pair processing", arguments: zip(
    ["a", "b", "c"],
    [1, 2, 3]
))
func testPairs(input: String, expected: Int) {
    #expect(process(input) == expected)
}
```

### 错误测试

```swift
@Test("Throws correct error")
func testThrows() {
    #expect(throws: NetworkError.self) {
        try riskyOperation()
    }
}

@Test("Throws specific error")
func testThrowsSpecific() {
    #expect(throws: NetworkError.timeout) {
        try fetch()
    }
}

@Test("Does not throw")
func testNoThrow() {
    #expect(throws: Never.self) {
        try safeOperation()
    }
}
```

## XCTest迁移

### 断言转换

| XCTest | Swift Testing |
|--------|---------------|
| `XCTAssertTrue(expr)` | `#expect(expr == true)` |
| `XCTAssertFalse(expr)` | `#expect(expr == false)` |
| `XCTAssertEqual(a, b)` | `#expect(a == b)` |
| `XCTAssertNotEqual(a, b)` | `#expect(a != b)` |
| `XCTAssertNil(a)` | `#expect(a == nil)` |
| `XCTAssertNotNil(a)` | `#expect(a != nil)` |
| `XCTAssertGreaterThan(a, b)` | `#expect(a > b)` |
| `XCTAssertThrowsError` | `#expect(throws: Error.self) { }` |
| `XCTAssertNoThrow` | `#expect(throws: Never.self) { }` |
| `try XCTUnwrap(a)` | `try #require(a)` |

### Setup/Teardown

```swift
// XCTest
override func setUp() { }
override func tearDown() { }

// Swift Testing (使用init/deinit或单独的测试)
@Suite
struct MyTests {
    var sut: SystemUnderTest

    init() {
        // Setup
        sut = SystemUnderTest()
    }

    deinit {
        // Teardown
        sut.cleanup()
    }
}
```

## 高级特性

### Tags

```swift
extension Tag {
    @Tag static var fast: Tag
    @Tag static var network: Tag
}

@Test(.tags(.fast, .network))
func testNetworkCall() { }
```

### 条件测试

```swift
@Test("iOS 18+ feature", .enabled(if: #available(iOS 18.0, *)))
func testNewFeature() { }

@Test("Debug only", .enabled(if: _isDebugAssertConfiguration()))
func testDebugBehavior() { }
```

### Confirmation（回调验证）

```swift
@Test("Callback invoked")
func testCallback() async {
    await confirmation("Callback received") { confirm in
        let object = TestObject { confirm() }
        object.triggerCallback()
    }
}
```

### 禁用序列化（测试线程不安全代码）

```swift
@Suite(.serialized)
struct LegacyTests {
    // Tests run sequentially, not in parallel
}
```

## 最佳实践

### 1. 状态隔离

```swift
@Suite
struct CounterTests {
    // 每个测试获得新实例
    let counter: Counter

    init() {
        counter = Counter()
    }

    @Test("Increment works")
    func testIncrement() {
        counter.increment()
        #expect(counter.value == 1)
    }
}
```

### 2. 可描述的测试名称

```swift
// ❌ 差
@Test("test1")
func test1() { }

// ✅ 好
@Test("User login fails with invalid credentials")
func testLoginFailsWithInvalidCredentials() { }
```

### 3. 测试行为，而非实现

```swift
// ❌ 测试实现细节
@Test("Counter calls increment method")

// ✅ 测试行为
@Test("Counter increases value when increment called")
```

### 4. 使用辅助函数

```swift
@Suite
struct HelperTests {
    func makeSUT() -> MyViewModel {
        MyViewModel(service: MockService())
    }

    @Test("View model initializes")
    func testInit() {
        let sut = makeSUT()
        #expect(sut.isLoaded == false)
    }
}
```

## Common Mistakes

1. **过度使用#require**
   - ❌ 对大多数断言使用 `#require`
   - ✅ 大多数使用 `#expect`，`#require` 仅用于前置条件

2. **笛卡尔积错误**
   - ❌ `@Test(arguments: [a, b], [c, d])` - 创建4种组合
   - ✅ `@Test(arguments: zip([a, b], [c, d]))` - 配对参数

3. **忽略状态隔离**
   - Swift Testing为每个测试创建新实例
   - 但静态变量和单例仍然会泄漏状态
   - 使用依赖注入清理单例

4. **并行测试冲突**
   - 默认并行运行测试
   - 共享文件/数据库/单例会冲突
   - 使用 `.serialized` 或隔离策略

5. **不自然使用async**
   - ❌ `Task { await asyncOperation() }`
   - ✅ 直接在测试签名使用：`@Test func testAsync() async throws { }`

6. **Confirmation误用**
   - `confirmation` 是验证回调被调用
   - 对断言使用是错误的
   - 断言用 `#expect`

## iOS测试特殊考虑

### @MainActor测试

```swift
@Suite
@MainActor
struct ViewModelTests {
    @Test("View model updates on main thread")
    func testUpdate() {
        let viewModel = MyViewModel()
        viewModel.update()
        #expect(viewModel.isUpdated == true)
    }
}
```

### UI测试（XCTest仍需）

```swift
import XCTest

final class MyUITests: XCTestCase {
    func testLoginFlow() {
        let app = XCUIApplication()
        app.launch()

        app.textFields["emailField"].tap()
        app.textFields["emailField"].typeText("test@example.com")

        app.buttons["loginButton"].tap()

        XCTAssertTrue(app.staticTexts["welcomeLabel"].exists)
    }
}
```

## 测试覆盖率目标

| 类型 | 目标覆盖率 |
|------|-----------|
| 关键业务逻辑 | 80%+ |
| 标准功能 | 60%+ |
| UI组件 | 关注行为，非渲染细节 |

## 输出格式示例

```swift
import Testing
@testable import MyApp

@Suite("UserAuthentication")
@MainActor
struct AuthenticationTests {

    @Test("Login succeeds with valid credentials", .tags(.network))
    func testSuccessfulLogin() async throws {
        // Given
        let viewModel = LoginViewModel(service: MockAPIService())
        let credentials = Credentials(email: "test@example.com", password: "password")

        // When
        try await viewModel.login(credentials)

        // Then
        #expect(viewModel.isLoggedIn == true)
        #expect(viewModel.currentUser?.email == "test@example.com")
    }

    @Test("Login fails with invalid credentials")
    func testFailedLogin() async throws {
        let viewModel = LoginViewModel(service: FailingMockAPIService())
        let credentials = Credentials(email: "invalid", password: "wrong")

        await confirmation("Error callback invoked") { confirm in
            viewModel.onError = { _ in confirm() }
            try? await viewModel.login(credentials)
        }
    }

    @Test("Password validation rejects short passwords", arguments: [
        ("", false),
        ("ab", false),
        ("abc", false),
        ("ValidPass123", true)
    ])
    func testPasswordValidation(password: String, expected: Bool) {
        #expect(Validator.isValidPassword(password) == expected)
    }
}
```

## Quick Reference

| 需要 | 代码 |
|------|------|
| 软断言 | `#expect(a == b)` |
| 硬断言 | `try #require(a)` |
| 异步测试 | `func test() async throws { }` |
| 参数化 | `@Test(arguments: [a, b, c])` |
| 错误测试 | `#expect(throws: Error.self) { }` |
| 回调验证 | `await confirmation("name") { confirm in }` |
| 条件运行 | `.enabled(if: condition)` |
