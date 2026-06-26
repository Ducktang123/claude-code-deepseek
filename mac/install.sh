#!/bin/bash
# ============================================================
#  Claude Code + DeepSeek 一键安装脚本 (macOS / 国内网络优化版)
#  适用：macOS 11 Big Sur 及以上（Intel 与 Apple 芯片均可）
#  全程使用国内镜像，避免下载失败
# ============================================================

set -u

# ---- 国内镜像地址 ----
NPM_MIRROR="https://registry.npmmirror.com"
NODE_MIRROR="https://registry.npmmirror.com/-/binary/node"
PIP_MIRROR="https://pypi.tuna.tsinghua.edu.cn/simple"

# ---- 颜色输出 ----
c_cyan='\033[36m'; c_green='\033[32m'; c_yellow='\033[33m'; c_red='\033[31m'; c_mag='\033[35m'; c_gray='\033[90m'; c_reset='\033[0m'
step() { printf "\n${c_cyan}>>> %s${c_reset}\n" "$1"; }
ok()   { printf "    ${c_green}[OK] %s${c_reset}\n" "$1"; }
warn() { printf "    ${c_yellow}[!]  %s${c_reset}\n" "$1"; }
err()  { printf "    ${c_red}[X]  %s${c_reset}\n" "$1"; }

printf "${c_mag}============================================================${c_reset}\n"
printf "${c_mag}   Claude Code + DeepSeek  一键安装 (macOS 国内镜像版)${c_reset}\n"
printf "${c_gray}------------------------------------------------------------${c_reset}\n"
printf "${c_gray}   作者：不要口嗨 —— 一个掌握 AI 使用技巧的中登文科生${c_reset}\n"
printf "${c_gray}   抖音号：1532422321    微信号：ducktangsir${c_reset}\n"
printf "${c_gray}   有问题随时找我，欢迎来到 AI 的世界${c_reset}\n"
printf "${c_mag}============================================================${c_reset}\n"

# 脚本所在目录（兼容双击 .command 启动）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ------------------------------------------------------------
# 0. 准备环境 + 选定 shell 配置文件
# ------------------------------------------------------------
step "准备环境"

# 0a. 选定要写入的 shell 配置文件（macOS 默认 zsh）
case "${SHELL:-}" in
  */zsh) PROFILE="$HOME/.zshrc" ;;
  */bash) PROFILE="$HOME/.bash_profile" ;;
  *) PROFILE="$HOME/.zshrc" ;;
esac
touch "$PROFILE"
ok "环境变量将写入：$PROFILE"

# 0b. 清除可能抢占的旧变量（仅当前会话）
unset ANTHROPIC_API_KEY 2>/dev/null || true

# 0c. 临时清除代理（加速器/VPN 会让下载卡死）
if [ -n "${HTTP_PROXY:-}${HTTPS_PROXY:-}${http_proxy:-}${https_proxy:-}" ]; then
  unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy 2>/dev/null || true
  warn "已临时清除代理。若你开着加速器/VPN，安装期间请先关掉，装完再开。"
fi

# 把常见 node/brew 路径加进当前会话，方便检测到已装的版本
export PATH="$HOME/.local/node/bin:/opt/homebrew/bin:/usr/local/bin:$PATH"

# ------------------------------------------------------------
# 1. 检查 / 安装 Node.js
#    优先用已有 node；否则从淘宝镜像下载官方压缩包（国内最稳，免 Homebrew）
# ------------------------------------------------------------
step "检查 Node.js 环境"

if command -v node >/dev/null 2>&1; then
  ok "已检测到 Node.js $(node -v)"
