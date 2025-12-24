@echo off
cd /d %~dp0
pwsh scripts/setup-dotfiles.ps1
pause >nul
exit
