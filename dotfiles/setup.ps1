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

# Install Packages

Write-Host "Installing Packages..."

$packages = @(
    "Schniz.fnm",
    "astral-sh.uv"
)

foreach ($package in $packages) {
    & winget install $package | Out-Null
}

Write-Host "Completed!"