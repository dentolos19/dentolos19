Set-Location $PSScriptRoot

Write-Host "Installing Profiles..." -ForegroundColor Yellow

$powershellProfileDir = (Join-Path $env:USERPROFILE "Documents\PowerShell")

if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item $powershellProfileDir -ItemType Directory | Out-Null
}

Copy-Item "../configs/powershell.profile.ps1" (Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1")
Copy-Item "../configs/powershell.config.json" (Join-Path $powershellProfileDir "powershell.config.json")
Copy-Item "../configs/biome.json" (Join-Path $env:USERPROFILE "biome.json")
Copy-Item "../.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")

Write-Host "Profiles installed successfully!" -ForegroundColor Green
