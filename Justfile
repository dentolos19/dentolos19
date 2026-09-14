environment_id := env("ENVIRONMENT_ID", "s4tychpwlg53m7bozmbqs3cvz4")
op_arch := if arch() == "x86_64" { "amd64" } else if arch() == "aarch64" { "arm64" } else { error("Unsupported architecture") }
op_os := if os() == "linux" { "linux" } else if os() == "macos" { "darwin" } else { error("Unsupported operating system") }
op_version := "2.39.1-beta.01"
op := justfile_directory() + "/.tmp/op-" + op_version + "/op"
op_archive := "https://cache.agilebits.com/dist/1P/op2/pkg/v" + op_version + "/op_" + op_os + "_" + op_arch + "_v" + op_version + ".zip"

setup:
    test -x "{{ op }}" || (mkdir -p "$(dirname "{{ op }}")" && curl -fsSL {{ op_archive }} -o "{{ op }}.zip" && unzip -q "{{ op }}.zip" -d "$(dirname "{{ op }}")")
    if [ "{{ op_os }}" = linux ] && [ "$(stat -c '%U:%G:%a' "{{ op }}")" != root:onepassword-cli:2755 ]; then pkexec sh -c 'chown root:onepassword-cli "{{ op }}" && chmod 2755 "{{ op }}"'; fi
    FORCE_COLOR=1 "{{ op }}" run --environment {{ environment_id }} -- ./setup.py
