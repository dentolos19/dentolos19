Set-Location $PSScriptRoot

Write-Host "Adding Skills..." -ForegroundColor Yellow

$skills = @(
    @{repo = "https://github.com/vercel-labs/skills"; skill = "find-skills" },
    @{repo = "https://github.com/vercel-labs/agent-skills"; skill = "vercel-react-best-practices" },
    @{repo = "https://github.com/vercel-labs/agent-skills"; skill = "web-design-guidelines" },
    @{repo = "https://github.com/shadcn/ui"; skill = "shadcn" },
    @{repo = "https://github.com/wshobson/agents"; skill = "tailwind-design-system" }
)

foreach ($skillItem in $skills) {
    Write-Host "  Installing $($skillItem.skill) from $($skillItem.repo)..."
    & bunx --bun skills add $skillItem.repo --skill $skillItem.skill --global --yes --agent github-copilot antigravity opencode >$null
}

Write-Host "Skills added successfully!" -ForegroundColor Green
