#!/usr/bin/env bash
set -euo pipefail

# ============================================
# CCS (Claude Code Switch) — 一键安装脚本
# ============================================

CCS_DIR="${HOME}/.config/ccs"
PROVIDERS_DIR="${CCS_DIR}/providers"
BIN_DIR="${HOME}/.local/bin"
SKILL_DIR="${HOME}/.claude/skills"
REPO_URL="https://raw.githubusercontent.com/mudern/ccs/main"

echo "=== CCS 安装 ==="
echo ""

# 1. 创建目录
mkdir -p "$PROVIDERS_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$SKILL_DIR"

# 2. 下载 ccs 脚本
echo "→ 下载 ccs 脚本..."
curl -fsSL "$REPO_URL/ccs" -o "$BIN_DIR/ccs"
chmod +x "$BIN_DIR/ccs"
echo "  ✓ ccs → $BIN_DIR/ccs"

# 3. 安装 skill（用于 Claude Code / Codex 智能配置）
echo "→ 安装 ccs-config skill..."
curl -fsSL "$REPO_URL/.skill" -o "$SKILL_DIR/ccs-config.skill"
echo "  ✓ skill → $SKILL_DIR/ccs-config.skill"

# 4. 检查 PATH 是否包含 ~/.local/bin
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo ""
    echo "⚠ 请将以下内容添加到你的 shell 配置文件 (~/.bashrc / ~/.zshrc):"
    echo ""
    echo '  export PATH="$HOME/.local/bin:$PATH"'
    echo ""
fi

# 5. 检查是否已有 CCS 集成
if [ -f "${HOME}/.zshrc" ]; then
    if grep -q "ccs/current.env" "${HOME}/.zshrc" 2>/dev/null; then
        echo "  ✓ .zshrc 已有 CCS 集成"
    else
        echo ""
        echo "⚠ 建议在 ~/.zshrc 末尾添加以下内容以自动加载 CCS 配置:"
        echo ""
        echo '  # === CCS (Claude Code Switch) ==='
        echo '  if [[ -f "$HOME/.config/ccs/current.env" ]]; then'
        echo '      set -a'
        echo '      source "$HOME/.config/ccs/current.env"'
        echo '      set +a'
        echo '  fi'
        echo ""
        echo '  ccs() {'
        echo '      local cmd="$1"'
        echo '      shift'
        echo '      '"$BIN_DIR"'/ccs "$cmd" "$@"'
        echo '      if [[ "$cmd" == "use" ]]; then'
        echo '          set -a'
        echo '          source "$HOME/.config/ccs/current.env"'
        echo '          set +a'
        echo '      fi'
        echo '  }'
        echo ""
    fi
fi

echo ""
echo "=== 安装完成 ==="
echo ""
echo "使用方法:"
echo "  ccs list               列出所有供应商"
echo "  ccs use <name> --test  切换供应商并测试连接"
echo "  ccs run <name>         临时用某供应商启动 Claude Code"
echo "  ccs add <name> <key> <url> <model>  添加新供应商"
echo ""
echo "Skill 一键配置（在 Claude Code 中）:"
echo "  '帮我添加一个叫 xxx 的 API, key 是 sk-xxx, base URL 是 https://...'"
echo ""