else
  warn "未检测到 Node.js，从淘宝镜像下载官方版本（无需 Homebrew）..."

  # 1a. 识别芯片类型
  ARCH="$(uname -m)"
  case "$ARCH" in
    arm64)  NODE_ARCH="darwin-arm64" ;;   # Apple 芯片 M1/M2/M3...
    x86_64) NODE_ARCH="darwin-x64"   ;;   # Intel
    *)      NODE_ARCH="darwin-x64"   ;;
  esac
  ok "芯片类型：${ARCH}（下载 ${NODE_ARCH} 版）"

  # 1b. 从镜像取最新 LTS 版本号
  echo "    获取最新 LTS 版本号..."
  VER="$(curl -fsSL "$NODE_MIRROR/index.json" | tr '}' '\n' | grep '"lts":"' | head -1 | sed -E 's/.*"version":"([^"]+)".*/\1/')"
  if [ -z "$VER" ]; then
    warn "在线获取版本失败，使用内置稳定版本 v22.17.0"
    VER="v22.17.0"
  fi
  ok "目标版本：$VER"

  # 1c. 下载并解压到用户目录（不需要 sudo）
  PKG="node-$VER-$NODE_ARCH"
  URL="$NODE_MIRROR/$VER/$PKG.tar.gz"
  TMP_TGZ="$(mktemp -t node).tar.gz"
  echo "    下载 $URL"
  if curl -fSL "$URL" -o "$TMP_TGZ"; then
    rm -rf "$HOME/.local/node"
    mkdir -p "$HOME/.local"
    tar -xzf "$TMP_TGZ" -C "$HOME/.local"
    mv "$HOME/.local/$PKG" "$HOME/.local/node"
    rm -f "$TMP_TGZ"
    export PATH="$HOME/.local/node/bin:$PATH"
    # 永久写入 PATH
    if ! grep -q '.local/node/bin' "$PROFILE" 2>/dev/null; then
      echo 'export PATH="$HOME/.local/node/bin:$PATH"' >> "$PROFILE"
    fi
  else
    err "Node.js 下载失败。请检查网络（关掉加速器/VPN）后重试，"
    err "或手动到 https://nodejs.org 下载安装后重新运行本脚本。"
    read -r -p "按回车退出" _; exit 1
  fi

  if ! command -v node >/dev/null 2>&1; then
    err "Node.js 安装后仍未识别。请关闭终端重开后再跑一次本脚本。"
    read -r -p "按回车退出" _; exit 1
  fi
  ok "Node.js 安装完成：$(node -v)"
fi

# ------------------------------------------------------------
# 2. 配置 npm 国内镜像 + 安装 Claude Code
# ------------------------------------------------------------
step "配置 npm 国内镜像并安装 Claude Code"
npm config set registry "$NPM_MIRROR"
ok "npm 镜像已设为 npmmirror（淘宝）"

if npm install -g "@anthropic-ai/claude-code" 2>/dev/null; then
  ok "Claude Code 安装/更新完成"
else
  warn "全局安装受限，改用用户目录安装（无需 sudo）..."
  NPM_PREFIX="$HOME/.npm-global"
  mkdir -p "$NPM_PREFIX"
  npm config set prefix "$NPM_PREFIX"
  if ! grep -q '.npm-global/bin' "$PROFILE" 2>/dev/null; then
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$PROFILE"
  fi
  export PATH="$NPM_PREFIX/bin:$PATH"
  if npm install -g "@anthropic-ai/claude-code"; then
    ok "Claude Code 已安装到用户目录"
  else
    err "Claude Code 安装失败。最常见原因：开着加速器/VPN 代理。请关掉后重试。"
    read -r -p "按回车退出" _; exit 1
  fi
fi

# ------------------------------------------------------------
# 3. 输入 DeepSeek API Key
# ------------------------------------------------------------
step "配置 DeepSeek API Key"
echo "    没有 Key 就先去 https://platform.deepseek.com 注册创建（形如 sk-xxxx）"
ApiKey=""
for i in 1 2 3; do
  read -r -p "    请粘贴你的 DeepSeek API Key: " ApiKey
  ApiKey="$(echo "$ApiKey" | tr -d '[:space:]')"
  if [ "${#ApiKey}" -ge 20 ] && [ "${ApiKey:0:3}" = "sk-" ]; then
    ok "已接收 Key（长度 ${#ApiKey}）"
    break
  fi
  warn "这不像有效 Key（应以 sk- 开头、约 35 位）。当前长度 ${#ApiKey}，请重新粘贴。"
  ApiKey=""
done
if [ -z "$ApiKey" ]; then
  err "没拿到有效 Key（试了 3 次），已退出。请重新运行并确认粘贴成功。"
  read -r -p "按回车退出" _; exit 1
fi

# ------------------------------------------------------------
# 4. 写入环境变量（写进 shell 配置文件，永久生效）
# ------------------------------------------------------------
step "写入环境变量（使用 DeepSeek 模型）"
BaseUrl="https://api.deepseek.com/anthropic"
MainModel="deepseek-v4-pro"     # 主力：代码/复杂任务
FastModel="deepseek-v4-flash"   # 小任务：快

