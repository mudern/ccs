# CCS — Claude Code Switch

One-command switching between AI model providers for Claude Code. Supports any Anthropic-compatible API (DeepSeek, GLM, LongCat, etc.).

## Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/mudern/ccs/v1.0.0/install.sh | bash
```

Restart your terminal (or `source ~/.zshrc`), then `ccs` is ready.

> **Platform**: Linux (requires bash). macOS support coming soon.

## What is CCS?

Claude Code supports switching backend API providers via environment variables, but manually changing them every time is painful. CCS manages these configurations:

- **`ccs use <name>`** — switch the system-wide default provider with one command
- **`ccs run <name>`** — launch Claude Code with a specific provider without touching global config
- **`ccs add <name> <key> <url> <model>`** — quickly add a new provider
- **`ccs models [name]`** — list models available from a provider
- **`ccs test`** — test connection to the current provider
- **`ccs doctor`** — diagnose config consistency

## Usage

```bash
# List all providers
ccs list

# Switch to DeepSeek & test
ccs use deepseek --test

# One-shot: run Claude with LongCat without changing defaults
ccs run longcat

# Add a new provider
ccs add myapi sk-xxx https://api.example.com/anthropic gpt-4o gpt-4o-mini

# Check available models
ccs models myapi
```

## Skill Auto-Configuration

CCS ships with a `.skill` file that enables intelligent configuration with Claude Code agents.

### How it works

The installer places the skill at `~/.claude/skills/ccs-config/SKILL.md`. Then, simply tell Claude Code:

```
Add a new provider called LongCat, key is ak_xxx, base URL is https://api.longcat.chat/anthropic
```

The agent will automatically: query available models → create the `.env` file → test the connection.

### For Codex users

Copy the `skills/ccs-config/SKILL.md` content into your Codex rules for the same behavior.

## Architecture

```
~/.config/ccs/
├── providers/              # Provider config files
│   ├── deepseek.env
│   ├── longcat.env
│   └── ...
└── current.env             # → symlink to the active provider
```

Each `.env` file defines an Anthropic-compatible API provider: key, base URL, and model-to-slot mappings.

## Supported Providers

Known Anthropic-compatible providers and their base URLs:

| Provider | Base URL | Models |
|----------|----------|--------|
| DeepSeek | `https://api.deepseek.com/anthropic` | `deepseek-v4-pro`, `deepseek-v4-flash` |
| Zhipu GLM | `https://open.bigmodel.cn/api/anthropic` | `glm-5.2`, `glm-5.1`, `glm-5`, `glm-4.7`, `glm-4.5-Air` |
| | `https://api.z.ai/api/anthropic` (international) | |
| Moonshot Kimi | `https://api.moonshot.cn/anthropic` | `kimi-k2-0711-preview`, `kimi-k2-turbo-preview`, `kimi-k2-0905` |
| | `https://api.moonshot.ai/anthropic` (international) | |
| MiniMax | `https://api.minimaxi.com/anthropic` | `MiniMax-M3`, `MiniMax-M2.7`, `MiniMax-M2.5`, `MiniMax-M2.1` |
| | `https://api.minimax.io/anthropic` (international) | |
| Qwen DashScope | `https://dashscope.aliyuncs.com/api/v2/apps/claude-code-proxy` | `qwen3-max`, `qwen3-plus`, `qwen3-turbo`, `qwen3-coder` |
| LongCat | `https://api.longcat.chat/anthropic` | `LongCat-2.0` |

## Install from Source

```bash
git clone https://github.com/mudern/ccs.git
cd ccs
bash install.sh
```

## License

MIT

---

[中文文档](README_zh.md)
