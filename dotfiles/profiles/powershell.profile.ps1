function ServeFolder {
    Start-Process "http://localhost:8000"
    & py -m http.server
}

function BatteryReport() {
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

Set-Alias -Name "sf" -Value ServeFolder
Set-Alias -Name "br" -Value BatteryReport
Set-Alias -Name "cch" -Value ClearHistory