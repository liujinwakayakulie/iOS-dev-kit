---
name: uikit-core
description: UIKit核心开发知识。使用时实现UIViewController、UIView、Auto Layout、UIKit动画、事件处理等UIKit功能。
allowed-tools: Read, Write, Edit, Grep, Glob
---

# UIKit Core

UIKit是iOS的核心UI框架，提供声明式和程序式界面构建能力。

## Reference Loading Guide

**ALWAYS load reference files if there is even a small chance the content may be required.**

| Reference | Load When |
|-----------|-----------|
| [View Controllers](references/view-controllers.md) | 创建/配置UIViewController、生命周期管理、父子关系 |
| [Views](references/views.md) | 创建自定义UIView、draw(_:)、intrinsicContentSize |
| [Auto Layout](references/auto-layout.md) | 使用约束布局、NSLayoutConstraint、layout anchors |
| [Table/Collection Views](references/collections.md) | 使用UITableView/UICollectionView、delegate/datasource |
| [Delegation Patterns](references/delegation.md) | 实现delegate模式、weak/unowned |
| [UIKit Animations](references/animations.md) | 实现UIView动画、transition、Core Animation |
| [Event Handling](references/events.md) | 处理触摸/手势事件、responder chain |

## Core Concepts

### UIViewController Lifecycle

```swift
class MyViewController: UIViewController {

    override func loadView() {
        // Custom view loading (rarely needed)
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Called once when view hierarchy loaded
        // Setup UI, configure initial state
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Called before view appears
        // Update UI, start animations
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Called when view fully visible
        // Start network requests, timers
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Called before view disappears
        // Save state, cleanup
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Called when view fully hidden
        // Stop network requests, timers
    }

    deinit {
        // Cleanup notifications, observers
    }
}
```

### Auto Layout with Anchors (iOS 9+)

```swift
// Preferred: Modern anchor API
view.translatesAutoresizingMaskIntoConstraints = false

NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 16),
    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -16),
    view.heightAnchor.constraint(equalToConstant: 44)
])
```

### Custom UIView Pattern

```swift
final class CustomView: UIView {

    // MARK: - Subviews

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    // MARK: - Setup

    private func setupView() {
        addSubview(titleLabel)
        backgroundColor = .systemBackground
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Configuration

    func configure(with title: String) {
        titleLabel.text = title
    }
}
```

### UITableView Pattern

```swift
class MyViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()

    private var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension MyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

extension MyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle selection
    }
}
```

### UIKit Animation

```swift
// Simple property animation
UIView.animate(withDuration: 0.3) {
    view.alpha = 1.0
    view.frame = newFrame
}

// Spring animation
UIView.animate(withDuration: 0.5,
               delay: 0,
               usingSpringWithDamping: 0.7,
               initialSpringVelocity: 0.5,
               options: .curveEaseInOut)
{
    view.transform = .identity
}

// Transition
UIView.transition(from: oldView,
                to: newView,
                duration: 0.3,
                options: .transitionCrossDissolve)
```

### Delegate Pattern (Weak Reference)

```swift
protocol MyViewControllerDelegate: AnyObject {
    func myViewController(_ controller: MyViewController, didCompleteWith result: Result)
}

class MyViewController: UIViewController {
    weak var delegate: MyViewControllerDelegate?

    private func notifyCompletion() {
        delegate?.myViewController(self, didCompleteWith: .success)
    }
}
```

## Common Mistakes

1. **在错误线程操作UI**
   - ❌ `DispatchQueue.global.async { self.view.backgroundColor = .red }`
   - ✅ `DispatchQueue.main.async { self.view.backgroundColor = .red }`
   - ✅ 使用 `@MainActor` 标记类

2. **Memory Leaks - Delegate使用strong引用**
   - ❌ `var delegate: MyViewControllerDelegate?`
   - ✅ `weak var delegate: MyViewControllerDelegate?`

3. **约束冲突**
   - 使用优先级解决冲突：`.priority = .defaultHigh`
   - 避免硬编码约束值
   - 使用 `intrinsicContentSize` 和 `contentHugging`

4. **UITableView性能问题**
   - 复用cell：`dequeueReusableCell(withIdentifier:for:)`
   - 避免复杂的cell配置
   - 使用 `estimatedRowHeight` 优化滚动

5. **忘记调用super**
   ```swift
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated) // ✅ 必须
       // custom code
   }
   ```

## Best Practices

1. **使用 `translatesAutoresizingMaskIntoConstraints = false`**
   ```swift
   view.translatesAutoresizingMaskIntoConstraints = false
   ```

2. **Lazy初始化子视图**
   ```swift
   private let label: UILabel = {
       let label = UILabel()
       label.translatesAutoresizingMaskIntoConstraints = false
       return label
   }()
   ```

3. **Extension组织代码**
   ```swift
   // MARK: - UITableViewDataSource
   extension MyViewController: UITableViewDataSource { }

   // MARK: - UITableViewDelegate
   extension MyViewController: UITableViewDelegate { }
   ```

4. **考虑iPad布局**
   - 使用trait collection变化
   - 自适应布局
   - 考虑split view

5. **无障碍支持**
   ```swift
   button.accessibilityLabel = "Add item"
   button.accessibilityHint = "Adds a new item to the list"
   button.isAccessibilityElement = true
   ```

## Swift 6 Concurrency

```swift
@MainActor
class MyViewController: UIViewController {

    private var task: Task<Void, Never>?

    func loadData() async {
        task?.cancel()
        task = Task {
            do {
                let data = try await networkService.fetch()
                await MainActor.run {
                    self.updateUI(with: data)
                }
            } catch {
                await MainActor.run {
                    self.showError(error)
                }
            }
        }
    }

    deinit {
        task?.cancel()
    }
}
```

## Quick Reference

| Need | Code |
|------|------|
| Create VC | `class MyVC: UIViewController` |
| Add subview | `view.addSubview(subview)` |
| Constraints | `NSLayoutConstraint.activate([...])` |
| Update UI | `DispatchQueue.main.async { }` or `@MainActor` |
| Animation | `UIView.animate(withDuration: 0.3) { }` |
| Delegate | `weak var delegate: SomeDelegate?` |
| Notification | `NotificationCenter.default.addObserver(...)` |
