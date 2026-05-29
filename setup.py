#!/usr/bin/env python3

import os
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
CONFIG_DIR = SCRIPT_DIR / "configs"
ENVIRONMENT_ID = "s4tychpwlg53m7bozmbqs3cvz4"

RESET_COLOR = "\033[0m"
ERROR_COLOR = "\033[91m"
INDENT_COLORS = {
    0: "\033[94m",
    2: "\033[92m",
    4: "\033[90m",
}

BREW_PACKAGES = (
    "anomalyco/tap/opencode",
    "ffmpeg",
    "font-jetbrains-mono-nerd-font",
    "gh",
    "gitkraken-cli",
    "node",
    "oven-sh/bun/bun",
    "starship",
    "uv",
)

AGENT_SKILLS = (
    # Repo, Skill
    ("anthropics/skills", "canvas-design"),
    ("anthropics/skills", "docx"),
    ("anthropics/skills", "frontend-design"),
    ("anthropics/skills", "mcp-builder"),
    ("anthropics/skills", "pdf"),
    ("anthropics/skills", "pptx"),
    ("anthropics/skills", "skill-creator"),
    ("anthropics/skills", "xlsx"),
    ("cloudflare/skills", "agents-sdk"),
    ("cloudflare/skills", "cloudflare-email-service"),
    ("cloudflare/skills", "cloudflare"),
    ("cloudflare/skills", "durable-objects"),
    ("cloudflare/skills", "sandbox-sdk"),
    ("cloudflare/skills", "turnstile-spin"),
    ("cloudflare/skills", "web-perf"),
    ("cloudflare/skills", "workers-best-practices"),
    ("cloudflare/skills", "wrangler"),
    ("coreyhaines31/marketingskills", "copywriting"),
    ("coreyhaines31/marketingskills", "marketing-psychology"),
    ("coreyhaines31/marketingskills", "programmatic-seo"),
    ("coreyhaines31/marketingskills", "seo-audit"),
    ("freshtechbro/claudedesignskills", "animated-component-libraries"),
    ("freshtechbro/claudedesignskills", "animejs"),
    ("freshtechbro/claudedesignskills", "gsap-scrolltrigger"),
    ("freshtechbro/claudedesignskills", "modern-web-design"),
    ("freshtechbro/claudedesignskills", "motion-framer"),
    ("freshtechbro/claudedesignskills", "react-three-fiber"),
    ("freshtechbro/claudedesignskills", "threejs-webgl"),
    ("freshtechbro/claudedesignskills", "web3d-integration-patterns"),
    ("microsoft/playwright-cli", "playwright-cli"),
    ("roboflow/computer-vision-skills", "roboflow-api-reference"),
    ("roboflow/computer-vision-skills", "roboflow-inference"),
    ("shadcn/ui", "shadcn"),
    ("vercel-labs/agent-skills", "vercel-composition-patterns"),
    ("vercel-labs/agent-skills", "vercel-react-best-practices"),
    ("vercel-labs/agent-skills", "vercel-react-native-skills"),
    ("vercel-labs/agent-skills", "vercel-react-view-transitions"),
    ("vercel-labs/agent-skills", "web-design-guidelines"),
    ("vercel-labs/skills", "find-skills"),
)

### Utilities ###


def print_message(message: str, *, stream=sys.stdout, color=None):
    if not stream.isatty():
        print(message, file=stream)
        return

    indent = len(message) - len(message.lstrip())
    print(f"{color or INDENT_COLORS.get(indent, INDENT_COLORS[0])}{message}{RESET_COLOR}", file=stream)


