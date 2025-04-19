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

Write-Host "Setting up Configurations..."

Copy-Item "configs/default.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")

# Install Packages

Write-Host "Installing Packages..."

$packages = @(
    "Schniz.fnm",
    "astral-sh.uv"
)

$installedPackages = winget list | Out-String

foreach ($package in $packages) {
    $installed = $installedPackages | Select-String -Pattern $package
    if (-not $installed) {
        # Write-Host "- Installing $package..."
        & winget install --id $package --silent | Out-Null
    }
    else {
        # Write-Host "- $package is already installed."
    }
}

Write-Host "Completed!"