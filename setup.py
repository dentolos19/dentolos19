#!/usr/bin/env python3

import json
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


def print_message(message: str, *, indent_size: int = 0, stream=sys.stdout, color=None):
    message = f"{' ' * indent_size}{message}"

    if not stream.isatty():
        print(message, file=stream)
        return

    print(f"{color or INDENT_COLORS.get(indent_size, INDENT_COLORS[0])}{message}{RESET_COLOR}", file=stream)


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

    print_message("Environment injected successfully!", indent_size=2)


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
        print_message("Homebrew is not available. Skipping package installation.", indent_size=2)
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
            print_message(f"{brew_id} is already installed. Skipping...", indent_size=2)
            continue
        run_command(["brew", "install", brew_id])

    print_message("Packages installed successfully!", indent_size=2)


### Configurations ###


def install_tools():
    print_message("Installing tools...", indent_size=2)

    home_path = Path.home()

    for file in (".editorconfig", ".oxlintrc.json", ".oxfmtrc.json", ".personal"):
        shutil.copy2(CONFIG_DIR / file, home_path / file)


def install_codex():
    print_message("Installing Codex...", indent_size=2)

    codex_home = Path.home() / ".codex"
    codex_home.mkdir(parents=True, exist_ok=True)

    shutil.copy2(SCRIPT_DIR / "AGENTS.md", codex_home / "AGENTS.md")
    (codex_home / "config.toml").write_text(
        replace_environment(CONFIG_DIR / "codex.toml"),
        encoding="utf-8",
    )


def install_skills():
    bun = shutil.which("bun")
    if not bun:
        print_message("Bun is not available. Skipping...", indent_size=2)
        return

    print_message("Installing skills...", indent_size=2)
    print_message("Updating skills CLI...", indent_size=4)
    run_command([bun, "add", "--global", "skills@latest"])

    skills = shutil.which("skills")
    if not skills:
        raise OSError("The skills CLI is not available after installation.")

    try:
        installed_skills = {
            entry["name"]
            for entry in json.loads(
                subprocess.run(
                    [skills, "list", "--global", "--agent", "codex", "--json"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout
            )
            if isinstance(entry, dict) and isinstance(entry.get("name"), str)
        }
    except json.JSONDecodeError as error:
        raise OSError("Failed to read installed skills from the skills CLI.") from error

    for source, skill in AGENT_SKILLS:
        if skill in installed_skills:
            print_message(f"{skill} is already installed. Skipping...", indent_size=4)
            continue

        print_message(f"Installing {skill}...", indent_size=4)
        run_command([skills, "add", source, "--global", "--agent", "codex", "--skill", skill, "--yes"])

    local_skills_path = SCRIPT_DIR / "skills"
    agent_skill_paths = (
        Path.home() / ".agents" / "skills",
        Path.home() / ".codex" / "skills",
    )

    for skill_path in local_skills_path.iterdir():
        if not skill_path.is_dir() or not (skill_path / "SKILL.md").is_file():
            continue

        target_paths = tuple(agent_skill_path / skill_path.name for agent_skill_path in agent_skill_paths)

        for agent_skill_path in agent_skill_paths:
            agent_skill_path.mkdir(parents=True, exist_ok=True)

        if all(
            target_path.is_symlink() and target_path.resolve() == skill_path.resolve()
            for target_path in target_paths
        ):
            print_message(f"{skill_path.name} is already installed. Skipping...", indent_size=4)
            continue

        print_message(f"Installing {skill_path.name} (local)...", indent_size=4)

        for target_path in target_paths:
            if target_path.is_symlink():
                if target_path.resolve() == skill_path.resolve():
                    continue
                target_path.unlink()
            elif target_path.exists():
                raise OSError(
                    f"Cannot install {skill_path.name}: {target_path} exists but is not linked to the local skill."
                )

            target_path.symlink_to(skill_path, target_is_directory=True)


def install_configurations():
    print_message("Installing configurations...")
    install_tools()
    install_codex()
    install_skills()
    print_message("Configurations installed successfully!", indent_size=2)


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
