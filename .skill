---
name: ccs-config
description: This skill should be used when the user wants to configure, add, or switch between Claude Code AI model providers (CCS). Trigger when the user mentions "ccs", "切换模型", "添加 provider", "配置 API", "add model", "switch provider", "claude code switch", or provides an API key for a new AI provider.
---

# CCS Provider Configuration

CCS (Claude Code Switch) is a tool for managing multiple AI model providers for Claude Code. It lives at `~/Code/source/ccs/ccs` and is symlinked to `~/.local/bin/ccs`.

## Architecture

```
~/.config/ccs/
├── providers/         # Provider env files (one per provider)
│   ├── deepseek.env
│   ├── glm.env
│   ├── kimi.env
│   └── longcat.env
└── current.env -> providers/deepseek.env   # Symlink to active provider
```

Each `.env` file contains:

```bash
ANTHROPIC_AUTH_TOKEN='<api_key>'
ANTHROPIC_BASE_URL='<anthropic_compatible_base_url>'
ANTHROPIC_MODEL='<primary_model>'
ANTHROPIC_DEFAULT_HAIKU_MODEL='<cheap_fast_model>'
ANTHROPIC_DEFAULT_OPUS_MODEL='<best_model>'
ANTHROPIC_DEFAULT_SONNET_MODEL='<default_model>'
CLAUDE_CODE_SUBAGENT_MODEL='<cheap_fast_model>'
CLAUDE_CODE_EFFORT_LEVEL='max'
API_TIMEOUT_MS='3000000'
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC='1'
CLAUDE_CODE_PROVIDER='<name>'
```

## Key env vars explained

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_BASE_URL` | Base URL for Anthropic-compatible API (without `/v1/messages`) |
| `ANTHROPIC_MODEL` | Default model for claude sessions |
| `ANTHROPIC_DEFAULT_HAIKU_MODEL` | Fast/cheap model for lightweight tasks |
| `ANTHROPIC_DEFAULT_OPUS_MODEL` | Best quality model |
| `ANTHROPIC_DEFAULT_SONNET_MODEL` | Balanced model |
| `CLAUDE_CODE_SUBAGENT_MODEL` | Model used by sub-agents |

## Adding a new provider

### Step 1: Discover available models

**Primary approach — search the provider's documentation:**

Use WebSearch or WebFetch to find the provider's official API documentation. Look for:
- A "Models" or "Available Models" page
- Model ID strings (e.g. `gpt-4o`, `deepseek-chat`, `LongCat-2.0`)
- Which models are Anthropic-compatible

Example search: `"<provider name> API models documentation anthropic compatible"`

**Fallback — query `/v1/models` (NOT all providers support this):**

Only try this if you know the provider supports it (e.g. LongCat, OpenAI-compatible proxies). Many providers do NOT expose this endpoint.

```bash
curl -s "<BASE_URL>/v1/models" \
  -H "Authorization: Bearer <API_KEY>" \
  -H "x-api-key: <API_KEY>" \
  -H "anthropic-version: 2023-06-01" | python3 -m json.tool
```

### Step 2: Create provider env file

Use `ccs add` command OR manually create the file:

```bash
ccs add <name> <api_key> <base_url> <primary_model> [haiku_model]
```

Example:
```bash
ccs add myprovider sk-xxx https://api.example.com/anthropic gpt-4o gpt-4o-mini
```

### Step 3: Test the connection

```bash
ccs use <name> --test
```

Or test without switching:
```bash
ccs run <name>
```

## Provider-specific notes

### Known provider base URLs

| Provider | Base URL |
|----------|----------|
| DeepSeek | `https://api.deepseek.com/anthropic` |
| GLM (智谱) | `https://open.bigmodel.cn/api/anthropic` |
| LongCat | `https://api.longcat.chat/anthropic` |

The env files for existing providers are located at `~/.config/ccs/providers/`. Always read an existing env file for reference when creating a new one.

## ccs commands quick reference

```bash
ccs list          # List all providers
ccs current       # Show active provider
ccs use <name>    # Switch to a provider (updates current.env + settings.json)
ccs run <name>    # One-shot: use provider without changing global config
ccs test          # Test connection to current provider
ccs add ...       # Add a new provider
ccs models [name] # List models supported by a provider
ccs doctor        # Diagnose config consistency between current.env and settings.json
```

## Configuration workflow

When the user provides a new API key and wants to add a provider:

1. **Always ask for the base URL** if not provided. Do NOT guess.
2. **Discover available models** — search the provider's official API docs (WebSearch/WebFetch). Do NOT blindly query `/v1/models` — most providers don't support it.
3. **Map the models**: the most capable model → OPUS/SONNET slots, the cheapest/fastest → HAIKU/SUBAGENT slots
4. **Create the .env file** at `~/.config/ccs/providers/<name>.env` with the correct model names
5. **Test the connection** with `ccs use <name> --test`
6. **Report back** which provider was added and what models it uses
