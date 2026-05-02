Set-Location $PSScriptRoot

Write-Host "Installing Profiles..." -ForegroundColor Yellow

if (-not $IsWindows) {
    Write-Host "  Skipping profile setup. You are not on Windows." -ForegroundColor Cyan
    return
}

$powershellProfileDir = Join-Path $HOME "Documents\PowerShell"
if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item $powershellProfileDir -ItemType Directory -Force | Out-Null
}

$profileSource = Join-Path $PSScriptRoot ".." "configs" "powershell.profile.ps1"
$profileDest = Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1"
if (Test-Path $profileSource) {
    Copy-Item $profileSource $profileDest -Force
}

$configSource = Join-Path $PSScriptRoot ".." "configs" "powershell.config.json"
$configDest = Join-Path $powershellProfileDir "powershell.config.json"
if (Test-Path $configSource) {
    Copy-Item $configSource $configDest -Force
}

Write-Host "Profiles installed successfully!" -ForegroundColor Green