def inject_environment():
    print_message("Injecting environment...")

    op = shutil.which("op")
    if not op:
        raise OSError(
            "1Password CLI is not available. Install the 1Password CLI and authenticate before running setup."
        )

    try:
        result = subprocess.run(
            [op, "environment", "read", ENVIRONMENT_ID],
            check=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as error:
        details = error.stderr.strip()
        if 'unknown command "environment"' in details:
            raise OSError(
                "1Password CLI beta version 2.33.0-beta.02 or newer is required to read 1Password Environments. Install the beta CLI and try again."
            ) from error
        if "authorization timeout" in details:
            raise OSError(
                "1Password authorization timed out. Unlock 1Password and approve the CLI request, then try again."
            ) from error
        raise OSError(f"Failed to read the 1Password Environment: {details}") from error

    for line in result.stdout.splitlines():
        line = line.lstrip()

        if not line or line.startswith("#") or "=" not in line:
            continue

        key, value = (part.strip() for part in line.split("=", 1))

        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1]

        if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", key):
            os.environ[key] = value

    print_message("  Environment injected successfully!")


def replace_environment(path: Path):
    def replace_placeholder(match: re.Match[str]):
        return os.environ.get(match.group(1), match.group(0))

    configuration = re.sub(r"\{env:([^}]+)\}", replace_placeholder, path.read_text(encoding="utf-8"))
    missing_variables = sorted(set(re.findall(r"\{env:([^}]+)\}", configuration)))
    if missing_variables:
        raise OSError("The environment is missing required variables: " + ", ".join(missing_variables))

    return configuration


def run_command(command: list[str]):
    subprocess.run(command, check=True, stdout=subprocess.DEVNULL)


### Packages ###


def install_packages():
    print_message("Installing packages...")

    if not shutil.which("brew"):
        print_message("  Homebrew is not available. Skipping package installation.")
        return

    def is_installed(package: str, cask: bool = False):
        command = ["brew", "list"]
        if cask:
            command.append("--cask")
        command.append(package)

        return (
            subprocess.run(
                command,
                check=False,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            ).returncode
            == 0
        )

    for brew_id in BREW_PACKAGES:
        if is_installed(brew_id):
            print_message(f"  {brew_id} is already installed. Skipping...")
            continue
        run_command(["brew", "install", brew_id])

    print_message("  Packages installed successfully!")


### Configurations ###


def install_tools():
    print_message("  Installing tools...")

    for file in (".editorconfig", ".oxlintrc.json", ".oxfmtrc.json", ".personal"):
        shutil.copy2(CONFIG_DIR / file, Path.home() / file)


def install_agents():
    print_message("  Installing agents...")

    agent_path = Path.home() / ".config" / "opencode"
    agent_path.mkdir(parents=True, exist_ok=True)

    (agent_path / "opencode.json").write_text(
        replace_environment(CONFIG_DIR / "opencode.json"),
        encoding="utf-8",
    )

    instruction_paths = (
        agent_path / "AGENTS.md",
        Path.home() / ".claude" / "CLAUDE.md",
        Path.home() / ".codex" / "AGENTS.md",
    )

    for path in instruction_paths:
        path.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(SCRIPT_DIR / "AGENTS.md", path)


def install_skills():
    bunx = shutil.which("bunx")
    if not bunx:
        print_message("  bunx is not available. Skipping...")
        return

    skills_path = Path.home() / ".agents" / "skills"
    print_message("  Installing skills...")

    for source, skill in AGENT_SKILLS:
        if (skills_path / skill).is_dir():
            print_message(f"    {skill} is already installed. Skipping...")
            continue

        print_message(f"    Installing {skill}...")
        run_command([bunx, "skills", "add", source, "--global", "--skill", skill, "--yes"])


def install_configurations():
    print_message("Installing configurations...")
    install_tools()
    install_agents()
    install_skills()
    print_message("  Configurations installed successfully!")


### Main ###


def main():
    if platform.system() not in {"Darwin", "Linux"}:
        print_message(
            "This setup script supports macOS and Linux only.",
            stream=sys.stderr,
            color=ERROR_COLOR,
        )
        return 1

    try:
        inject_environment()
        install_packages()
        install_configurations()
    except (OSError, subprocess.CalledProcessError) as error:
        print_message(f"Setup failed: {error}", stream=sys.stderr, color=ERROR_COLOR)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
