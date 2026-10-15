@echo off
rem Double-click to install pstack for Claude Code, Codex, and Grok Build.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
echo.
pause
