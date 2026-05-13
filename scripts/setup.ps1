Set-Location $PSScriptRoot

function Insert-Env {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [hashtable]$EnvVars = @{},
        [string]$EnvFilePath
    )

    $vars = @{}

    if ($EnvFilePath -and (Test-Path $EnvFilePath)) {
        Get-Content $EnvFilePath | ForEach-Object {
            if ($_ -match '^\s*([^#=]+?)\s*=\s*"?([^"]*?)"?\s*$') {
                $key = $matches[1]
                if (-not $vars.ContainsKey($key)) {
                    $vars[$key] = $matches[2]
                }
            }
        }
    }

    foreach ($key in $EnvVars.Keys) {
        $vars[$key] = $EnvVars[$key]
    }

    $content = Get-Content $Path -Raw
    if (-not $content) {
        return ""
    }

    $pattern = '\$\{env:([^}]+)\}'
    return [regex]::Replace($content, $pattern, {
            param($match)

            $varName = $match.Groups[1].Value

            if ($vars.ContainsKey($varName)) {
                return $vars[$varName]
            }

            $value = [Environment]::GetEnvironmentVariable($varName)
            if ($null -ne $value) {
                return $value
            }

            return $match.Value
        })
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

    $windowsPackages = @(
        @{ Name = "fnm"; Id = "Schniz.fnm" }
        @{ Name = "uv"; Id = "astral-sh.uv" }
        @{ Name = "bun"; Id = "Oven-sh.Bun" }
    )

    $brewPackages = @(
        @{ Name = "fnm"; Id = "fnm" }
        @{ Name = "uv"; Id = "uv" }
        @{ Name = "bun"; Id = "oven-sh/bun/bun" }
        @{ Name = "terraform"; Id = "hashicorp/tap/terraform" }
        @{ Name = "cloudflared"; Id = "cloudflared" }
    )

    if ($IsWindows) {
        foreach ($pkg in $windowsPackages) {
            $output = winget list --id $pkg.Id --exact 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Cyan
                winget install --id $pkg.Id --exact --silent >$null
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
                winget upgrade --id $pkg.Id --exact --silent >$null
            }
        }
    }
    else {
        $hasBrew = $null -ne (Get-Command "brew" -ErrorAction SilentlyContinue)

        if (-not $hasBrew) {
            Write-Host "  Homebrew is not available. Skipping package installation." -ForegroundColor Cyan
            return
        }

        foreach ($pkg in $brewPackages) {
            $output = brew list $($pkg.Id) 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Cyan
                brew install $($pkg.Id) >$null 2>$null
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Upgrading instead..." -ForegroundColor Cyan
                brew upgrade $($pkg.Id) >$null 2>$null
            }
        }
    }

    Write-Host "  Packages installed successfully!" -ForegroundColor Green
}

function Install-Configurations {
    Write-Host "Installing Configurations..." -ForegroundColor Yellow

    $agentsSource = Join-Path $PSScriptRoot ".." "prompts" "opencode"
    $agentsDirectory = Join-Path $HOME ".config" "opencode" "agents"
    $agentsFiles = Get-ChildItem -Path $agentsSource -Filter "*.md"

    if (Test-Path -Path $agentsDirectory) {
        Remove-Item -Path $agentsDirectory -Recurse -Force
    }

    New-Item $agentsDirectory -ItemType Directory -Force | Out-Null

    foreach ($file in $agentsFiles) {
        Write-Host "  Installing $($file.Name)..." -ForegroundColor Cyan
        $agentDestination = Join-Path $agentsDirectory $file.Name
        Copy-Item $file.FullName $agentDestination -Force
    }

    if ($IsWindows) {
        $psDirectory = Join-Path $HOME "Documents" "PowerShell"

        if (-not (Test-Path -Path $psDirectory)) {
            New-Item $psDirectory -ItemType Directory -Force | Out-Null
        }

        $psProfileSource = Join-Path $PSScriptRoot ".." "configs" "powershell.profile.ps1"
        $psProfileDestination = Join-Path $psDirectory "Microsoft.PowerShell_profile.ps1"
        Copy-Item $psProfileSource $psProfileDestination -Force

        $psConfigSource = Join-Path $PSScriptRoot ".." "configs" "powershell.config.json"
        $psConfigDestination = Join-Path $psDirectory "powershell.config.json"
        Copy-Item $psConfigSource $psConfigDestination -Force
    }

    $zedSettingsSource = Join-Path $PSScriptRoot ".." "configs" "zed.jsonc"
    $zedSettingsDestination = Join-Path $HOME ".config" "zed" "settings.json"
    $zedSettingsContent = Insert-Env -Path $zedSettingsSource
    Set-Content -Path $zedSettingsDestination -Value $zedSettingsContent -Force

    $ocSettingsSource = Join-Path $PSScriptRoot ".." "configs" "opencode.json"
    $ocSettingsDestination = Join-Path $HOME ".config" "opencode" "opencode.json"
    $ocSettingsContent = Insert-Env -Path $ocSettingsSource
    Set-Content -Path $ocSettingsDestination -Value $ocSettingsContent -Force

    Write-Host "  Configurations installed successfully!" -ForegroundColor Green
}

Install-Modules
Install-Packages
Install-Configurations
