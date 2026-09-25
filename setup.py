# /// script
# dependencies = ["onepassword-sdk", "tomlkit"]
# ///

import argparse
import asyncio
import json
import os
import platform
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
from collections.abc import MutableMapping
from pathlib import Path

import tomlkit
from onepassword import Client, DesktopAuth

SCRIPT_PATH = Path(__file__).resolve().parent
CONFIG_PATH = SCRIPT_PATH / "configs"
HOMEBREW_INSTALL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
ENVIRONMENT_ID = "s4tychpwlg53m7bozmbqs3cvz4"

RESET_COLOR = "\033[0m"
HEADING_COLOR = "\033[1;36m"
ACTION_COLOR = "\033[94m"
GROUP_COLOR = "\033[95m"
MUTED_COLOR = "\033[90m"
SUCCESS_COLOR = "\033[92m"
WARNING_COLOR = "\033[93m"
ERROR_COLOR = "\033[91m"

INDENT_COLORS = {
    0: HEADING_COLOR,
    2: ACTION_COLOR,
    4: GROUP_COLOR,
    6: MUTED_COLOR,
}

BREW_PACKAGES = (
    "claude-code",
    "codex",
    "ffmpeg",
    "font-jetbrains-mono-nerd-font",
    "gh",
    "gitkraken-cli",
    "just-lsp",
    "just",
    "node",
    "oven-sh/bun/bun",
    "starship",
    "uv",
)

BUN_PACKAGES = ("skills",)

AGENT_SKILLS = {
    "anthropics/skills": ("frontend-design", "skill-creator", "webapp-testing"),
    "cloudflare/skills": ("cloudflare", "wrangler", "web-perf", "workers-best-practices"),
    "vercel-labs/agent-skills": (
        "vercel-composition-patterns",
        "vercel-react-best-practices",
        "vercel-react-view-transitions",
        "web-design-guidelines",
    ),
    "Leonxlnx/taste-skill": (
        "design-taste-frontend",
        "full-output-enforcement",
        "gpt-taste",
        "image-to-code",
        "redesign-existing-projects",
    ),
    "effect-ts/skills": ("effect-ts",),
    "heygen-com/hyperframes": ("hyperframes",),
    "microsoft/playwright-cli": ("playwright-cli",),
    "shadcn-ui/ui": ("shadcn",),
    "typesafe-ai/skills": ("typesafe-ai",),
}

### Utilities ###


def print_message(message: str, *, indent_size: int = 0, stream=sys.stdout, color=None):
    message = f"{' ' * indent_size}{message}"

    if not stream.isatty() and os.environ.get("FORCE_COLOR") != "1":
        print(message, file=stream)
        return

    print(f"{color or INDENT_COLORS.get(indent_size, INDENT_COLORS[0])}{message}{RESET_COLOR}", file=stream)


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


def merge_values(destination: MutableMapping, updates: MutableMapping):
    for key, value in updates.items():
        if key in destination and isinstance(destination[key], MutableMapping) and isinstance(value, MutableMapping):
            merge_values(destination[key], value)
        else:
            destination[key] = value


def merge_toml(source: Path, target: Path):
    desired = tomlkit.parse(replace_environment(source))
    current = tomlkit.parse(target.read_text(encoding="utf-8")) if target.is_file() else tomlkit.document()
    merge_values(current, desired)
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(tomlkit.dumps(current), encoding="utf-8")
    target.chmod(0o600)


def merge_json(updates: MutableMapping, target: Path):
    current = json.loads(target.read_text(encoding="utf-8")) if target.is_file() else {}
    merge_values(current, updates)
    target.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=target.parent, delete=False) as file:
        temporary_path = Path(file.name)
        json.dump(current, file, indent=2)
        file.write("\n")
    try:
        temporary_path.chmod(0o600)
        temporary_path.replace(target)
    finally:
        temporary_path.unlink(missing_ok=True)


