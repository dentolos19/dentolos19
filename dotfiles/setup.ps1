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

Copy-Item "../.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")
Copy-Item "configs/personal.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/personal.instructions.md")
Copy-Item "configs/web.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/web.instructions.md")
Copy-Item "configs/react.instructions.md" (Join-Path $env:APPDATA "Code/User/prompts/react.instructions.md")

# Install Packages

Write-Host "Installing Packages..."

if (-not (Get-Command fnm -ErrorAction SilentlyContinue)) {
    Write-Host "  Installing fnm..."
    & winget install Schniz.fnm
    & fnm install --latest
    & npm install --global pnpm
}
else {
    Write-Host "  fnm is already installed."
}

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "  Installing uv..."
    & winget install astral-sh.uv
    & uv python install
}
else {
    Write-Host "  uv is already installed."
}

if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "  Installing bun..."
    & winget install oven-sh.bun
}
else {
    Write-Host "  bun is already installed."
}

Write-Host "Completed!"
