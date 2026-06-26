<div align="center">

# 🐤 Claude Code + DeepSeek 一键傻瓜式安装

**让全球最强的 AI 编程命令行工具 [Claude Code](https://github.com/anthropics/claude-code)，跑在又便宜又好用的 DeepSeek 模型上。**

国内网络直连 · 无需梯子 · 双击安装 · 自带 12 个中文技能

**简体中文** ｜ [English](README.en.md)

[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS-blue)](#-支持平台)
[![Mirror](https://img.shields.io/badge/国内镜像-npmmirror%20%2F%20清华源-orange)](#)
[![Model](https://img.shields.io/badge/模型-DeepSeek%20V4%20(1M%20上下文)-7C3AED)](https://platform.deepseek.com)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)](#-参与共建)

如果这个项目帮到了你，点个 ⭐ **Star** 支持一下，也方便你以后找回来 🙏

</div>

---

## 📖 这是什么

[Claude Code](https://github.com/anthropics/claude-code) 是 Anthropic 官方出的命令行 AI 编程助手，能直接在终端里读你的代码、改 bug、写测试、处理文档。但它默认要用 Anthropic 的账号和网络，**国内用起来又贵又麻烦**。

这个安装包做的事很简单：

> **把 Claude Code 接到 DeepSeek 上，全程国内镜像，双击一下全自动装好，开箱即用。**

- ✅ **不用梯子**：Node.js、Claude Code、Python 依赖全走国内镜像（npmmirror / 清华源）。
- ✅ **不用配置**：自动装环境、自动写好环境变量，你只需要粘贴一个 DeepSeek API Key。
- ✅ **便宜又强**：用 DeepSeek 的价格，体验 Claude Code 的能力。默认就用最新的 **DeepSeek V4**（`v4-pro` / `v4-flash`），**100 万 token 超长上下文**、支持思考/非思考双模式。
- ✅ **中文友好**：内置 12 个开箱即用的中文技能（skills），说人话就能调用。
- ✅ **双平台**：Windows 和 macOS（Intel / Apple 芯片）都支持。

> 适合：想白嫖 Claude Code 强大体验、又不想折腾环境的国内开发者、学生、AI 爱好者。

---

## 🎬 演示

**一键安装（双击即可，全程自动）：**

![安装演示](assets/demo-install.svg)

**装好后在 `claude` 里直接用中文技能：**

![技能演示](assets/demo-skill.svg)

> 📷 想看真实录屏？欢迎把你的安装/使用截图或 GIF 发我，我会放到这里。
> （贡献者也可以把素材放进 `assets/` 并提 PR）
>
> <!-- 真实 GIF 占位：把录好的 demo.gif 放进 assets/，然后取消下一行注释 -->
> <!-- ![真实录屏](assets/demo.gif) -->

## 🚀 三步上手

### 第 1 步：拿一个 DeepSeek API Key
去 [platform.deepseek.com](https://platform.deepseek.com) 注册 → 创建 API Key（形如 `sk-xxxxxxxx`）→ 充一点点钱（DeepSeek 没有免费额度，但很便宜）。

### 第 2 步：下载本安装包
点右上角 **Code → Download ZIP**，或到 [Releases](../../releases) 下载对应平台的压缩包，解压。

### 第 3 步：双击安装

| 系统 | 操作 |
| --- | --- |
| 🪟 **Windows 10/11** | 进入 `windows` 文件夹，**右键 `安装.bat` → 以管理员身份运行**，按提示粘贴 Key |
| 🍎 **macOS 11+** | 进入 `mac` 文件夹，双击 `安装.command`，按提示粘贴 Key |

装完后，**关掉所有终端窗口**，新开一个，进入任意项目文件夹，输入：

```bash
claude
```

> 🧭 **第一次运行会问几个问题，别慌，一路回车就行：**
> 选主题 → 按回车；问「是否信任当前文件夹」→ 选 **Yes / 信任**；其它拿不准的 → 直接 **回车** 用默认。这些只问一次。

搞定！在 `claude` 里输入 `/` 就能看到所有技能。

---

## 🧩 内置 12 个中文技能

安装包会自动把这些技能装进 `~/.claude/skills`。两种用法：① 在 claude 里输入 `/技能名`；② 直接用大白话说需求，它会自动挑合适的技能。

| 分类 | 技能 | 作用 |
| --- | --- | --- |
| **编程** | `/code-review` | 审查代码，找 bug、安全隐患、可简化处 |
| | `/debug` | 贴报错给它，系统化定位根因并修复 |
| | `/explain-code` | 用通俗中文讲清一段代码/函数 |
| | `/write-tests` | 为函数/文件生成单元测试并跑通 |
| | `/git-commit` | 看改动，生成规范的 git commit 信息 |
| **文档** | `/docx` | 读写 Word：提取文字、做报告、批量替换 |
| | `/xlsx` | 读写 Excel：汇总统计、生成报表、写公式 |
| | `/pptx` | 读取/批量生成 PPT 幻灯片 |
| | `/pdf` | PDF 提取文字表格、合并拆分、提取页 |
| **写作** | `/tech-writing` | 写/改 README、说明书、API 文档、教程 |
| | `/markdown-format` | 把杂乱文本整理成规范好看的 Markdown |
| **中文** | `/translate-zh` | 中英互译并润色，技术内容尤其准 |

> 📌 文档类技能（docx/xlsx/pptx/pdf）需要本机有 Python，安装时会尝试自动装好依赖。

---

## 💡 几个真实用法示例

```text
> /code-review                      # 审查你刚改的代码
> 帮我看看这个报错怎么解决            # 贴上报错栈，自动走 debug 技能
> 给 utils.py 里的函数写单元测试      # 自动走 write-tests
> 把这个 PDF 的前三页单独存成一个文件  # 自动走 pdf 技能
> 根据这份大纲帮我生成一个 PPT        # 自动走 pptx 技能
> 这段英文翻译成中文                  # 自动走 translate-zh
```

---

## 🖥️ 支持平台

- **Windows 10 / 11**（`windows/install.ps1`，配 `安装.bat` 一键启动）
- **macOS 11 Big Sur 及以上**，Intel 与 Apple 芯片（M1/M2/M3…）均可（`mac/install.sh`，配 `安装.command`）

两个平台脚本都会：检测/安装 Node.js → 用国内镜像装 Claude Code → 写入 DeepSeek 环境变量 → 安装技能 →（可选）装 Python 文档依赖。

---

## ⚙️ 它到底改了什么（透明说明）

脚本只做这几件事，**不会偷偷动你别的东西**：

1. 没有 Node.js 就从国内镜像装一个；
2. 用 npmmirror 安装官方 `@anthropic-ai/claude-code`；
3. 写入 4 个环境变量，让 Claude Code 指向 DeepSeek 最新的 **V4** 模型：
   ```bash
   ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
   ANTHROPIC_AUTH_TOKEN=<你的 DeepSeek Key>
   ANTHROPIC_MODEL=deepseek-v4-pro            # 主力：强推理，适合编码/复杂任务
   ANTHROPIC_SMALL_FAST_MODEL=deepseek-v4-flash   # 小任务：快
   ```
4. 把 `skills/` 复制到 `~/.claude/skills`。

> 💬 默认已经是最新的 **DeepSeek V4**（`v4-pro` / `v4-flash`，100 万上下文）。想换别的模型，把上面两个变量改成你账号可用的模型名再重开终端即可，可用列表见 [DeepSeek 官方文档](https://platform.deepseek.com)。

---

## ❓ 常见问题（FAQ）

<details>
<summary><b>输入 claude 提示「找不到命令 / command not found」？</b></summary>

环境变量只对**新开**的终端生效。关掉所有终端窗口，重新开一个再试；仍不行就重跑安装包。
</details>

<details>
<summary><b>npm 一直卡住，或报错含 proxy / ECONNREFUSED 127.0.0.1？</b></summary>

开着加速器 / VPN，代理拦截了 npm。npmmirror 是国内源，**关掉加速器 / VPN** 后重新运行安装包即可。
</details>

<details>
<summary><b>claude 里发消息报 API Error 400？</b></summary>

多半是 API Key 粘贴时多了空格或没粘上。重跑安装包，重新粘贴 Key（脚本会自动去空格）。
</details>

<details>
<summary><b>报 401 / Authentication Fails？</b></summary>

Key 错、失效，或账户没充值（DeepSeek 无免费额度）。去 platform.deepseek.com 确认 Key 正确、账户已充值。
</details>

<details>
<summary><b>macOS 双击提示「来自身份不明的开发者」？</b></summary>

系统设置 → 隐私与安全性 → 点【仍要打开】；或在终端里把文件夹拖进去运行 `bash install.sh`。
</details>

> ★ **黄金法则**：改完任何配置，一律「关掉所有终端 → 重新开一个」再测。

更详细的报错速查见各平台文件夹里的 `使用说明.txt`。

---

## 🤝 参与共建

欢迎一起完善这个项目，让更多人低门槛用上 AI 编程：

- 🐛 遇到问题 → 提 [Issue](../../issues)
- 💡 有新技能、新优化 → 提 [Pull Request](../../pulls)
- ⭐ 觉得有用 → 给个 Star，让更多人看到

特别欢迎贡献：更多中文 skills、Linux 安装脚本、其他国产模型（通义 / Kimi / 智谱等）的适配。

---

## 📈 Star 趋势

如果这个项目帮到了你，点个 ⭐ 就是在这条线上添一笔～

[![Star History Chart](https://api.star-history.com/svg?repos=Ducktang123/claude-code-deepseek&type=Date)](https://star-history.com/#Ducktang123/claude-code-deepseek&Date)

---

## 📂 目录结构

```
.
├── windows/            # Windows 安装包（install.ps1 + 安装.bat + 使用说明 + skills）
├── mac/                # macOS 安装包（install.sh + 安装.command + 使用说明 + skills）
├── dist/               # 打包好的 zip，方便直接下载分发
└── README.md
```

---

## 👤 作者

**不要口嗨** —— 一个掌握 AI 使用技巧的中登文科生。
分享让普通人也能轻松上手 AI 的工具和方法，欢迎来到 AI 的世界。

- 🎵 抖音号：**1532422321**
- 💬 微信号：**ducktangsir**

有问题随时找我～

---

## ⚖️ 许可 & 免责声明

- 本项目以 [MIT License](LICENSE) 开源。
- 本项目是 Claude Code 的**第三方安装/配置辅助脚本**，与 Anthropic、DeepSeek 官方均无隶属关系，相关商标归各自所有者。
- 脚本仅在本机安装官方软件、配置环境变量，**不会上传你的 API Key 或任何代码**。请妥善保管你自己的 API Key。

<div align="center">

如果觉得有用，别忘了点一颗 ⭐ Star —— 这是对作者最大的鼓励！

</div>
