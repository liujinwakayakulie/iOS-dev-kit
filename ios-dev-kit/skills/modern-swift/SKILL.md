---
name: modern-swift
description: Swift 6现代特性。使用async/await、actors、Sendable、strict concurrency、类型系统特性时。
allowed-tools: Read, Write, Edit
---

# Modern Swift (Swift 6+)

Swift 6引入了编译时并发检查，通过async/await、actors和Sendable约束在编译时防止数据竞争，而非运行时。

## Overview

现代Swift用编译器确保的安全并发模式替代旧有的并发模式：
- `async/await` 替代 completion handlers
- `actor` 替代锁和串行队列
- `Sendable` 约束确保线程安全

## Reference Loading Guide

| Reference | Load When |
|-----------|-----------|
| [Concurrency](references/concurrency.md) | async/await, Task, TaskGroup |
| [Actors](references/actors.md) | 使用actor保护共享状态 |
| [Sendable](references/sendable.md) | 跨并发边界传递数据 |
| [Strict Concurrency](references/strict.md) | 启用严格并发检查 |
| [Type System](references/types.md) | 使用高级类型特性 |
| [Macros](references/macros.md) | 使用 @Observable 等宏 |

## Quick Reference

| Need | Use | NOT |
|------|-----|-----|
| 异步操作 | `async/await` | completion handler |
| 主线程 | `@MainActor` | `DispatchQueue.main` |
| 共享可变状态 | `actor` | lock/serial queue |
| 并行任务 | `TaskGroup` | `DispatchGroup` |
| 线程安全 | `Sendable` | `@unchecked` everywhere |
| 结构化并发 | `Task` | `DispatchQueue.global` |

## Async/Await

### 定义异步函数

```swift
// 定义异步函数
func fetchUser(id: String) async throws -> User {
    let url = URL(string: "https://api.example.com/users/\(id)")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(User.self, from: data)
}

// 调用异步函数
func loadUser() async {
    do {
        let user = try await fetchUser(id: "123")
        print("User: \(user.name)")
    } catch {
        print("Error: \(error)")
    }
}
```

### Task创建

```swift
// 从同步上下文启动异步任务
Task {
    await loadUser()
}

// Task with priority
Task(priority: .userInitiated) {
    await performExpensiveOperation()
}

// Detached task (不继承上下文)
Task.detached {
    await independentOperation()
}
```

### MainActor

```swift
// 标记类为主线程执行
@MainActor
class MyViewModel: ObservableObject {
    @Published var data: String = ""

    func loadData() async {
        // 即使在异步上下文，UI更新也在主线程
        data = try await fetchDataFromAPI()
    }
}

// 特定代码在主线程
await MainActor.run {
    self.updateUI()
}
```

## Actors

### 定义Actor

```swift
actor UserManager {
    private var users: [String: User] = [:]

    func addUser(_ user: User) {
        users[user.id] = user
    }

    func getUser(id: String) -> User? {
        return users[id]
    }

    func removeAll() {
        users.removeAll()
    }
}

// 使用actor
let manager = UserManager()

// 跨actor边界需要await
await manager.addUser(user)
let user = await manager.getUser(id: "123")
```

### Actor Reentrancy

```swift
actor Counter {
    private var value = 0

    func increment() {
        // await inside actor may temporarily release lock
        let oldValue = value
        someAsyncFunction().await // state may change here!
        value = oldValue + 1 // ⚠️ 可能不是预期结果
    }
}
```

## Sendable

### Sendable协议

```swift
// 结构体默认是Sendable（如果存储属性都是Sendable）
struct User: Sendable, Codable {
    let id: String
    let name: String
}

// Class必须显式遵循Sendable
final class UserCache: @unchecked Sendable {
    // 如果内部状态正确同步，使用@unchecked
    private var cache: [String: User] = [:]
    private let lock = NSLock()

    func get(_ id: String) -> User? {
        lock.lock()
        defer { lock.unlock() }
        return cache[id]
    }
}

// Actor自动是Sendable
actor DataStore {
    var data: [String: Int] = [:]
}
```

