Set-Location $PSScriptRoot

Write-Host "Installing Packages..." -ForegroundColor Yellow

$hasBrew = $null -ne (Get-Command "brew" -ErrorAction SilentlyContinue)

$packages = @(
    @{ Name = "fnm"; WinId = "Schniz.fnm"; BrewId = "fnm" }
    @{ Name = "uv"; WinId = "astral-sh.uv"; BrewId = "uv" }
    @{ Name = "bun"; WinId = "Oven-sh.Bun"; BrewId = "bun" }
)

foreach ($packages in $packages) {
    if ($IsWindows) {
        $output = winget list --id $packages.WinId --exact 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Installing $($packages.Name)..." -ForegroundColor Cyan
            winget install --id $packages.WinId --exact --silent >$null
        }
        else {
            Write-Host "  $($packages.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
            winget upgrade --id $packages.WinId --exact --silent >$null
        }
    }
    elseif ($hasBrew -and $packages.BrewId) {
        $installed = brew list $($packages.BrewId) 2>$null
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  Installing $($packages.Name)..." -ForegroundColor Cyan
            brew install $($packages.BrewId)
        }
        else {
            Write-Host "  $($packages.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
            brew upgrade $($packages.BrewId)
        }
    }
    else {
        Write-Host "  Skipping $($packages.Name). Homebrew is not available." -ForegroundColor Cyan
    }
}

Write-Host "Packages installed successfully!" -ForegroundColor Green
