#!/bin/bash

# iOS Dev Kit - Session Start Hook
# 在每个Claude Code会话开始时运行

set -euo pipefail

# 获取项目信息
PROJECT_NAME=$(basename "$(pwd)")
SWIFT_VERSION=$(swift --version 2>&1 | grep -oE '[0-9]+\.[0-9]+' | head -1)
XCODE_VERSION=$(xcodebuild -version 2>&1 | head -1)

echo ""
echo "📱 iOS Dev Kit Session Started"
echo "================================"
echo "🔧 Swift $SWIFT_VERSION | $XCODE_VERSION"
echo "📂 Project: $PROJECT_NAME"
echo ""

# 检测项目类型
if ls *.xcodeproj 2>/dev/null | grep -q .; then
    echo "✅ Xcode Project detected"
    PROJECT_TYPE="xcode"
elif ls *.xcworkspace 2>/dev/null | grep -q .; then
    echo "✅ Xcode Workspace detected"
    PROJECT_TYPE="workspace"
elif [ -f "Package.swift" ]; then
    echo "✅ Swift Package detected"
    PROJECT_TYPE="spm"
else
    echo "⚠️  No iOS project detected"
    PROJECT_TYPE="unknown"
fi

# 检查工具
echo ""
echo "🔧 Tools:"

if command -v swiftlint &> /dev/null; then
    SWIFTLINT_VERSION=$(swiftlint version 2>/dev/null || echo "unknown")
    echo "  ✅ SwiftLint $SWIFTLINT_VERSION"
else
    echo "  ⚠️  SwiftLint not installed"
fi

if command -v swiftformat &> /dev/null; then
    echo "  ✅ swift-format available"
else
    echo "  ⚠️  swift-format not installed"
fi

if command -v xcodebuild &> /dev/null; then
    echo "  ✅ xcodebuild available"
fi

# 检查当前分支
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null || echo "HEAD")
    echo ""
    echo "🌿 Current branch: $BRANCH"

    # 检查是否有未提交的更改
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "  ⚠️  You have uncommitted changes"
    fi
fi

# 检查模拟器
echo ""
SIMULATOR_STATUS=$(xcrun simctl list devices booted 2>/dev/null | grep -c "Booted" || echo "0")
if [ "$SIMULATOR_STATUS" -gt 0 ]; then
    echo "📱 $SIMULATOR_STATUS simulator(s) running"
else
    echo "💡 No simulators running. Use /ios:run to boot one."
fi

echo ""
echo "================================"
echo "💡 Quick commands:"
echo "  /ios:start TASK-XXX \"description\"  - Start new task"
echo "  /ios:build                           - Build project"
echo "  /ios:test                            - Run tests"
echo "  /ios:commit                          - Create local commit"
echo ""
