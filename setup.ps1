Set-Location $PSScriptRoot

$profileFile = Join-Path $env:USERPROFILE "Documents/PowerShell/Microsoft.PowerShell_profile.ps1"

Copy-Item -Path "dotfiles/profile.ps1" -Destination $profileFile