@echo off
cd /d %~dp0

rem Check PowerShell Installation
where pwsh >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Please install PowerShell 7 or later before running this script.
    pause >nul
    exit /b 1
)

rem Export Environment Variables
if exist .env (
    for /f "usebackq tokens=1,* delims==" %%i in (".env") do set "%%i=%%~j"
)

pwsh scripts/setup.ps1
pause >nul
exit
