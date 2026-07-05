#!/usr/bin/env bash
set -euo pipefail

# ============================================
# CCS (Claude Code Switch) — One-line installer
# ============================================
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/mudern/ccs/v1.0.0/install.sh | bash

VERSION="${CCS_VERSION:-1.0.0}"
CCS_DIR="${HOME}/.config/ccs"
PROVIDERS_DIR="${CCS_DIR}/providers"
BIN_DIR="${HOME}/.local/bin"
SKILL_DIR="${HOME}/.claude/skills"
REPO_URL="https://raw.githubusercontent.com/mudern/ccs/v${VERSION}"

echo ""
echo "  ╔════════════════════════════════════╗"
echo "  ║   CCS v${VERSION} — Claude Code Switch   ║"
echo "  ╚════════════════════════════════════╝"
echo ""

# 1. Create directories
mkdir -p "$PROVIDERS_DIR"
mkdir -p "$BIN_DIR"
mkdir -p "$SKILL_DIR"

# 2. Download ccs script
echo "→ Downloading ccs..."
curl -fsSL "$REPO_URL/ccs" -o "$BIN_DIR/ccs"
chmod +x "$BIN_DIR/ccs"
echo "  ✓ ccs → $BIN_DIR/ccs"

# 3. Install skill (for Claude Code / Codex auto-configuration)
echo "→ Installing ccs-config skill..."
curl -fsSL "$REPO_URL/.skill" -o "$SKILL_DIR/ccs-config.skill"
echo "  ✓ skill → $SKILL_DIR/ccs-config.skill"

# 4. Check PATH
if ! echo "$PATH" | grep -q "$BIN_DIR"; then
    echo ""
    echo "  ⚠ Add this to your shell config (~/.bashrc / ~/.zshrc):"
    echo ""
    echo '    export PATH="$HOME/.local/bin:$PATH"'
    echo ""
fi

# 5. Check CCS integration
if [ -f "${HOME}/.zshrc" ]; then
    if grep -q "ccs/current.env" "${HOME}/.zshrc" 2>/dev/null; then
        echo "  ✓ .zshrc already has CCS integration"
    else
        echo ""
        echo "  ⚠ Add the following to ~/.zshrc for automatic CCS loading:"
        echo ""
        echo '    # === CCS (Claude Code Switch) ==='
        echo '    if [[ -f "$HOME/.config/ccs/current.env" ]]; then'
        echo '        set -a'
        echo '        source "$HOME/.config/ccs/current.env"'
        echo '        set +a'
        echo '    fi'
        echo ""
        echo '    ccs() {'
        echo '        local cmd="$1"'
        echo '        shift'
        echo '        '"$BIN_DIR"'/ccs "$cmd" "$@"'
        echo '        if [[ "$cmd" == "use" ]]; then'
        echo '            set -a'
        echo '            source "$HOME/.config/ccs/current.env"'
        echo '            set +a'
        echo '        fi'
        echo '    }'
        echo ""
    fi
elif [ -f "${HOME}/.bashrc" ]; then
    if grep -q "ccs/current.env" "${HOME}/.bashrc" 2>/dev/null; then
        echo "  ✓ .bashrc already has CCS integration"
    else
        echo ""
        echo "  ⚠ Add the following to ~/.bashrc for automatic CCS loading:"
        echo ""
        echo '    # === CCS (Claude Code Switch) ==='
        echo '    if [[ -f "$HOME/.config/ccs/current.env" ]]; then'
        echo '        set -a'
        echo '        source "$HOME/.config/ccs/current.env"'
        echo '        set +a'
        echo '    fi'
        echo ""
        echo '    ccs() {'
        echo '        '"$BIN_DIR"'/ccs "$@";'
        echo '        if [[ "$1" == "use" ]]; then'
        echo '            set -a'
        echo '            source "$HOME/.config/ccs/current.env"'
        echo '            set +a'
        echo '        fi'
        echo '    }'
        echo ""
    fi
fi

echo ""
echo "  ╔════════════════════════════════════╗"
echo "  ║      Installation complete!        ║"
echo "  ╚════════════════════════════════════╝"
echo ""
echo "  Quick start:"
echo "    ccs list              List all providers"
echo "    ccs use <name> --test Switch provider & test connection"
echo "    ccs run <name>        One-shot run with a provider"
echo "    ccs add <name> <key> <url> <model>  Add new provider"
echo ""
echo "  Skill auto-config (in Claude Code):"
echo "    'Add a new provider called xxx, key is sk-xxx, base URL is https://...'"
echo ""
