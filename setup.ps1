Set-Location $PSScriptRoot

Copy-Item -Path "dotfiles\.editorconfig" -Destination (Join-Path $env:USERPROFILE ".editorconfig")
Copy-Item -Path "dotfiles\profile.ps1" -Destination (Join-Path $env:USERPROFILE "Documents\PowerShell\Microsoft.PowerShell_profile.ps1")