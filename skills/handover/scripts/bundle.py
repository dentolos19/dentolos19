"""Package a handover document, selected files, and an optional patch into a zip bundle."""

import argparse
import fnmatch
import subprocess
import sys
import zipfile
from pathlib import Path

SENSITIVE_PATTERNS = (
    ".env",
    ".env.*",
    "*.pem",
    "*.key",
    "*.p12",
    "*.pfx",
    "id_rsa*",
    "id_ed25519*",
    "*credentials*",
    "*secret*",
)
IGNORED_DIRECTORIES = {".git", "node_modules", "__pycache__", ".venv", ".tmp"}


def is_sensitive(path: Path):
    return any(fnmatch.fnmatch(path.name.lower(), pattern) for pattern in SENSITIVE_PATTERNS)


def collect_files(paths: list[Path], root: Path):
    included, excluded = [], []
    for path in paths:
        candidates = path.rglob("*") if path.is_dir() else [path]
        for file in candidates:
            if not file.is_file() or IGNORED_DIRECTORIES.intersection(file.relative_to(root).parts):
                continue
            (excluded if is_sensitive(file) else included).append(file)
    return sorted(set(included)), sorted(set(excluded))


def create_patch(root: Path):
    def git(*arguments: str):
        return subprocess.run(["git", *arguments], cwd=root, check=True, capture_output=True, text=True).stdout

    untracked = [
        file
        for file in git("ls-files", "--others", "--exclude-standard").splitlines()
        if not is_sensitive(Path(file))
    ]
    if untracked:
        git("add", "--intent-to-add", "--", *untracked)
    try:
        return git("diff", "HEAD", "--binary")
    finally:
        if untracked:
            git("reset", "--quiet", "--", *untracked)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--document", type=Path, required=True, help="Path to the handover document.")
    parser.add_argument("--output", type=Path, required=True, help="Path of the zip bundle to write.")
    parser.add_argument("--patch", action="store_true", help="Include uncommitted changes as changes.patch.")
    parser.add_argument("paths", nargs="*", type=Path, help="Files or directories to include.")
    arguments = parser.parse_args()

    root = Path.cwd().resolve()
    document = arguments.document.resolve()
    if not document.is_file():
        sys.exit(f"Handover document not found: {document}")

    paths = [path.resolve() for path in arguments.paths]
    outside = [path for path in paths if not path.is_relative_to(root)]
    if outside:
        sys.exit("Paths must be inside the working directory: " + ", ".join(map(str, outside)))

    files, excluded = collect_files(paths, root)
    manifest = ["HANDOVER.md"]

    arguments.output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(arguments.output, "w", zipfile.ZIP_DEFLATED) as bundle:
        bundle.write(document, "HANDOVER.md")
        for file in files:
            name = f"files/{file.relative_to(root).as_posix()}"
            bundle.write(file, name)
            manifest.append(name)
        if arguments.patch:
            bundle.writestr("changes.patch", create_patch(root))
            manifest.append("changes.patch")
        bundle.writestr("MANIFEST.txt", "\n".join([*manifest, "MANIFEST.txt"]) + "\n")

    print(f"Wrote {arguments.output} with {len(manifest) + 1} entries.")
    for file in excluded:
        print(f"Excluded sensitive file: {file.relative_to(root)}", file=sys.stderr)


if __name__ == "__main__":
    main()
