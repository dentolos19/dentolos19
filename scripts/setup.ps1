& (Join-Path $PSScriptRoot "setup-profiles.ps1")
& (Join-Path $PSScriptRoot "setup-modules.ps1")
& (Join-Path $PSScriptRoot "setup-packages.ps1")
& (Join-Path $PSScriptRoot "setup-configs.ps1")

& $powershellProfileFile

& (Join-Path $PSScriptRoot "setup-agents.ps1")
