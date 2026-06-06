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
            Write-Host "  $module is already installed. Skipping..." -ForegroundColor Cyan
            # Update-Module -Name $module -Force -Scope CurrentUser
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
        @{ Name = "opencode"; Id = "SST.OpenCode" }
        @{ Name = "terraform"; Id = "Hashicorp.Terraform" }
        @{ Name = "cloudflared"; Id = "Cloudflare.cloudflared" },
        @{ Name = "ffmpeg"; Id = "Gyan.FFmpeg" },
        @{ Name = "starship"; Id = "Starship.Starship" }
        @{ Name = "nerdfont"; Id = "DEVCOM.JetBrainsMonoNerdFont" }
    )

    $brewPackages = @(
        @{ Name = "fnm"; Id = "fnm"; Type = "formula" }
        @{ Name = "uv"; Id = "uv"; Type = "formula" }
        @{ Name = "bun"; Id = "oven-sh/bun/bun"; Type = "formula" }
        @{ Name = "opencode"; Id = "anomalyco/tap/opencode"; Type = "formula" }
        @{ Name = "terraform"; Id = "hashicorp/tap/terraform"; Type = "formula" }
        @{ Name = "cloudflared"; Id = "cloudflared"; Type = "formula" }
        @{ Name = "ffmpeg"; Id = "ffmpeg"; Type = "formula" }
        @{ Name = "starship"; Id = "starship"; Type = "formula" }
        @{ Name = "nerdfont"; Id = "font-jetbrains-mono-nerd-font"; Type = "cask" }
    )

    if ($IsWindows) {
        foreach ($pkg in $windowsPackages) {
            $output = winget list --id $pkg.Id --exact 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing $($pkg.Name)..." -ForegroundColor Cyan
                winget install --id $pkg.Id --exact --silent >$null
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Skipping..." -ForegroundColor Cyan
                # winget upgrade --id $pkg.Id --exact --silent >$null
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
            $brewFlags = @()
            if ($pkg.Type -eq "cask") {
                $brewFlags += "--cask"
            }

            $output = brew list @brewFlags $($pkg.Id) 2>$null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  Installing package $($pkg.Name)..." -ForegroundColor Cyan
                brew install @brewFlags $($pkg.Id) >$null
            }
            else {
                Write-Host "  $($pkg.Name) is already installed. Skipping..." -ForegroundColor Cyan
                # brew upgrade @brewFlags $($pkg.Id) >$null
            }
        }
    }

    Write-Host "  Packages installed successfully!" -ForegroundColor Green
}

