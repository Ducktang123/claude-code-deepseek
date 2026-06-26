#!/bin/bash
# 双击本文件即可开始安装（macOS）
# 它会自动切换到自己所在目录，然后运行 install.sh
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR" || exit 1
chmod +x "$DIR/install.sh" 2>/dev/null
/bin/bash "$DIR/install.sh"
