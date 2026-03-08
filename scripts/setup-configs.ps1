Set-Location $PSScriptRoot

Write-Host "Installing Configurations..." -ForegroundColor Yellow

$geminiInstructionFile = (Join-Path $env:USERPROFILE ".gemini\GEMINI.md")
$copilotInstructionFile = (Join-Path $env:USERPROFILE "AppData\Roaming\Code\User\prompts\personal.instructions.md")

Copy-Item "../.editorconfig" (Join-Path $env:USERPROFILE ".editorconfig")
Copy-Item "../configs/instructions.md" $geminiInstructionFile
Copy-Item "../configs/instructions.md" $copilotInstructionFile

"---`ndescription: Personal Instructions`n---`n`n" + (Get-Content $copilotInstructionFile -Raw) | Set-Content $copilotInstructionFile

Write-Host "Configurations installed successfully!" -ForegroundColor Green
