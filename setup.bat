@echo off
cd /d %~dp0

where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Please install PowerShell 7 or later before running this script.
    pause >nul
    exit /b 1
)

pwsh scripts/setup.ps1
pause >nul
exit
