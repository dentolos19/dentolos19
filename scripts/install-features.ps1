Set-Location $PSScriptRoot

# 1. Check for Administrative Privileges
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    Pause
    Exit
}

# 2. Fetch all available but disabled features
Write-Host "Fetching Windows features, please wait..." -ForegroundColor Cyan
$features = Get-WindowsOptionalFeature -Online | Where-Object { $_.State -eq "Disabled" } | Select-Object FeatureName, Description

# 3. Open a GUI selection window
# Hold CTRL or SHIFT to select multiple features
$selection = $features | Out-GridView -Title "Select Windows Features to Install (Search top right)" -PassThru

# 4. Install selected features
if ($selection) {
    foreach ($item in $selection) {
        Write-Host "Installing: $($item.FeatureName)..." -ForegroundColor Green
        Enable-WindowsOptionalFeature -Online -FeatureName $item.FeatureName -All -NoRestart
    }

    Write-Host "`nProcess Complete." -ForegroundColor Cyan
    $restart = Read-Host "A restart may be required. Restart now? (Y/N)"
    if ($restart -eq "Y") { Restart-Computer }
}
else {
    Write-Host "No features selected. Exiting." -ForegroundColor Yellow
}
