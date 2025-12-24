Set-Location $PSScriptRoot

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
