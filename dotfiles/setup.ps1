Set-Location $PSScriptRoot

Copy-Item -Path ".\.editorconfig" -Destination "$env:USERPROFILE\.editorconfig" -Force