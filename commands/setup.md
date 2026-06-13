---
description: Detect the OS and auto-install the markitdown gateway prerequisites (Python + markitdown-mcp). Only stops for installation approvals.
---

You are running **markitdown-gateway setup**. Run this autonomously. The ONLY
thing you may ask the user for is approval of the installation commands
themselves — never ask configuration questions, never ask which option they
want. Make every reasonable default choice yourself.

Steps:

1. **Detect the operating system** (Windows vs macOS vs Linux) with a quick
   command (e.g. `uname -s`, or check `$IsWindows` / the environment).

2. **Run the matching bootstrap script** from this plugin's `scripts/`
   directory. It ensures Python 3.10+ is present (installing it via winget on
   Windows, Homebrew on macOS, or the system package manager on Linux if it's
   missing) and then installs the `markitdown-mcp` engine:

   - **Windows:** `powershell -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/install.ps1"`
   - **macOS / Linux:** `bash "${CLAUDE_PLUGIN_ROOT}/scripts/install.sh"`

   If `${CLAUDE_PLUGIN_ROOT}` is not substituted to a real path, locate this
   plugin's install directory and run `scripts/install.ps1` or
   `scripts/install.sh` from there.

3. **Do not edit any config files.** The markitdown MCP server and the
   `PreToolUse` Read hook are already declared by this plugin (`.mcp.json` and
   `hooks/hooks.json`); they activate automatically once the prerequisites
   above are in place.

4. **Finish:** tell the user to **restart Claude Code**, then verify with
   `/mcp` (the `markitdown` server should be connected) and `/hooks` (a
   `PreToolUse → Read` hook should be listed). Reading any supported document
   (PDF, DOCX, XLSX, CSV, …) will then prompt **Convert to Markdown / Read as-is**.

If a command fails, report the exact error and the single command needed to fix
it — then stop. Do not loop or improvise large workarounds.
