Set-Location $PSScriptRoot

Write-Host "Installing Modules..." -ForegroundColor Yellow

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
        Write-Host "  $module is already installed. Upgrading instead..."
        Update-Module -Name $module -Force -Scope CurrentUser
    }
}

Write-Host "Modules installed successfully!" -ForegroundColor Green
