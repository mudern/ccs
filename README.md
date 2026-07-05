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

The installer places the skill at `~/.claude/skills/ccs-config.skill`. Then, simply tell Claude Code:

```
Add a new provider called LongCat, key is ak_xxx, base URL is https://api.longcat.chat/anthropic
```

The agent will automatically: query available models → create the `.env` file → test the connection.

### For Codex users

Copy the `.skill` file content into your Codex rules for the same behavior.

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

## Supported Providers (built-in examples)

| Provider | Base URL |
|----------|----------|
| DeepSeek | `https://api.deepseek.com/anthropic` |
| GLM (Zhipu) | `https://open.bigmodel.cn/api/anthropic` |
| LongCat | `https://api.longcat.chat/anthropic` |
| Moonshot (Kimi) | — |
| MiniMax | — |

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