def merge_gitkraken():
    gitkraken_path = Path.home() / ".gitkraken"
    config_path = gitkraken_path / "config"
    if not config_path.is_file():
        print_message("GitKraken is not initialized; skipping its configuration.", indent_size=4)
        return

    desired = json.loads(replace_environment(CONFIG_PATH / "gitkraken.json"))
    if platform.system() == "Darwin":
        merge_values(desired, json.loads(replace_environment(CONFIG_PATH / "gitkraken.macos.json")))
    elif platform.system() == "Linux":
        merge_values(desired, json.loads(replace_environment(CONFIG_PATH / "gitkraken.linux.json")))

    profiles = desired.pop("profiles", {})
    matched_profiles = set()
    profile_updates = []
    for path in (gitkraken_path / "profiles").glob("*/profile"):
        profile = json.loads(path.read_text(encoding="utf-8"))
        if profile.get("profileName") in profiles:
            profile_updates.append((path, profiles[profile["profileName"]]))
            matched_profiles.add(profile["profileName"])

    for name in profiles.keys() - matched_profiles:
        print_message(f"GitKraken profile {name} is not initialized; skipping it.", indent_size=4)

    merge_json(desired, config_path)
    for path, updates in profile_updates:
        merge_json(updates, path)


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
    subprocess.run(command, check=True, stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)


