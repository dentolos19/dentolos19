Set-Location $PSScriptRoot

function Install-Profiles {
    Write-Host "Installing Profiles..." -ForegroundColor Yellow

    if (-not $IsWindows) {
        Write-Host "  Skipping profile setup. You are not on Windows." -ForegroundColor Cyan
        return
    }

    $powershellProfileDir = Join-Path $HOME "Documents\PowerShell"
    if (-not (Test-Path -Path $powershellProfileDir)) {
        New-Item $powershellProfileDir -ItemType Directory -Force | Out-Null
    }

    $profileSource = Join-Path $PSScriptRoot ".." "configs" "powershell.profile.ps1"
    $profileDest = Join-Path $powershellProfileDir "Microsoft.PowerShell_profile.ps1"
    if (Test-Path $profileSource) {
        Copy-Item $profileSource $profileDest -Force
    }

    $configSource = Join-Path $PSScriptRoot ".." "configs" "powershell.config.json"
    $configDest = Join-Path $powershellProfileDir "powershell.config.json"
    if (Test-Path $configSource) {
        Copy-Item $configSource $configDest -Force
    }

    Write-Host "Profiles installed successfully!" -ForegroundColor Green
}

function Install-Modules {
    Write-Host "Installing Modules..." -ForegroundColor Yellow

    if (-not $IsWindows) {
        Write-Host "  Skipping module installation. You are not on Windows." -ForegroundColor Cyan
        return
    }

    $modules = @(
        "Microsoft.WinGet.Client",
        "Microsoft.WinGet.CommandNotFound"
    )

    foreach ($module in $modules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            Write-Host "  Installing $module..." -ForegroundColor Cyan
            Install-Module -Name $module -Force -AllowClobber -Scope CurrentUser
        }
        else {
            Write-Host "  $module is already installed. Upgrading instead..." -ForegroundColor Cyan
            Update-Module -Name $module -Force -Scope CurrentUser
        }
    }

    Write-Host "Modules installed successfully!" -ForegroundColor Green
}

function Install-Packages {
    Write-Host "Installing Packages..." -ForegroundColor Yellow

    $hasBrew = $null -ne (Get-Command "brew" -ErrorAction SilentlyContinue)

    $packages = @(
        @{ Name = "fnm"; WinId = "Schniz.fnm"; BrewId = "fnm" }
        @{ Name = "uv"; WinId = "astral-sh.uv"; BrewId = "uv" }
        @{ Name = "bun"; WinId = "Oven-sh.Bun"; BrewId = "bun" }
    )

    foreach ($pkg in $packages) {
        if ($IsWindows) {
            $output = winget list --id $pkg.WinId --exact 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Cyan
                winget install --id $pkg.WinId --exact --silent >$null
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
                winget upgrade --id $pkg.WinId --exact --silent >$null
            }
        }
        elseif ($hasBrew -and $pkg.BrewId) {
            $installed = brew list $($pkg.BrewId) 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Cyan
                brew install $($pkg.BrewId)
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
                brew upgrade $($pkg.BrewId)
            }
        }
        else {
            Write-Host "  Skipping $($pkg.Name). Homebrew is not available." -ForegroundColor Cyan
        }
    }

    Write-Host "Packages installed successfully!" -ForegroundColor Green
}

function Install-Agents {
    Write-Host "Installing Agents..." -ForegroundColor Yellow

    $agentSourceDir = Join-Path $PSScriptRoot ".." "prompts" "opencode"
    $agentDestDir = Join-Path $HOME ".config" "opencode" "agents"

    if (-not (Test-Path -Path $agentDestDir)) {
        New-Item $agentDestDir -ItemType Directory -Force | Out-Null
    }

    $agentFiles = Get-ChildItem -Path $agentSourceDir -Filter "*.md"
    foreach ($file in $agentFiles) {
        $dest = Join-Path $agentDestDir $file.Name
        Copy-Item $file.FullName $dest -Force
        Write-Host "  Installed $($file.Name)..." -ForegroundColor Cyan
    }

    Write-Host "Agents installed successfully!" -ForegroundColor Green
}

function Setup-Windows {
    Install-Profiles
    Install-Modules
    Install-Packages
    Install-Agents
}

function Setup-Linux {
    Install-Agents
}

function Setup-Mac {
    Install-Agents
}

function Setup-Environment {
    if ($IsWindows) {
        Setup-Windows
    }
    elseif ($IsLinux) {
        Setup-Linux
    }
    elseif ($IsMacOS) {
        Setup-Mac
    }
    else {
        Write-Host "Unsupported operating system. Please set up manually." -ForegroundColor Red
    }
}

Setup-Environment
