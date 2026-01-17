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

# Install Modules

Write-Host "Installing PowerShell Modules..."

$modules = @(
    "Microsoft.WinGet.Client",
    "Microsoft.WinGet.CommandNotFound"
)

foreach ($module in $modules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        Write-Host "  Installing $module..."
        Install-Module -Name $module -Force -AllowClobber -Scope CurrentUser
    }
    else {
        Write-Host "  $module is already installed."
    }
}

# Install WinGet Packages

Write-Host "Installing WinGet Packages..."

$packages = @(
    "Schniz.fnm",
    "astral-sh.uv",
    "Oven-sh.Bun"
)

foreach ($package in $packages) {
    $installed = winget list --id $package --exact 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Installing $package..."
        winget install --id $package --exact --silent
    }
    else {
        Write-Host "  $package is already installed."
    }
}

# Setup Configurations

Write-Host "Setting Up Configurations..."

Copy-Item "../.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")
Copy-Item "../configs/agent-instructions.md" (Join-Path $env:USERPROFILE ".gemini\GEMINI.md")
Copy-Item "../configs/copilot-instructions.md" (Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\prompts\personal.instructions.md")

Write-Host "Completed!"
