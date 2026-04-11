Set-Location $PSScriptRoot

Write-Host "Installing Packages..." -ForegroundColor Yellow

$packages = @(
    # Development Tools
    "Schniz.fnm",
    "astral-sh.uv",
    "Oven-sh.Bun",

    # Other Tools
    "Proton.ProtonVPN"
)

foreach ($package in $packages) {
    $output = winget list --id $package --exact 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Installing $package..."
        winget install --id $package --exact --silent >$null
    }
    else {
        Write-Host "  $package is already installed. Upgrading instead..."
        winget upgrade --id $package --exact --silent >$null
    }
}

Write-Host "Packages installed successfully!" -ForegroundColor Green
