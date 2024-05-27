@echo off
cd /d %~dp0
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './dotfiles/setup.ps1'"
exit