# 先删掉本脚本以前写过的旧块，避免重复
TMP_PROFILE="$(mktemp)"
sed '/# >>> CC-DeepSeek >>>/,/# <<< CC-DeepSeek <<</d' "$PROFILE" > "$TMP_PROFILE" 2>/dev/null || cp "$PROFILE" "$TMP_PROFILE"
cat "$TMP_PROFILE" > "$PROFILE"
rm -f "$TMP_PROFILE"

{
  echo "# >>> CC-DeepSeek >>>"
  echo "export ANTHROPIC_BASE_URL=\"$BaseUrl\""
  echo "export ANTHROPIC_AUTH_TOKEN=\"$ApiKey\""
  echo "export ANTHROPIC_MODEL=\"$MainModel\""
  echo "export ANTHROPIC_SMALL_FAST_MODEL=\"$FastModel\""
  echo "# <<< CC-DeepSeek <<<"
} >> "$PROFILE"

# 当前会话也立即生效
export ANTHROPIC_BASE_URL="$BaseUrl"
export ANTHROPIC_AUTH_TOKEN="$ApiKey"
export ANTHROPIC_MODEL="$MainModel"
export ANTHROPIC_SMALL_FAST_MODEL="$FastModel"
ok "主力模型 = $MainModel ；快速模型 = $FastModel"

# ------------------------------------------------------------
# 5. 安装技能 skills
# ------------------------------------------------------------
step "安装技能 (skills)"
SkillSrc="$SCRIPT_DIR/skills"
SkillDst="$HOME/.claude/skills"
if [ -d "$SkillSrc" ]; then
  mkdir -p "$SkillDst"
  count=0
  for d in "$SkillSrc"/*/; do
    [ -d "$d" ] || continue
    cp -R "$d" "$SkillDst/"
    count=$((count+1))
  done
  ok "已安装 $count 个技能到 $SkillDst"
else
  warn "未找到 skills 文件夹，跳过技能安装"
fi

# ------------------------------------------------------------
# 6. 可选：为「文档处理」技能装 Python 依赖（清华镜像）
# ------------------------------------------------------------
step "检查 Python（文档处理技能需要，可跳过）"
if command -v python3 >/dev/null 2>&1; then
  ok "检测到 $(python3 --version)，用清华镜像安装文档库..."
  python3 -m pip install --quiet --upgrade pip -i "$PIP_MIRROR" 2>/dev/null || true
  if python3 -m pip install --quiet python-docx openpyxl python-pptx pypdf pdfplumber -i "$PIP_MIRROR" 2>/dev/null; then
    ok "已安装：python-docx / openpyxl / python-pptx / pypdf / pdfplumber"
  else
    warn "Python 依赖安装失败（可能需要虚拟环境）。文本类技能照常用。"
  fi
else
  warn "未检测到 python3。文本类技能照常用；如需 Word/Excel/PPT/PDF 脚本，"
  warn "可装好 Python3 后重新运行本脚本。"
fi

# ------------------------------------------------------------
# 完成
# ------------------------------------------------------------
printf "\n${c_green}============================================================${c_reset}\n"
printf "${c_green}   安装完成！${c_reset}\n"
printf "${c_green}============================================================${c_reset}\n"
cat <<EOF

使用方法：
  1) 关闭当前所有「终端」窗口（让环境变量生效）
  2) 新开终端，进入任意项目文件夹，输入：  claude
  3) 在 claude 里输入 /  可查看已安装技能

已安装技能（/ + 名称 调用）：
  编程类 : code-review  debug  explain-code  write-tests  git-commit
  文档类 : docx  xlsx  pptx  pdf
  写作类 : tech-writing  markdown-format
  中文类 : translate-zh

模型：主力 $MainModel ，快速 $FastModel
如需更换 Key / 模型，重新运行本安装包即可。

------------------------------------------------------------
  作者：不要口嗨 —— 一个掌握 AI 使用技巧的中登文科生
  有问题随时找我，欢迎来到 AI 的世界
  抖音号：1532422321        微信号：ducktangsir
------------------------------------------------------------
EOF
read -r -p "按回车退出" _
