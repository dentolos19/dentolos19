Set-Location $PSScriptRoot

# Setup Powershell Profile

Write-Host "Installing Profiles..."

$powershellProfileDir = (Join-Path $env:USERPROFILE "Documents\PowerShell")
$powershellProfileFile = (Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1")
$powershellConfigFile = (Join-Path $powershellProfileDir "powershell.config.json")

if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item $powershellProfileDir -ItemType Directory | Out-Null
}

Copy-Item "profiles/powershell.profile.ps1" $powershellProfileFile
Copy-Item "profiles/powershell.config.json" $powershellConfigFile

# Setup Configurations

Write-Host "Setting Up Configurations..."

Copy-Item "configs/default.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")
Copy-Item "configs/personal.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/personal.instructions.md")
Copy-Item "configs/web.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/web.instructions.md")
Copy-Item "configs/react.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/react.instructions.md")

Write-Host "Completed!"