function ServeFolder {
    py -m http.server
}

$historyFile = (Get-PSReadlineOption).HistorySavePath

if (Test-Path $historyFile) {
    Remove-Item -Path $historyFile -Force
}

Set-Alias -Name "serve" -Value ServeFolder