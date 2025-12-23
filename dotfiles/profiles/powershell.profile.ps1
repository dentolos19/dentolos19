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

function OpenFolder {
    Start-Process "explorer.exe" .
}

Set-Alias "battery" -Value BatteryReport
Set-Alias "forget" -Value ClearHistory
Set-Alias "open" -Value OpenFolder

$env:COREPACK_ENABLE_AUTO_PIN = "0"

& fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