def copy_file(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_dir():
        raise OSError(f"Cannot copy {source}: {target} is a directory.")

    target.unlink(missing_ok=True)
    shutil.copy2(source, target)


def remove_path(path: Path):
    if path.is_symlink() or not path.is_dir():
        path.unlink(missing_ok=True)
        return

    shutil.rmtree(path)


def copy_tree(source: Path, target: Path, *, dirs_exist_ok: bool = False, ignore=None):
    target.parent.mkdir(parents=True, exist_ok=True)

    if dirs_exist_ok:
        if target.is_symlink():
            target.unlink()
        elif target.exists() and not target.is_dir():
            raise OSError(f"Cannot copy {source}: {target} is not a directory.")
    else:
        remove_path(target)

    shutil.copytree(source, target, dirs_exist_ok=dirs_exist_ok, ignore=ignore)


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
        print_message(f"Installing {package}...", indent_size=2)
        if package in installed_packages:
            continue

        run_command([brew, "install", package])

    bun = shutil.which("bun")
    if not bun:
        raise OSError("Bun is not available after Homebrew installation.")

    for package in BUN_PACKAGES:
        print_message(f"Installing {package}...", indent_size=2)
        run_command([bun, "add", "--global", "--trust", f"{package}@latest"])

    bun_bin = Path.home() / ".bun" / "bin"
    if bun_bin.is_dir():
        os.environ["PATH"] = f"{bun_bin}{os.pathsep}{os.environ.get('PATH', '')}"

    print_message("Packages installed successfully!", indent_size=2, color=SUCCESS_COLOR)


def install_configurations(*, replace: bool = False):
    def install_plugins():
        codex = shutil.which("codex")
        if not codex:
            raise OSError("Codex CLI is not available after installation.")

        claude = shutil.which("claude")
        if not claude:
            raise OSError("Claude Code CLI is not available after installation.")

        print_message("Installing plugins...", indent_size=2)

        print_message("Installing Ponytail...", indent_size=4)
        run_command([codex, "plugin", "marketplace", "add", "https://github.com/DietrichGebert/ponytail.git"])
        run_command([codex, "plugin", "add", "ponytail@ponytail"])
        run_command([claude, "plugin", "marketplace", "add", "https://github.com/DietrichGebert/ponytail.git"])
        run_command([claude, "plugin", "install", "ponytail@ponytail"])

    def install_skills():
        skills = shutil.which("skills")
        if not skills:
            raise OSError("The skills CLI is not available after installation.")

        print_message("Installing skills...", indent_size=2)
        required_agents = {"Codex", "Claude Code"}
        installed_skills = {
            entry["name"]
            for entry in json.loads(
                subprocess.run(
                    [skills, "list", "--global", "--agent", "codex", "claude-code", "--json"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout
            )
            if required_agents <= set(entry["agents"])
        }

        for source, source_skills in AGENT_SKILLS.items():
            print_message(f"Installing {source}...", indent_size=4)
            for skill in source_skills:
                print_message(f"Installing {skill}...", indent_size=6)
                if skill in installed_skills:
                    continue

                run_command(
                    [skills, "add", source, "--global", "--agent", "codex", "claude-code", "--skill", skill, "--yes"]
                )

        print_message("Installing custom skills...", indent_size=4)
        for skill_path in sorted((SCRIPT_PATH / "skills").iterdir()):
            if not skill_path.is_dir() or not (skill_path / "SKILL.md").is_file():
                continue

            print_message(f"Installing {skill_path.name}...", indent_size=6)
            run_command(
                [
                    skills,
                    "add",
                    str(SCRIPT_PATH / "skills"),
                    "--global",
                    "--agent",
                    "codex",
                    "claude-code",
                    "--skill",
                    skill_path.name,
                    "--yes",
                    "--copy",
                ]
            )

    print_message("Installing configurations...")

    home_path = Path.home()

    print_message("Installing personal configurations...", indent_size=2)

    copy_configuration(CONFIG_PATH / ".personal", home_path / ".personal")
    shell_name = Path(os.environ.get("SHELL", "bash")).name
    shell_path = home_path / (".zshrc" if shell_name == "zsh" else ".bashrc")
    shell_configuration = shell_path.read_text(encoding="utf-8") if shell_path.is_file() else ""
    personal_commands = {". ~/.personal", "source ~/.personal"}
    if not any(line.split("#", 1)[0].strip() in personal_commands for line in shell_configuration.splitlines()):
        separator = "" if not shell_configuration or shell_configuration.endswith("\n") else "\n"
        with shell_path.open("a", encoding="utf-8") as file:
            file.write(f"{separator}. ~/.personal\n")

    copy_file(SCRIPT_PATH / ".editorconfig", home_path / ".editorconfig")
    for file in (".oxfmtrc.json", ".oxlintrc.json"):
        copy_file(CONFIG_PATH / file, home_path / file)

    print_message("Installing harness configurations...", indent_size=2)

    agents_path = SCRIPT_PATH / "AGENTS.md"
    for destination in (
        # home_path / "AGENTS.md",
        home_path / ".agents" / "AGENTS.md",
        home_path / ".claude" / "CLAUDE.md",
        home_path / ".codex" / "AGENTS.md",
    ):
        copy_file(agents_path, destination)

    codex_config = CONFIG_PATH / "codex.toml"
    codex_config_destination = home_path / ".codex" / "config.toml"
    copy_tree(CONFIG_PATH / "pets", home_path / ".codex" / "pets", dirs_exist_ok=True)

    if replace:
        copy_configuration(codex_config, codex_config_destination)
    else:
        merge_toml(codex_config, codex_config_destination)

    print_message("Installing other configurations...", indent_size=2)
    copy_configuration(CONFIG_PATH / "playwright.json", home_path / ".playwright" / "cli.config.json")
    merge_gitkraken()

    install_plugins()
    install_skills()

    print_message("Configurations installed successfully!", indent_size=2, color=SUCCESS_COLOR)


### Main ###


async def load_environment():
    token = os.environ.get("OP_SERVICE_ACCOUNT_TOKEN")
    account_name = os.environ.get("OP_ACCOUNT_NAME")
    if not token and not account_name:
        raise OSError("Set OP_ACCOUNT_NAME for 1Password desktop authentication or OP_SERVICE_ACCOUNT_TOKEN.")

    client = await Client.authenticate(
        auth=token if token else DesktopAuth(account_name=account_name),
        integration_name="dentolos19 setup",
        integration_version="1.0.0",
    )
    response = await client.environments.get_variables(os.environ.get("ENVIRONMENT_ID", ENVIRONMENT_ID))
    os.environ.update({variable.name: variable.value for variable in response.variables})


async def main():
    parser = argparse.ArgumentParser(description="Install personal tools and configurations.")
    parser.add_argument("--replace", action="store_true", help="Replace Codex config.toml instead of merging it.")
    args = parser.parse_args()

    if platform.system() not in {"Darwin", "Linux"}:
        print_message(
            "This setup script supports macOS and Linux only.",
            stream=sys.stderr,
            color=ERROR_COLOR,
        )
        return 1

    try:
        await load_environment()
        install_packages()
        install_configurations(replace=args.replace)
    except Exception as error:
        print_message(f"Setup failed: {error}", stream=sys.stderr, color=ERROR_COLOR)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
