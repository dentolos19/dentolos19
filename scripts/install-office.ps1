# Automatic Office Installer

param(
    [string]$ConfigUrl = "https://raw.githubusercontent.com/dentolos19/dentolos19/refs/heads/main/scripts/office-config.xml",
    [string]$ToolUrl = "https://download.microsoft.com/download/2/7/A/27AF1BE6-DD20-4CB4-B154-EBAB8A7D4A7E/officedeploymenttool_17328-20162.exe"
)

$ErrorActionPreference = "Stop"

# Create temporary directory
$tempPath = Join-Path $env:TEMP "AutomaticOfficeInstaller_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $tempPath -Force | Out-Null

try {
    # Download deployment tool
    Write-Host "Downloading deployment tool..." -ForegroundColor Yellow
    $toolPath = Join-Path $tempPath "deployment.exe"
    Invoke-WebRequest -Uri $ToolUrl -OutFile $toolPath -UseBasicParsing

    # Download configuration file
    Write-Host "Downloading configuration file..." -ForegroundColor Yellow
    $configPath = Join-Path $tempPath "config.xml"
    Invoke-WebRequest -Uri $ConfigUrl -OutFile $configPath -UseBasicParsing

    # Extract deployment tool
    Write-Host "Extracting deployment tool..." -ForegroundColor Yellow
    $extractArgs = "/quiet /extract:`"$tempPath`""
    Start-Process -FilePath $toolPath -ArgumentList $extractArgs -Verb RunAs -Wait | Out-Null

    # Run Office installation
    Write-Host "Starting installation..." -ForegroundColor Yellow
    $setupPath = Join-Path $tempPath "setup.exe"
    Start-Process -FilePath $setupPath -ArgumentList $installArgs -Verb RunAs | Out-Null

    Write-Host "Installation initiated successfully!" -ForegroundColor Green
}
catch {
    Write-Host "An error occurred! $_" -ForegroundColor Red
    exit 1
}
