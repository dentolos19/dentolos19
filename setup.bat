@echo off
cd /d %~dp0
pwsh scripts/setup.ps1
pause >nul
exit
