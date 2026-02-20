function AdminMode {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Start-Process wt -ArgumentList "pwsh", "-NoExit", "-Command", "Set-Location '$PWD'" -Verb RunAs
        exit
    }
    else {
        Write-Host "Already running as administrator."
    }
}

function OpenFolder {
    Start-Process "explorer.exe" .
}

function BatteryReport {
    $outputFile = (Join-Path $env:TEMP "batteryreport.html")
    & powercfg /batteryreport /output $outputFile
    Start-Process $outputFile
}

function ClearHistory {
    $historyFile = (Get-PSReadlineOption).HistorySavePath

    if (Test-Path $historyFile) {
        Remove-Item $historyFile
    }

    Clear-History
    Write-Host "Your command history has been cleared, please restart your shell!"
}


function CleanSystem {
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    $deletedItems = 0
    $failedPaths = @()

    $cleanupTargets = @(
        # Windows Files
        $env:TEMP,
        (Join-Path $env:LOCALAPPDATA "Temp"),
        (Join-Path $env:LOCALAPPDATA "Microsoft\Windows\INetCache"),
        (Join-Path $env:LOCALAPPDATA "Microsoft\Windows\Explorer"),

        # Application Files
        # (Join-Path $env:USERPROFILE ".copilot\session-state"),
        # (Join-Path $env:APPDATA "Code\User\workspaceStorage"),

        # Miscellaneous Files
        (Get-PSReadlineOption).HistorySavePath
    )

    if ($isAdmin) {
        $cleanupTargets += @(
            # System Files
            (Join-Path $env:WINDIR "Temp"),
            (Join-Path $env:WINDIR "SoftwareDistribution\Download")
        )
    }

    foreach ($target in ($cleanupTargets | Select-Object -Unique)) {
        if (-not (Test-Path $target)) {
            continue
        }

        try {
            $items = Get-ChildItem -Path $target -Force -ErrorAction SilentlyContinue
            foreach ($item in $items) {
                try {
                    Remove-Item -Path $item.FullName -Recurse -Force -ErrorAction Stop
                    $deletedItems++
                }
                catch {
                }
            }
        }
        catch {
            $failedPaths += $target
        }
    }

    if (Get-Command Clear-RecycleBin -ErrorAction SilentlyContinue) {
        try {
            Clear-RecycleBin -Force -ErrorAction Stop | Out-Null
        }
        catch {
            $failedPaths += "Recycle Bin"
        }
    }

    Write-Host "System cleanup complete. Removed $deletedItems item(s)."

    if (-not $isAdmin) {
        Write-Host "Tip: Run 'admin' first to clean system-wide temporary files as well."
    }

    if ($failedPaths.Count -gt 0) {
        $failedList = ($failedPaths | Select-Object -Unique) -join ", "
        Write-Host "Could not fully clean: $failedList"
    }
}

Set-Alias "admin" -Value AdminMode
Set-Alias "open" -Value OpenFolder
Set-Alias "battery" -Value BatteryReport
Set-Alias "forget" -Value ClearHistory
Set-Alias "clean" -Value CleanSystem

$env:COREPACK_ENABLE_AUTO_PIN = "0"

& fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression

Import-Module -Name Microsoft.WinGet.CommandNotFound
