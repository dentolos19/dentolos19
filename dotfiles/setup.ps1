Set-Location $PSScriptRoot

Write-Host Installing...

# Setup Global Editorconfig

Copy-Item -Path ".editorconfig" -Destination (Join-Path $env:USERPROFILE ".editorconfig")

# Setup Powershell Profile

$powershellProfileDir = (Join-Path $env:USERPROFILE "Documents\PowerShell")
$powershellProfileFile = (Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1")
$powershellConfigFile = (Join-Path $powershellProfileDir "powershell.config.json")

if (-not (Test-Path -Path $powershellProfileDir)) {
    New-Item -ItemType Directory -Path $powershellProfileDir | Out-Null
}

Copy-Item -Path "profiles/powershell.profile.ps1" -Destination $powershellProfileFile
Copy-Item -Path "profiles/powershell.config.json" -Destination $powershellConfigFile

Write-Host Completed!