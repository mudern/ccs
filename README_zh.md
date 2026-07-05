# CCS — Claude Code Switch

一键切换 Claude Code 的 AI 模型供应商。支持所有兼容 Anthropic API 的服务（DeepSeek、GLM、LongCat 等）。

## 快速安装

```bash
curl -fsSL https://raw.githubusercontent.com/mudern/ccs/v1.0.0/install.sh | bash
```

重启终端（或 `source ~/.zshrc`），即可使用 `ccs` 命令。

> **平台**: Linux（需 bash）。macOS 支持即将推出。

## 这是什么？

Claude Code 支持通过环境变量切换后端 API 供应商，但每次手动改很麻烦。CCS 把这些配置管理起来：

- **`ccs use <name>`** — 一键切换全局默认供应商
- **`ccs run <name>`** — 临时用某供应商启动 Claude Code，不改全局配置
- **`ccs add <name> <key> <url> <model>`** — 快速添加新 API
- **`ccs models [name]`** — 查询供应商支持的模型列表
- **`ccs test`** — 测试当前供应商连接
- **`ccs doctor`** — 诊断配置一致性

## 使用方式

```bash
# 查看所有供应商
ccs list

# 切换到 DeepSeek 并测试
ccs use deepseek --test

# 临时用 LongCat 启动一次 Claude
ccs run longcat

# 添加新供应商
ccs add myapi sk-xxx https://api.example.com/anthropic gpt-4o gpt-4o-mini

# 查询可用模型
ccs models myapi
```

## Skill 一键配置

CCS 自带 `.skill` 文件，在 Claude Code 中提供智能配置引导。

### 用法

安装脚本会自动将 skill 安装到 `~/.claude/skills/ccs-config/SKILL.md`。然后在 Claude Code 中直接说：

```
帮我添加一个叫 LongCat 的 API，key 是 ak_xxx，base URL 是 https://api.longcat.chat/anthropic
```

Agent 会自动：查询可用模型 → 创建 `.env` 配置文件 → 测试连接。

### 对 Codex 用户

将 `skills/ccs-config/SKILL.md` 文件内容放入 Codex 的 rules 中即可。

## 架构

```
~/.config/ccs/
├── providers/              # 供应商配置文件
│   ├── deepseek.env
│   ├── longcat.env
│   └── ...
└── current.env             # → 软链接指向当前激活的供应商
```

每个 `.env` 文件定义了一个 Anthropic 兼容 API 供应商：key、base URL、各槽位模型映射。

## 支持的供应商（内置示例）

| 供应商 | Base URL |
|--------|----------|
| DeepSeek | `https://api.deepseek.com/anthropic` |
| 智谱 GLM | `https://open.bigmodel.cn/api/anthropic` |
| LongCat | `https://api.longcat.chat/anthropic` |
| Moonshot (Kimi) | — |
| MiniMax | — |

## 从源码安装

```bash
git clone https://github.com/mudern/ccs.git
cd ccs
bash install.sh
```

## License

MIT

---

[English](README.md)
