# ============================================================
#  Claude Code + DeepSeek 一键安装脚本 (国内网络优化版)
#  适用：Windows 10 / 11
#  全程使用国内镜像，避免下载失败
# ============================================================

$ErrorActionPreference = "Stop"
try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
try { chcp 65001 > $null } catch {}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---- 国内镜像地址 ----
$NPM_MIRROR  = "https://registry.npmmirror.com"
$NODE_MIRROR = "https://npmmirror.com/mirrors/node"
$PIP_MIRROR  = "https://pypi.tuna.tsinghua.edu.cn/simple"

function Write-Step($msg)  { Write-Host "`n>>> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)    { Write-Host "    [OK] $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "    [!]  $msg" -ForegroundColor Yellow }
function Write-Err($msg)   { Write-Host "    [X]  $msg" -ForegroundColor Red }

Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "   Claude Code + DeepSeek  一键安装 (国内镜像版)" -ForegroundColor Magenta
Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
Write-Host "   作者：不要口嗨 —— 一个掌握 AI 使用技巧的中登文科生" -ForegroundColor DarkGray
Write-Host "   抖音号：1532422321    微信号：ducktangsir" -ForegroundColor DarkGray
Write-Host "   有问题随时找我，欢迎来到 AI 的世界" -ForegroundColor DarkGray
Write-Host "============================================================" -ForegroundColor Magenta

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

function Refresh-Path {
    $m = [Environment]::GetEnvironmentVariable("Path","Machine")
    $u = [Environment]::GetEnvironmentVariable("Path","User")
    $env:Path = "$m;$u"
}

# ------------------------------------------------------------
# 0. 清理旧的冲突残留（避免之前乱装过影响本次安装）
# ------------------------------------------------------------
Write-Step "清理旧的冲突残留"

