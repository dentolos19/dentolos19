Set-Location $PSScriptRoot

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as an Administrator!"
    Pause
    Exit
}

Repair-WindowsImage -Online -CheckHealth
Repair-WindowsImage -Online -ScanHealth
Repair-WindowsImage -Online -RestoreHealth
