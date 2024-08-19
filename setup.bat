@echo off
cd /d %~dp0
pwsh dotfiles/setup.ps1
pause >nul
exit