function Install-Configurations {
    Write-Host "Installing Configurations..." -ForegroundColor Yellow

    function Install-ShellConfig {
        if ($IsWindows) {
            $psDirectory = Join-Path $HOME "Documents" "PowerShell"

            if (-not (Test-Path -Path $psDirectory)) {
                New-Item $psDirectory -ItemType Directory -Force | Out-Null
            }

            Write-Host "  Installing shell configurations..." -ForegroundColor Cyan

            $psProfileSource = Join-Path $PSScriptRoot ".." "configs" "powershell" "powershell.profile.ps1"
            $psProfileDestination = Join-Path $psDirectory "Microsoft.PowerShell_profile.ps1"
            Copy-Item $psProfileSource $psProfileDestination -Force

            $psConfigSource = Join-Path $PSScriptRoot ".." "configs" "powershell" "powershell.config.json"
            $psConfigDestination = Join-Path $psDirectory "powershell.config.json"
            Copy-Item $psConfigSource $psConfigDestination -Force
        }
        elseif ($IsMacOS) {
            Write-Host "  You are on macOS. Skipping..." -ForegroundColor Cyan
        }
        elseif ($IsLinux) {
            Write-Host "  You are on Linux. Skipping..." -ForegroundColor Cyan
        }
        else {
            Write-Host "  You are on an unsupported OS. Skipping..." -ForegroundColor Cyan
        }
    }

    function Install-ToolConfig {
        Write-Host "  Installing tool configurations..." -ForegroundColor Cyan

        # .editorconfig
        Copy-Item `
            -Path (Join-Path $PSScriptRoot ".." "configs" "tools" "default.editorconfig") `
            -Destination (Join-Path $HOME ".editorconfig") `
            -Recurse -Force

        # biome.json
        Copy-Item `
            -Path (Join-Path $PSScriptRoot ".." "configs" "tools" "biome.json") `
            -Destination (Join-Path $HOME "biome.json") `
            -Recurse -Force

        # config.ghostty
        Copy-Item `
            -Path (Join-Path $PSScriptRoot ".." "configs" "tools" "config.ghostty") `
            -Destination (Join-Path $HOME ".config" "ghostty" "config.ghostty") `
            -Recurse -Force

        # $zedSettingsSource = Join-Path $PSScriptRoot ".." "configs" "tools" "zed.jsonc"
        # $zedSettingsDestination = Join-Path $HOME ".config" "zed" "settings.json"
        # $zedSettingsContent = Insert-Env -Path $zedSettingsSource
        # Set-Content -Path $zedSettingsDestination -Value $zedSettingsContent -Force
    }

    function Install-AgentConfig {
        $ocSettingsSource = Join-Path $PSScriptRoot ".." "configs" "opencode" "opencode.json"
        $ocSettingsDestination = Join-Path $HOME ".config" "opencode" "opencode.json"
        $ocSettingsContent = Insert-Env -Path $ocSettingsSource
        Set-Content -Path $ocSettingsDestination -Value $ocSettingsContent -Force

        $agentsSource = Join-Path $PSScriptRoot ".." "configs" "opencode" "agents"
        $agentsDirectory = Join-Path $HOME ".config" "opencode" "agents"
        $agentsFiles = Get-ChildItem -Path $agentsSource -Filter "*.md"

        $instructionsSource = Join-Path $PSScriptRoot ".." "configs" "opencode" "instructions"
        $instructionsDirectory = Join-Path $HOME ".config" "opencode" "instructions"
        $instructionsFiles = Get-ChildItem -Path $instructionsSource -Filter "*.md"

        if (Test-Path -Path $agentsDirectory) {
            Remove-Item -Path $agentsDirectory -Recurse -Force
        }

        if (Test-Path -Path $instructionsDirectory) {
            Remove-Item -Path $instructionsDirectory -Recurse -Force
        }

        New-Item $agentsDirectory -ItemType Directory -Force | Out-Null
        New-Item $instructionsDirectory -ItemType Directory -Force | Out-Null

        foreach ($file in $agentsFiles) {
            $fileName = [System.IO.Path]::GetFileName($file.Name)
            Write-Host "  Installing agent $fileName..." -ForegroundColor Cyan
            $agentDestination = Join-Path $agentsDirectory $fileName
            Copy-Item $file.FullName $agentDestination -Force
        }

        foreach ($file in $instructionsFiles) {
            $fileName = [System.IO.Path]::GetFileName($file.Name)
            Write-Host "  Installing instruction $fileName..." -ForegroundColor Cyan
            $instructionDestination = Join-Path $instructionsDirectory $fileName
            Copy-Item $file.FullName $instructionDestination -Force
        }
    }

    function Install-AgentSkills {
        $agentSkills = @(
            @{
                Source = "vercel-labs/skills";
                Skills = @(
                    "find-skills"
                )
            }
            @{
                Source = "vercel-labs/agent-skills";
                Skills = @(
                    "vercel-composition-patterns",
                    "vercel-react-best-practices",
                    "vercel-react-native-skills",
                    "vercel-react-view-transitions",
                    "web-design-guidelines"
                )
            }
            @{
                Source = "anthropics/skills";
                Skills = @(
                    "canvas-design",
                    "frontend-design",
                    "mcp-builder",
                    "skill-creator"
                )
            }
            @{
                Source = "shadcn/ui";
                Skills = @(
                    "shadcn"
                )
            }
            @{
                Source = "expo/skills";
                Skills = @(
                    "building-native-ui",
                    "expo-module",
                    "native-data-fetching",
                    "upgrading-expo"
                )
            }
            @{
                Source = "cloudflare/skills";
                Skills = @(
                    "cloudflare",
                    "durable-objects",
                    "workers-best-practices",
                    "wrangler"
                )
            }
            @{
                Source = "aws/agent-toolkit-for-aws";
                Skills = @(
                    "aws-cdk",
                    "aws-iam"
                )
            }
        )

        if (-not (Get-Command "bunx" -ErrorAction SilentlyContinue)) {
            Write-Host "  bunx is not available. Skipping agent skills installation." -ForegroundColor Cyan
        }
        else {
            foreach ($entry in $agentSkills) {
                Write-Host "  Installing skills from $($entry.Source)..." -ForegroundColor Cyan
                bunx skills add $entry.Source --global --skill $entry.Skills --yes >$null
            }
        }
    }

    Install-ShellConfig
    Install-ToolConfig
    Install-AgentConfig
    Install-AgentSkills

    Write-Host "  Configurations installed successfully!" -ForegroundColor Green
}

Install-Modules
Install-Packages
Install-Configurations