# 0a. 删除会抢占的 ANTHROPIC_API_KEY（与本包用的 AUTH_TOKEN 冲突）
foreach ($scope in @("User","Process")) {
    if ([Environment]::GetEnvironmentVariable("ANTHROPIC_API_KEY", $scope)) {
        [Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", $null, $scope)
        Write-Ok "已清除 $scope 级旧变量 ANTHROPIC_API_KEY"
    }
}
if (Test-Path Env:\ANTHROPIC_API_KEY) { Remove-Item Env:\ANTHROPIC_API_KEY -ErrorAction SilentlyContinue }

# 0b. 检查系统级(Machine)残留——它会盖过用户级设置
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
foreach ($v in @("ANTHROPIC_API_KEY","ANTHROPIC_AUTH_TOKEN","ANTHROPIC_BASE_URL","ANTHROPIC_MODEL","ANTHROPIC_SMALL_FAST_MODEL")) {
    if ([Environment]::GetEnvironmentVariable($v, "Machine")) {
        if ($isAdmin) {
            try { [Environment]::SetEnvironmentVariable($v, $null, "Machine"); Write-Ok "已清除系统级残留 $v" }
            catch { Write-Warn "系统级 $v 清除失败，可能影响生效" }
        } else {
            Write-Warn "检测到系统级残留 $v（需管理员才能清除）。建议右键以管理员身份重跑安装。"
        }
    }
}

# 0c. 提示旧配置文件（不自动删除，避免误删用户数据）
$cfg = Join-Path $env:USERPROFILE ".claude.json"
if (Test-Path $cfg) {
    Write-Warn "检测到旧配置 $cfg。一般不影响（环境变量优先）；若装好后仍连旧账号，可手动删除此文件。"
}

# 0d. 清除代理干扰（加速器/VPN 会让 npm 卡死或报 ECONNREFUSED 127.0.0.1）
$proxyHit = $false
foreach ($pv in @("HTTP_PROXY","HTTPS_PROXY","http_proxy","https_proxy")) {
    if ([Environment]::GetEnvironmentVariable($pv,"Process")) {
        [Environment]::SetEnvironmentVariable($pv,$null,"Process"); $proxyHit = $true
    }
}
try {
    $np = (npm config get proxy 2>$null)
    if ($np -and $np -ne "null") { npm config delete proxy 2>$null; $proxyHit = $true }
    $nhp = (npm config get https-proxy 2>$null)
    if ($nhp -and $nhp -ne "null") { npm config delete https-proxy 2>$null; $proxyHit = $true }
} catch {}
if ($proxyHit) {
    Write-Ok "已为本次安装临时清除代理（npmmirror 是国内源，直连即可）"
    Write-Warn "若你开着加速器/VPN，安装期间请先关掉，装完再开。"
}

# ------------------------------------------------------------
# 1. 检查 / 安装 Node.js（国内镜像）
# ------------------------------------------------------------
Write-Step "检查 Node.js 环境"
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    Write-Ok "已检测到 Node.js $(node -v)"
} else {
    Write-Warn "未检测到 Node.js，开始自动安装..."
    $installed = $false

    # 方式 A：winget
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        try {
            Write-Host "    尝试用 winget 安装 Node.js LTS..."
            winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
            $installed = $true
        } catch { Write-Warn "winget 安装失败，改用国内镜像下载。" }
    }

    # 方式 B：从 npmmirror 下载 MSI（纯国内网络）
    if (-not $installed) {
        try {
            Write-Host "    从国内镜像获取 Node.js 版本列表..."
            $idx = Invoke-RestMethod -Uri "$NODE_MIRROR/index.json" -TimeoutSec 60
            $lts = ($idx | Where-Object { $_.lts } | Select-Object -First 1)
            $ver = $lts.version            # 例如 v22.11.0
            $msiUrl = "$NODE_MIRROR/$ver/node-$ver-x64.msi"
            $msiPath = Join-Path $env:TEMP "node-$ver-x64.msi"
            Write-Host "    下载 $msiUrl"
            Invoke-WebRequest -Uri $msiUrl -OutFile $msiPath -TimeoutSec 600
            Write-Host "    静默安装中（约 1 分钟）..."
            Start-Process msiexec.exe -ArgumentList "/i `"$msiPath`" /qn /norestart" -Wait
            $installed = $true
        } catch {
            Write-Err "国内镜像安装 Node.js 失败：$($_.Exception.Message)"
        }
    }

    Refresh-Path
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Warn "Node.js 已安装，但当前窗口未识别到。"
        Write-Warn "请关闭本窗口，重新双击 [安装.bat] 再运行一次即可。"
        Read-Host "按回车退出"
        exit 0
    }
    Write-Ok "Node.js 安装完成：$(node -v)"
}

# ------------------------------------------------------------
# 2. 配置 npm 国内镜像 + 安装 Claude Code
# ------------------------------------------------------------
Write-Step "配置 npm 国内镜像并安装 Claude Code"
try {
    npm config set registry $NPM_MIRROR
    Write-Ok "npm 镜像已设为 npmmirror（淘宝）"
    npm install -g "@anthropic-ai/claude-code"
    if ($LASTEXITCODE -ne 0) {
        throw "npm 安装返回错误码 $LASTEXITCODE。最常见原因：开着加速器/VPN 代理，npm 连不上。请关掉代理/加速器后重新运行本安装包。"
    }
    Refresh-Path
    Write-Ok "Claude Code 安装/更新完成"
} catch {
    Write-Err "Claude Code 安装失败：$($_.Exception.Message)"
    Read-Host "按回车退出"
    exit 1
}

# 检测是否存在多个 claude（不同安装方式的残留），PATH 靠前的才会被运行
$allClaude = @(Get-Command claude -All -ErrorAction SilentlyContinue)
if ($allClaude.Count -gt 1) {
    Write-Warn "检测到多个 claude，优先运行的是：$($allClaude[0].Source)"
    $allClaude | ForEach-Object { Write-Host "      - $($_.Source)" }
    Write-Warn "若运行的不是本次安装的版本，建议卸载多余的（winget uninstall 或删除旧路径）。"
}

# ------------------------------------------------------------
# 3. 输入 DeepSeek API Key
# ------------------------------------------------------------
Write-Step "配置 DeepSeek API Key"
Write-Host "    没有 Key 就先去 https://platform.deepseek.com 注册创建（形如 sk-xxxx）"
Write-Host "    提示：粘贴用【右键】或【Ctrl+V】，粘贴后按回车。" -ForegroundColor DarkGray
$ApiKey = ""
for ($i = 1; $i -le 3; $i++) {
    $ApiKey = (Read-Host "    请粘贴你的 DeepSeek API Key").Trim()
    if ($ApiKey.Length -ge 20 -and $ApiKey.StartsWith("sk-")) {
        Write-Ok "已接收 Key（长度 $($ApiKey.Length)）"
        break
    }
    Write-Warn "这不像有效 Key（应以 sk- 开头、约 35 位）。当前长度 $($ApiKey.Length)，请重新粘贴。"
    $ApiKey = ""
}
if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    Write-Err "没拿到有效 Key（试了 3 次），已退出。请重新运行并确认粘贴成功。"
    Read-Host "按回车退出"; exit 1
}

# ------------------------------------------------------------
# 4. 写入环境变量（永久 + 当前会话）
#    DeepSeek 最新模型：v4-pro(强) / v4-flash(快)
# ------------------------------------------------------------
Write-Step "写入环境变量（使用 DeepSeek V4 最新模型）"
$BaseUrl    = "https://api.deepseek.com/anthropic"
$MainModel  = "deepseek-v4-pro"     # 主力：代码/复杂 agent
$FastModel  = "deepseek-v4-flash"   # 小任务：快
[Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL",         $BaseUrl,   "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN",       $ApiKey,    "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_MODEL",            $MainModel, "User")
[Environment]::SetEnvironmentVariable("ANTHROPIC_SMALL_FAST_MODEL", $FastModel, "User")
$env:ANTHROPIC_BASE_URL         = $BaseUrl
$env:ANTHROPIC_AUTH_TOKEN       = $ApiKey
$env:ANTHROPIC_MODEL            = $MainModel
$env:ANTHROPIC_SMALL_FAST_MODEL = $FastModel
Write-Ok "主力模型 = $MainModel ；快速模型 = $FastModel"

# ------------------------------------------------------------
# 5. 安装技能 skills
# ------------------------------------------------------------
Write-Step "安装技能 (skills)"
$SkillSrc = Join-Path $ScriptDir "skills"
$SkillDst = Join-Path $env:USERPROFILE ".claude\skills"
if (Test-Path $SkillSrc) {
    New-Item -ItemType Directory -Force -Path $SkillDst | Out-Null
    $count = 0
    Get-ChildItem -Path $SkillSrc -Directory | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $SkillDst -Recurse -Force
        $count++
    }
    Write-Ok "已安装 $count 个技能到 $SkillDst"
} else {
    Write-Warn "未找到 skills 文件夹，跳过技能安装"
}

# ------------------------------------------------------------
# 6. 可选：为「文档处理」技能装 Python 依赖（清华镜像）
# ------------------------------------------------------------
Write-Step "检查 Python（文档处理技能需要，可跳过）"
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) {
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        try {
            Write-Host "    尝试用 winget 安装 Python..."
            winget install -e --id Python.Python.3.12 --accept-source-agreements --accept-package-agreements
            Refresh-Path
            $py = Get-Command python -ErrorAction SilentlyContinue
        } catch { Write-Warn "Python 自动安装失败。" }
    }
}
if ($py) {
    Write-Ok "检测到 $(python --version)，用清华镜像安装文档库..."
    try {
        python -m pip install --quiet --upgrade pip -i $PIP_MIRROR
        python -m pip install --quiet python-docx openpyxl python-pptx pypdf pdfplumber -i $PIP_MIRROR
        Write-Ok "已安装：python-docx / openpyxl / python-pptx / pypdf / pdfplumber"
    } catch {
        Write-Warn "Python 依赖安装失败，文档脚本功能可能受限：$($_.Exception.Message)"
    }
} else {
    Write-Warn "未安装 Python。文本类技能照常用；如需 Word/Excel/PPT/PDF 脚本，"
    Write-Warn "可到 https://www.python.org 安装后重新运行本脚本。"
}

# ------------------------------------------------------------
# 完成
# ------------------------------------------------------------
Write-Host "`n============================================================" -ForegroundColor Green
Write-Host "   安装完成！" -ForegroundColor Green
Write-Host "============================================================" -ForegroundColor Green
Write-Host @"

使用方法：
  1) 关闭当前所有终端窗口（让环境变量生效）
  2) 新开终端，进入任意项目文件夹，输入：  claude
  3) 在 claude 里输入 /  可查看已安装技能

已安装技能（/ + 名称 调用）：
  编程类 : code-review  debug  explain-code  write-tests  git-commit
  文档类 : docx  xlsx  pptx  pdf
  写作类 : tech-writing  markdown-format
  中文类 : translate-zh

模型：主力 $MainModel ，快速 $FastModel （DeepSeek V4 最新）
如需更换 Key / 模型，重新运行本安装包即可。

------------------------------------------------------------
  作者：不要口嗨 —— 一个掌握 AI 使用技巧的中登文科生
  有问题随时找我，欢迎来到 AI 的世界
  抖音号：1532422321        微信号：ducktangsir
------------------------------------------------------------
"@ -ForegroundColor White

Read-Host "按回车退出"
