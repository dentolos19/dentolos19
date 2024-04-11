function ServeFolder {
    Start-Process -FilePath "http://localhost:8000"
    & py -m http.server
}

$historyFile = (Get-PSReadlineOption).HistorySavePath

if (Test-Path $historyFile) {
    Remove-Item -Path $historyFile -Force
}
Set-Alias -Name "serve" -Value ServeFolder