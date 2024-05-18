Set-Location $PSScriptRoot

# Setup Global Editorconfig

Copy-Item -Path "dotfiles\.editorconfig" -Destination (Join-Path $env:USERPROFILE ".editorconfig")

# Setup Powershell Profile

$powershellProfile = (Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1")
$powershellProfileDir = Split-Path -Path $powershellProfile -Parent

if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item -ItemType Directory -Path $parentDir | Out-Null
}

Copy-Item -Path "dotfiles\profile.ps1" -Destination $powershellProfile