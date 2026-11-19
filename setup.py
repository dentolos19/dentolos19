# /// script
# dependencies = ["onepassword-sdk>=0.4.2", "tomlkit>=0.15.2"]
# ///

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
ENVIRONMENT_ID = "s4tychpwlg53m7bozmbqs3cvz4"
WORK_HOSTNAME = "dc-sanjua-v6yvf"

HOMEBREW_INSTALL = "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
CUA_INSTALL = "https://cua.ai/driver/install.sh"

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

BUN_PACKAGES = (
    "@anthropic-ai/claude-code",
    "@openai/codex",
    "@opencode/cli",
    "cf",
    "neon",
    "skills",
)

BREW_PACKAGES = (
    "antigravity-cli",
    "awscli",
    "azure-cli",
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

BREW_PATHS = {
    "Linux": (Path("/home/linuxbrew/.linuxbrew/bin/brew"),),
    "Darwin": (Path("/opt/homebrew/bin/brew"), Path("/usr/local/bin/brew")),
}

SKILL_AGENTS = ("antigravity-cli", "claude-code", "codex", "opencode")
SKILL_AGENT_NAMES = {"Antigravity CLI", "Claude Code", "Codex", "OpenCode"}

AGENT_SKILLS = {
    "composiohq/composio": ("composio",),
    "effect-ts/skills": ("effect-ts",),
    "microsoft/playwright-cli": ("playwright-cli",),
    "shadcn-ui/ui": ("shadcn",),
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


def load_json(path: Path):
    return json.loads(replace_environment(path))


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
    content = target.read_text(encoding="utf-8").strip() if target.is_file() else ""
    current = json.loads(content) if content else {}
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

    desired = load_json(CONFIG_PATH / "gitkraken" / "config.json")
    merge_values(desired, load_json(CONFIG_PATH / "gitkraken" / f"{platform.system().lower()}.json"))

    profiles = desired.pop("profiles", {})
    matched_profiles = set()
    profile_updates = []
    for path in (gitkraken_path / "profiles").glob("*/profile"):
        profile = json.loads(path.read_text(encoding="utf-8"))
        if profile.get("profileName") in profiles:
            profile_updates.append((path, profiles[profile["profileName"]]))
            matched_profiles.add(profile["profileName"])

    for name in profiles.keys() - matched_profiles:
        print_message(f"{name} profile is not initialized; skipping it.", indent_size=4)

    merge_json(desired, config_path)
    for path, updates in profile_updates:
        merge_json(updates, path)


def find_homebrew():
    brew = shutil.which("brew")
    if brew:
        return brew

    for brew_path in BREW_PATHS[platform.system()]:
        if brew_path.is_file():
            os.environ["PATH"] = f"{brew_path.parent}{os.pathsep}{os.environ.get('PATH', '')}"
            return str(brew_path)


def get_homebrew():
    brew = find_homebrew()
    if brew:
        return brew

    print_message("Homebrew is not installed. Installing...", indent_size=2, color=WARNING_COLOR)

    bash = shutil.which("bash")
    curl = shutil.which("curl")
    if not bash or not curl:
        raise OSError("Bash and curl are required to install Homebrew.")

    install_command = f'exec {shlex.quote(bash)} -c "$({shlex.quote(curl)} -fsSL {shlex.quote(HOMEBREW_INSTALL)})"'
    subprocess.run([bash, "-c", install_command], check=True)

    brew = find_homebrew()
    if not brew:
        raise OSError("Homebrew installation completed, but the brew executable could not be found.")

    print_message("Homebrew installed successfully!", indent_size=2, color=SUCCESS_COLOR)
    return brew


def run_command(command: list[str], *, env: dict[str, str] | None = None):
    try:
        subprocess.run(command, check=True, capture_output=True, text=True, env=env)
    except subprocess.CalledProcessError as error:
        print(error.stdout, end="", file=sys.stderr)
        print(error.stderr, end="", file=sys.stderr)
        raise


def run_script(url: str, *, shell: str = "bash", env: dict[str, str]):
    bash = shutil.which("bash")
    if not bash or not shutil.which("curl"):
        raise OSError(f"Bash and curl are required to run {url}.")

    # The installers skip shell setup because ~/.personal already manages PATH, and skip agent setup because the
    # configurations are installed from this repository.
    run_command([bash, "-c", f"set -o pipefail; curl -fsSL {shlex.quote(url)} | {shell}"], env={**os.environ, **env})


def copy_file(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_dir():
        raise OSError(f"Cannot copy {source}: {target} is a directory.")

    target.unlink(missing_ok=True)
    shutil.copy2(source, target)


def copy_tree(source: Path, target: Path):
    target.parent.mkdir(parents=True, exist_ok=True)

    if target.is_symlink():
        target.unlink()
    elif target.exists() and not target.is_dir():
        raise OSError(f"Cannot copy {source}: {target} is not a directory.")

    shutil.copytree(source, target, dirs_exist_ok=True)


### Packages ###


def install_packages():
    def install_brew():
        print_message("Installing Homebrew packages...", indent_size=2)

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
            print_message(f"Installing {package}...", indent_size=4)
            if package not in installed_packages:
                run_command([brew, "install", package])

    def install_bun():
        print_message("Installing Bun packages...", indent_size=2)

        bun = shutil.which("bun")
        if not bun:
            raise OSError("Bun is not available after Homebrew installation.")

        for package in BUN_PACKAGES:
            print_message(f"Installing {package}...", indent_size=4)
            run_command([bun, "add", "--global", "--trust", f"{package}@latest"])

        bun_bin = Path.home() / ".bun" / "bin"
        if bun_bin.is_dir():
            os.environ["PATH"] = f"{bun_bin}{os.pathsep}{os.environ.get('PATH', '')}"

    def install_cua():
        print_message("Installing Cua Driver...", indent_size=2)

        local_bin = Path.home() / ".local" / "bin"
        os.environ["PATH"] = f"{local_bin}{os.pathsep}{os.environ.get('PATH', '')}"
        if not shutil.which("cua-driver"):
            run_script(
                CUA_INSTALL,
                env={"CUA_DRIVER_NO_MODIFY_PATH": "1", "CUA_DRIVER_NO_CONNECT": "1", "CUA_DRIVER_NO_TEST": "1"},
            )

        # The skill pack is bundled with the driver and linked into the detected agents.
        run_command(["cua-driver", "skills", "install"])

    print_message("Installing packages...")

    install_brew()
    install_bun()
    install_cua()

    print_message("Packages installed successfully!", indent_size=2, color=SUCCESS_COLOR)


def install_configurations():
    home_path = Path.home()
    agents_path = SCRIPT_PATH / "AGENTS.md"

    def install_skills():
        skills = shutil.which("skills")
        if not skills:
            raise OSError("The skills CLI is not available after installation.")

        def add_skill(source: str, skill: str, *options: str):
            command = [skills, "add", source, "--global", "--agent", *SKILL_AGENTS, "--skill", skill, "--yes"]
            run_command([*command, *options])

        print_message("Installing skills...", indent_size=2)
        installed_skills = {
            entry["name"]
            for entry in json.loads(
                subprocess.run(
                    [skills, "list", "--global", "--agent", *SKILL_AGENTS, "--json"],
                    check=True,
                    capture_output=True,
                    text=True,
                ).stdout
            )
            if SKILL_AGENT_NAMES.issubset(entry["agents"])
        }

        for source, source_skills in AGENT_SKILLS.items():
            print_message(f"Installing {source}...", indent_size=4)
            for skill in source_skills:
                print_message(f"Installing {skill}...", indent_size=6)
                if skill not in installed_skills:
                    add_skill(source, skill)

        print_message("Installing custom skills...", indent_size=4)
        for skill_path in sorted((SCRIPT_PATH / "skills").iterdir()):
            if skill_path.is_dir() and (skill_path / "SKILL.md").is_file():
                print_message(f"Installing {skill_path.name}...", indent_size=6)
                add_skill(str(SCRIPT_PATH / "skills"), skill_path.name, "--copy")

    def install_personal():
        print_message("Installing personal configurations...", indent_size=2)

        copy_configuration(CONFIG_PATH / ".personal", home_path / ".personal")
        copy_file(SCRIPT_PATH / ".editorconfig", home_path / ".editorconfig")

        shell_name = Path(os.environ.get("SHELL", "bash")).name
        shell_path = home_path / (".zshrc" if shell_name == "zsh" else ".bashrc")
        shell_configuration = shell_path.read_text(encoding="utf-8") if shell_path.is_file() else ""
        personal_commands = {". ~/.personal", "source ~/.personal"}
        if not any(line.split("#", 1)[0].strip() in personal_commands for line in shell_configuration.splitlines()):
            separator = "" if not shell_configuration or shell_configuration.endswith("\n") else "\n"
            with shell_path.open("a", encoding="utf-8") as file:
                file.write(f"{separator}. ~/.personal\n")

    def install_antigravity():
        print_message("Installing Antigravity configurations...", indent_size=2)

        gemini_path = home_path / ".gemini"
        copy_file(agents_path, gemini_path / "GEMINI.md")
        merge_json(load_json(CONFIG_PATH / "antigravity" / "config.json"), gemini_path / "config" / "config.json")
        merge_json(load_json(CONFIG_PATH / "antigravity" / "mcp.json"), gemini_path / "config" / "mcp_config.json")
        merge_json(
            load_json(CONFIG_PATH / "antigravity" / "settings.json"),
            gemini_path / "antigravity-cli" / "settings.json",
        )

    def install_codex():
        print_message("Installing Codex configurations...", indent_size=2)

        for destination in (
            # home_path / "AGENTS.md",
            home_path / ".agents" / "AGENTS.md",
            home_path / ".codex" / "AGENTS.md",
        ):
            copy_file(agents_path, destination)

        copy_tree(CONFIG_PATH / "codex" / "pets", home_path / ".codex" / "pets")
        merge_toml(CONFIG_PATH / "codex" / "config.toml", home_path / ".codex" / "config.toml")

    def install_claude():
        print_message("Installing Claude configurations...", indent_size=2)

        copy_file(agents_path, home_path / ".claude" / "CLAUDE.md")
        merge_json(load_json(CONFIG_PATH / "claude" / "settings.json"), home_path / ".claude" / "settings.json")
        merge_json(load_json(CONFIG_PATH / "claude" / "mcp.json"), home_path / ".claude.json")

    def install_claude_desktop():
        print_message("Installing Claude Desktop configurations...", indent_size=2)

        desktop_path = (
            home_path / ".config" / "Claude"
            if platform.system() == "Linux"
            else home_path / "Library" / "Application Support" / "Claude"
        )
        merge_json(load_json(CONFIG_PATH / "claude" / "desktop.json"), desktop_path / "claude_desktop_config.json")

    def install_opencode():
        print_message("Installing OpenCode configurations...", indent_size=2)

        opencode_path = home_path / ".config" / "opencode"
        copy_configuration(CONFIG_PATH / "opencode" / "opencode.json", opencode_path / "opencode.json")
        copy_configuration(CONFIG_PATH / "opencode" / "cli.json", opencode_path / "cli.json")

    def install_git():
        print_message("Installing Git configurations...", indent_size=2)

        copy_configuration(CONFIG_PATH / "git" / "allowed_signers", home_path / ".config" / "git" / "allowed_signers")
        copy_configuration(CONFIG_PATH / "git" / ".gitconfig", home_path / ".gitconfig")

        if platform.system() == "Darwin":
            run_command(
                [
                    "git",
                    "config",
                    "--file",
                    str(home_path / ".gitconfig"),
                    "gpg.ssh.program",
                    "/Applications/1Password.app/Contents/MacOS/op-ssh-sign",
                ]
            )

        if platform.node().split(".")[0] == WORK_HOSTNAME:
            work_path = home_path / ".config" / "git" / "work.gitconfig"
            copy_configuration(CONFIG_PATH / "git" / ".gitconfig.work", work_path)
            gitconfig_path = str(home_path / ".gitconfig")
            run_command(["git", "config", "--file", gitconfig_path, "includeIf.gitdir:~/Work/.path", str(work_path)])

    def install_gitkraken():
        print_message("Installing GitKraken configurations...", indent_size=2)

        merge_gitkraken()

    def install_playwright():
        print_message("Installing Playwright configurations...", indent_size=2)

        playwright_path = home_path / ".playwright"
        copy_configuration(CONFIG_PATH / "playwright.json", playwright_path / "cli.config.json")

    print_message("Installing configurations...")

    install_personal()
    install_antigravity()
    install_codex()
    install_claude()
    install_claude_desktop()
    install_opencode()
    install_git()
    install_gitkraken()
    install_playwright()
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
    if platform.system() not in {"Linux", "Darwin"}:
        print_message(
            "This setup script supports Linux and macOS only.",
            stream=sys.stderr,
            color=ERROR_COLOR,
        )
        return 1

    try:
        await load_environment()
        install_packages()
        install_configurations()
    except Exception as error:
        print_message(f"Setup failed: {error}", stream=sys.stderr, color=ERROR_COLOR)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(asyncio.run(main()))
