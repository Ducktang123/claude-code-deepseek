<div align="center">

# 🐤 Claude Code + DeepSeek — Dead-Simple One-Click Installer

**Run [Claude Code](https://github.com/anthropics/claude-code), the best AI coding CLI, on the fast and affordable DeepSeek models.**

Direct connection in China · No VPN needed · Double-click to install · 12 built-in Chinese skills

[中文](README.md) ｜ **English**

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)](#-supported-platforms)
[![Mirror](https://img.shields.io/badge/mirrors-npmmirror%20%2F%20Tsinghua-orange)](#)
[![Model](https://img.shields.io/badge/model-DeepSeek%20V4%20(1M%20context)-7C3AED)](https://platform.deepseek.com)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](#-contributing)

If this project helps you, drop a ⭐ **Star** — it keeps the project visible and easy to find later 🙏

</div>

---

## 📖 What is this

[Claude Code](https://github.com/anthropics/claude-code) is Anthropic's official command-line AI coding assistant — it reads your code, fixes bugs, writes tests and handles documents right in your terminal. By default it requires an Anthropic account and network access, which is **expensive and inconvenient in mainland China**.

This installer does one simple thing:

> **Point Claude Code at DeepSeek, route everything through China-based mirrors, and set it all up with a single double-click.**

- ✅ **No VPN**: Node.js, Claude Code and Python deps all come from China mirrors (npmmirror / Tsinghua).
- ✅ **Zero config**: Installs the runtime and writes the env vars for you — you just paste a DeepSeek API key.
- ✅ **Cheap & powerful**: DeepSeek pricing with the Claude Code experience. Defaults to the latest **DeepSeek V4** (`v4-pro` / `v4-flash`) with a **1M-token context** and thinking / non-thinking modes.
- ✅ **Chinese-friendly**: 12 ready-to-use Chinese skills — just describe what you want in plain language.
- ✅ **Cross-platform**: Windows and macOS (Intel / Apple Silicon).

---

## 🎬 Demo

**One-click install (fully automated):**

![Install demo](assets/demo-install.svg)

**Use Chinese skills directly inside `claude`:**

![Skill demo](assets/demo-skill.svg)

---

## 🚀 Get started in 3 steps

### 1. Get a DeepSeek API key
Sign up at [platform.deepseek.com](https://platform.deepseek.com) → create an API key (looks like `sk-xxxx`) → add a little credit (DeepSeek has no free tier, but it's cheap).

### 2. Download this installer
Click **Code → Download ZIP** at the top right, or grab the per-platform archive from [Releases](../../releases), then unzip.

### 3. Double-click to install

| OS | Steps |
| --- | --- |
| 🪟 **Windows 10/11** | Open the `windows` folder, **right-click `安装.bat` → Run as administrator**, paste your key when prompted |
| 🍎 **macOS 11+** | Open the `mac` folder, double-click `安装.command`, paste your key when prompted |

When it's done, **close all terminal windows**, open a new one, `cd` into any project folder and run:

```bash
claude
```

> 🧭 **The first run asks a few questions — don't worry, just hit Enter:**
> pick a theme → Enter; "Do you trust the files in this folder?" → choose **Yes**; anything else you're unsure about → just press **Enter** for the default. It only asks once.

That's it. Type `/` inside `claude` to see all skills.

---

## 🧩 12 built-in Chinese skills

The installer copies these into `~/.claude/skills`. Two ways to use them: type `/skill-name`, or just describe your need in plain language and Claude picks the right skill.

| Category | Skill | What it does |
| --- | --- | --- |
| **Coding** | `/code-review` | Review code for bugs, security issues, simplifications |
| | `/debug` | Paste an error — it finds the root cause and fixes it |
| | `/explain-code` | Explain a snippet/function in plain Chinese |
| | `/write-tests` | Generate and run unit tests for a function/file |
| | `/git-commit` | Inspect the diff and write a clean commit message |
| **Docs** | `/docx` | Read/write Word: extract text, build reports, batch replace |
| | `/xlsx` | Read/write Excel: aggregate, build reports, write formulas |
| | `/pptx` | Read / batch-generate PowerPoint slides |
| | `/pdf` | Extract text/tables, merge/split, extract pages |
| **Writing** | `/tech-writing` | Write/improve READMEs, manuals, API docs, tutorials |
| | `/markdown-format` | Turn messy text into clean, well-formatted Markdown |
| **Chinese** | `/translate-zh` | Polished CN↔EN translation, great for technical content |

> 📌 The document skills (docx/xlsx/pptx/pdf) need Python; the installer tries to set up the deps automatically.

---

## 🖥️ Supported platforms

- **Windows 10 / 11** (`windows/install.ps1`, launched via `安装.bat`)
- **macOS 11 Big Sur and above**, Intel and Apple Silicon (M1/M2/M3…) (`mac/install.sh`, launched via `安装.command`)

Both scripts: detect/install Node.js → install Claude Code via China mirror → write DeepSeek env vars → install skills → (optional) install Python doc deps.

---

## ⚙️ What it actually changes (full transparency)

The scripts only do the following — nothing sneaky:

1. Install Node.js from a China mirror if missing;
2. Install the official `@anthropic-ai/claude-code` via npmmirror;
3. Write 4 environment variables pointing Claude Code at DeepSeek's latest **V4** models:
   ```bash
   ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
   ANTHROPIC_AUTH_TOKEN=<your DeepSeek key>
   ANTHROPIC_MODEL=deepseek-v4-pro            # main: strong reasoning, for coding
   ANTHROPIC_SMALL_FAST_MODEL=deepseek-v4-flash   # small tasks: fast
   ```
4. Copy `skills/` into `~/.claude/skills`.

> 💬 Want a different model? Change the two variables above to any model your account supports and reopen the terminal. See the [DeepSeek docs](https://platform.deepseek.com).

---

## ❓ FAQ

<details>
<summary><b>"command not found" when running claude?</b></summary>

Env vars only apply to newly opened terminals. Close all terminal windows, open a fresh one, and try again. Still failing? Re-run the installer.
</details>

<details>
<summary><b>npm hangs, or errors mention proxy / ECONNREFUSED 127.0.0.1?</b></summary>

A VPN/accelerator is intercepting npm. npmmirror is a domestic source — **turn off your VPN/accelerator** and re-run the installer.
</details>

<details>
<summary><b>API Error 400 inside claude?</b></summary>

Usually a stray space in the pasted key, or it didn't paste. Re-run the installer and paste the key again (the script trims whitespace).
</details>

<details>
<summary><b>401 / Authentication Fails?</b></summary>

Wrong/expired key, or no account credit (DeepSeek has no free tier). Verify the key and balance at platform.deepseek.com.
</details>

> ★ **Golden rule**: after changing any config, always "close all terminals → open a new one" before testing.

---

## 🤝 Contributing

Help make low-barrier AI coding available to more people:

- 🐛 Found a bug → open an [Issue](../../issues)
- 💡 New skill or improvement → open a [Pull Request](../../pulls)
- ⭐ Found it useful → Star it so others can find it

Especially welcome: more Chinese skills, a Linux installer, and adapters for other Chinese models (Qwen / Kimi / GLM, etc.).

---

## 📈 Star history

If this project helped you, a ⭐ adds a point to this line —

[![Star History Chart](https://api.star-history.com/svg?repos=Ducktang123/claude-code-deepseek&type=Date)](https://star-history.com/#Ducktang123/claude-code-deepseek&Date)

---

## 👤 Author

**不要口嗨 (Ducktang)** — sharing tools and tricks that make AI approachable for everyone.

- 🎵 Douyin: **1532422321**
- 💬 WeChat: **ducktangsir**

---

## ⚖️ License & disclaimer

- Released under the [MIT License](LICENSE).
- This is a **third-party helper/installer** for Claude Code, not affiliated with Anthropic or DeepSeek; trademarks belong to their respective owners.
- The scripts only install official software and set local env vars — they **never upload your API key or code**. Keep your own API key safe.

<div align="center">

If this helped you, leave a ⭐ Star — it means a lot!

</div>
