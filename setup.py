#!/usr/bin/env python3

import json
import os
import platform
import re
import shlex
import shutil
import subprocess
import sys
from pathlib import Path

SCRIPT_PATH = Path(__file__).resolve().parent
CONFIG_PATH = SCRIPT_PATH / "configs"
ENVIRONMENT_ID = "s4tychpwlg53m7bozmbqs3cvz4"
HOMEBREW_INSTALL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"

RESET_COLOR = "\033[0m"
HEADING_COLOR = "\033[1;36m"
ACTION_COLOR = "\033[94m"
SUCCESS_COLOR = "\033[92m"
WARNING_COLOR = "\033[93m"
MUTED_COLOR = "\033[90m"
ERROR_COLOR = "\033[91m"
INDENT_COLORS = {
    0: HEADING_COLOR,
    2: ACTION_COLOR,
    4: MUTED_COLOR,
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

AGENT_SKILLS = {
    "anthropics/skills": (
        "canvas-design",
        "docx",
        "frontend-design",
        "mcp-builder",
        "pdf",
        "pptx",
        "skill-creator",
        "xlsx",
    ),
    "cloudflare/skills": (
        "agents-sdk",
        "cloudflare-email-service",
        "cloudflare",
        "durable-objects",
        "turnstile-spin",
        "web-perf",
        "workers-best-practices",
        "wrangler",
    ),
    "coreyhaines31/marketingskills": (
        "copywriting",
        "marketing-psychology",
        "programmatic-seo",
        "seo-audit",
    ),
    "freshtechbro/claudedesignskills": (
        "animated-component-libraries",
        "animejs",
        "gsap-scrolltrigger",
        "modern-web-design",
        "motion-framer",
        "react-three-fiber",
        "threejs-webgl",
        "web3d-integration-patterns",
    ),
    "microsoft/playwright-cli": ("playwright-cli",),
    "roboflow/computer-vision-skills": ("roboflow-api-reference", "roboflow-inference"),
    "shadcn/ui": ("shadcn",),
    "vercel-labs/agent-skills": (
        "vercel-composition-patterns",
        "vercel-react-best-practices",
        "vercel-react-native-skills",
        "vercel-react-view-transitions",
        "web-design-guidelines",
    ),
    "vercel-labs/skills": ("find-skills",),
}

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

    print_message("Environment injected successfully!", indent_size=2, color=SUCCESS_COLOR)


def replace_environment(path: Path):
    def replace_placeholder(match: re.Match[str]):
        return os.environ.get(match.group(1), match.group(0))

    configuration = re.sub(r"\{env:([^}]+)\}", replace_placeholder, path.read_text(encoding="utf-8"))
    missing_variables = sorted(set(re.findall(r"\{env:([^}]+)\}", configuration)))
    if missing_variables:
        raise OSError("The environment is missing required variables: " + ", ".join(missing_variables))

    return configuration


def copy_configuration(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(replace_environment(source), encoding="utf-8")
    target.chmod(0o600)


def get_homebrew():
    brew = shutil.which("brew")
    if brew:
        return brew

    brew_paths = {
        "Darwin": (Path("/opt/homebrew/bin/brew"), Path("/usr/local/bin/brew")),
        "Linux": (Path("/home/linuxbrew/.linuxbrew/bin/brew"),),
    }
    for brew_path in brew_paths[platform.system()]:
        if brew_path.is_file():
            os.environ["PATH"] = f"{brew_path.parent}{os.pathsep}{os.environ.get('PATH', '')}"
            return str(brew_path)

    print_message("Homebrew is not installed. Installing...", indent_size=2, color=WARNING_COLOR)

    bash = shutil.which("bash")
    curl = shutil.which("curl")
    if not bash or not curl:
        raise OSError("Bash and curl are required to install Homebrew.")

    install_command = f'exec {shlex.quote(bash)} -c "$({shlex.quote(curl)} -fsSL {shlex.quote(HOMEBREW_INSTALL)})"'
    subprocess.run([bash, "-c", install_command], check=True)

    for brew_path in brew_paths[platform.system()]:
        if brew_path.is_file():
            os.environ["PATH"] = f"{brew_path.parent}{os.pathsep}{os.environ.get('PATH', '')}"
            print_message("Homebrew installed successfully!", indent_size=2, color=SUCCESS_COLOR)
            return str(brew_path)

    raise OSError("Homebrew installation completed, but the brew executable could not be found.")


def run_command(command: list[str]):
    subprocess.run(command, check=True, stdout=subprocess.DEVNULL)


def link_file(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_symlink() and target.resolve() == source.resolve():
        return
    if target.is_dir():
        raise OSError(f"Cannot link {source}: {target} is a directory.")

    target.unlink(missing_ok=True)
    target.symlink_to(source)


### Packages ###


def install_packages():
    print_message("Installing packages...")

    brew = get_homebrew()

    installed_packages = set(
        subprocess.run(
            [brew, "list", "--full-name"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout.split()
    )

    for package in BREW_PACKAGES:
        if package in installed_packages:
            print_message(f"{package} is already installed. Skipping...", indent_size=2, color=MUTED_COLOR)
            continue

        print_message(f"Installing {package}...", indent_size=2)
        run_command([brew, "install", package])

    print_message("Packages installed successfully!", indent_size=2, color=SUCCESS_COLOR)


def install_skills():
    bun = shutil.which("bun")
    if not bun:
        print_message("Bun is not available. Skipping...", indent_size=2, color=WARNING_COLOR)
        return

    print_message("Installing skills...", indent_size=2)
    print_message("Updating skills CLI...", indent_size=4)
    run_command([bun, "add", "--global", "skills@latest"])

    skills = shutil.which("skills")
    if not skills:
        raise OSError("The skills CLI is not available after installation.")

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
    }

    for source, source_skills in AGENT_SKILLS.items():
        for skill in source_skills:
            if skill in installed_skills:
                print_message(f"{skill} is already installed. Skipping...", indent_size=4, color=MUTED_COLOR)
                continue

            print_message(f"Installing {skill}...", indent_size=4)
            run_command([skills, "add", source, "--global", "--agent", "codex", "--skill", skill, "--yes"])

    skill_paths = (
        Path.home() / ".agents" / "skills",
        Path.home() / ".codex" / "skills",
    )
    for path in skill_paths:
        path.mkdir(parents=True, exist_ok=True)

    for skill_path in (SCRIPT_PATH / "skills").iterdir():
        if not skill_path.is_dir() or not (skill_path / "SKILL.md").is_file():
            continue

        target_paths = tuple(path / skill_path.name for path in skill_paths)
        if all(target.is_symlink() and target.resolve() == skill_path.resolve() for target in target_paths):
            print_message(
                f"{skill_path.name} is already installed. Skipping...",
                indent_size=4,
                color=MUTED_COLOR,
            )
            continue

        print_message(f"Installing {skill_path.name} (local)...", indent_size=4)

        for target_path in target_paths:
            if target_path.is_symlink() and target_path.resolve() == skill_path.resolve():
                continue
            if target_path.exists() and not target_path.is_symlink():
                raise OSError(
                    f"Cannot install {skill_path.name}: {target_path} exists but is not linked to the local skill."
                )

            target_path.unlink(missing_ok=True)
            target_path.symlink_to(skill_path, target_is_directory=True)


def install_configurations():
    print_message("Installing configurations...")

    home_path = Path.home()

    print_message("Installing tools...", indent_size=2)
    for file in (".editorconfig", ".oxlintrc.json", ".oxfmtrc.json", ".personal"):
        link_file(CONFIG_PATH / file, home_path / file)

    print_message("Installing Codex config...", indent_size=2)
    shutil.copytree(CONFIG_PATH / "codex", home_path / ".codex", dirs_exist_ok=True)

    print_message("Installing OpenCode config...", indent_size=2)
    copy_configuration(CONFIG_PATH / "opencode.json", home_path / ".config" / "opencode" / "opencode.json")

    install_skills()
    print_message("Configurations installed successfully!", indent_size=2, color=SUCCESS_COLOR)


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