### Sendable闭包

```swift
// 闭包在并发上下文中捕获变量需要Sendable
Task {
    // name是String，是Sendable
    let name = "test"

    // 闭包捕获Sendable变量
    process(name) { result in
        print(result) // result也必须是Sendable
    }
}
```

## TaskGroup

### 并行任务

```swift
func fetchMultipleUsers(ids: [String]) async throws -> [User] {
    try await withThrowingTaskGroup(of: User.self) { group in
        for id in ids {
            group.addTask {
                try await fetchUser(id: id)
            }
        }

        var results: [User] = []
        for try await user in group {
            results.append(user)
        }
        return results
    }
}
```

### 收集结果

```swift
await withTaskGroup(of: (Int, Error).self) { group in
    group.addTask {
        (try await operation1(), nil)
    }
    group.addTask {
        (try await operation2(), nil)
    }

    var results: [Int] = []
    for await (result, error) in group {
        if let error = error {
            // Handle error
        } else {
            results.append(result)
        }
    }
}
```

## Cancellation

### 检查取消

```swift
func processLargeData() async throws {
    for item in items {
        // 定期检查取消
        try Task.checkCancellation()

        await process(item)
    }
}
```

### 结构化取消

```swift
let task = Task {
    await longRunningOperation()
}

// 取消任务
task.cancel()

// 等待任务完成或被取消
await task.value
```

## Common Mistakes

1. **@unchecked Sendable滥用**
   - ❌ 用 `@unchecked Sendable` 快速修复编译错误
   - ✅ 修复底层的线程安全问题

2. **Missing @await**
   - ❌ `let data = fetchUser()`
   - ✅ `let data = await fetchUser()`

3. **在闭包中强捕获self**
   - ❌ `Task { self.process() }`
   - ✅ `Task { [weak self] in await self?.process() }`

4. **不检查Task取消**
   - 长运行操作不检查 `Task.isCancelled`
   - ✅ 定期调用 `try Task.checkCancellation()`

5. **忘记@MainActor**
   - UI代码不标记 `@MainActor`
   - ✅ ViewModels和ViewControllers使用 `@MainActor`

## Swift 6 Migration

### Completion Handler → Async

```swift
// Old
func fetchData(completion: @escaping (Result<Data, Error>) -> Void)

// New
func fetchData() async throws -> Data
```

### DispatchQueue → Actor

```swift
// Old
class DataStore {
    private let queue = DispatchQueue(label: "com.app.store")
    private var data: [String: Int] = [:]

    func get(_ key: String) -> Int? {
        queue.sync { data[key] }
    }
}

// New
actor DataStore {
    private var data: [String: Int] = [:]

    func get(_ key: String) -> Int? {
        data[key]
    }
}
```

## Best Practices

1. **优先使用async/await**
   - 更清晰的错误处理
   - 更易读的代码

2. **使用actor保护共享状态**
   - 编译器保证安全
   - 避免手动锁管理

3. **标记UI相关类为@MainActor**
   ```swift
   @MainActor
   class MyViewModel: ObservableObject { }
   ```

4. **结构化并发**
   - 使用TaskGroup而非手动管理Task
   - 自动传播错误和取消

5. **正确使用Sendable**
   - 值类型自动Sendable
   - 类需要线程安全实现

## Quick Examples

```swift
// 1. 简单异步调用
let data = try await fetchData()

// 2. 并行调用
async let user = fetchUser()
async let posts = fetchPosts()
let (user, posts) = await (user, posts)

// 3. 主线程更新
@MainActor func updateUI(data: String) {
    label.text = data
}

// 4. Actor使用
let counter = Counter()
await counter.increment()

// 5. TaskGroup并行
try await withThrowingTaskGroup(of: Image.self) { group in
    for url in urls {
        group.addTask {
            try await fetchImage(url: url)
        }
    }
}
```
