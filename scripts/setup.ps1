Set-Location $PSScriptRoot

# Setup Profile

Write-Host "Installing Profiles..."

$powershellProfileDir = (Join-Path $env:USERPROFILE "Documents\PowerShell")
$powershellProfileFile = (Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1")
$powershellConfigFile = (Join-Path $powershellProfileDir "powershell.config.json")

if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item $powershellProfileDir -ItemType Directory | Out-Null
}

Copy-Item "../configs/powershell.profile.ps1" $powershellProfileFile
Copy-Item "../configs/powershell.config.json" $powershellConfigFile

# Setup Configurations

Write-Host "Setting Up Configurations..."

Copy-Item "../.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")

Write-Host "Completed!"
