#!/bin/bash

# iOS Dev Kit - Post Swift Edit Hook
# 在编辑Swift文件后运行代码检查

set -euo pipefail

# 从stdin读取工具输入
FILE=$(jq -r '.tool_input.file_path // empty' < /dev/stdin)

# 只处理Swift文件
if [[ "$FILE" != *.swift ]]; then
    exit 0
fi

echo ""
echo "📝 Swift file edited: $FILE"
echo ""

# SwiftLint检查（如果可用）
if command -v swiftlint &> /dev/null; then
    if [ -f ".swiftlint.yml" ] || [ -f ".swiftlint.yaml" ]; then
        echo "🔍 Running SwiftLint..."
        if LINT_OUTPUT=$(swiftlint lint --path "$FILE" 2>&1); then
            echo "  ✅ No issues"
        else
            echo "  ⚠️  Issues found:"
            echo "$LINT_OUTPUT" | head -10 | sed 's/^/    /'
        fi
    fi
fi

# swift-format检查（如果可用）
if command -v swiftformat &> /dev/null; then
    echo ""
    echo "🔍 Checking format..."
    if FORMAT_OUTPUT=$(swiftformat lint --configuration .swiftformat --quiet "$FILE" 2>&1); then
        echo "  ✅ Formatted correctly"
    else
        echo "  ⚠️  Formatting issues:"
        echo "$FORMAT_OUTPUT" | head -5 | sed 's/^/    /'
        echo "  💡 Run 'swiftformat \"\$FILE\"' to fix"
    fi
fi

echo ""
