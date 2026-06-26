@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo.
echo   正在启动 Claude Code + DeepSeek 安装程序...
echo   Starting installer (PowerShell)...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
echo.
pause
