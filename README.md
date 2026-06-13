# markitdown-gateway

A Claude Code plugin that turns every document you open into a deliberate choice:
**convert it to clean Markdown, or read it as-is.**

## 🚀 Quick start

In **Claude Code**, paste these **one at a time**, approve the installs when
asked, then **restart Claude Code**:

```text
/plugin marketplace add ramysaad-coder/MarkitDown_Auto-Ask
/plugin install markitdown-gateway@markitdown-gateway
/reload-plugins
/markitdown-gateway:setup
```

That's the whole install — the setup step auto-installs everything it needs
(Python included) and works on **Windows, macOS, and Linux**. New to this or want
the hand-held version? Read the **[full step-by-step install guide →](INSTALL.md)**

---

Whenever Claude is about to `Read` a file that the
[markitdown](https://github.com/microsoft/markitdown) engine can convert — PDF,
Word, PowerPoint, Excel, images, audio, HTML, CSV, and more — the plugin pauses
and asks you how to handle it:

| Choice | What happens |
| --- | --- |
| **Convert to Markdown** (recommended) | Claude runs the bundled `markitdown` MCP server's `convert_to_markdown` tool and works from the clean Markdown. |
| **Read as-is** | Claude reads the raw file contents directly. |

Plain text, source code, `.md`, and any other unsupported type are read normally
with no prompt.

The plugin bundles **two things** that normally need manual setup:

1. the **`markitdown` MCP server** (registered automatically), and
2. a **`PreToolUse` hook** on the `Read` tool that drives the choice.

---

## Prerequisites

Works on **Windows, macOS, and Linux**. Each user installs the markitdown
engine once:

```bash
pip install markitdown-mcp     # Windows
pip3 install markitdown-mcp    # macOS / Linux (use whatever maps to Python 3)
```

Requires **Python 3.10+**. A couple of platform notes so the plugin can find
everything:

- **Windows:** install Python from [python.org](https://www.python.org/downloads/)
  with **"Add python.exe to PATH"** checked. That puts both `python` and the
  `Scripts\` directory (where `markitdown-mcp.exe` lands) on `PATH`. **Git Bash is
  not required** — the hook launches Python directly, no shell involved.
- **macOS / Linux:** install Python 3 via python.org, Homebrew (`brew install
  python`), or your package manager — this gives you `python3`. Make sure pip's
  bin directory is on `PATH` so the `markitdown-mcp` launcher is found (true for
  Homebrew and virtualenvs; for `pip install --user` on macOS add
  `~/Library/Python/3.x/bin` to `PATH`).
- **Optional everywhere:** install [`ffmpeg`](https://ffmpeg.org/) for audio-file
  transcription — markitdown warns without it but still runs for everything else.

### How it stays OS-agnostic

- The **MCP server** launches via the `markitdown-mcp` console script (pip
  creates it with the same name on every OS and bakes in the right interpreter).
- The **hook** is a **direct, no-shell call** to `python` (exec form), so it runs
  the same on every OS and needs **no Git Bash / no PowerShell**. `python` is
  reliable on Windows; on macOS/Linux (where bare `python` is often missing) the
  `/setup` step creates a `python` → `python3` shim so the call resolves. No
  hard-coded paths — the bundled script is located via `${CLAUDE_PLUGIN_ROOT}`.

## Install

Two steps, and the only thing you'll click is **"approve"** on the installs.

**1. Add and install the plugin** (from inside Claude Code):

```text
/plugin marketplace add <your-git-host>/markitdown-gateway
/plugin install markitdown-gateway@markitdown-gateway
```

Replace `<your-git-host>/markitdown-gateway` with wherever this repo lives
(e.g. `github.com/your-org/markitdown-gateway`, a `git@` URL, or a local path).

**2. Run the one-command setup:**

```text
/markitdown-gateway:setup
```

This **detects your OS, installs Python 3.10+ if it's missing** (winget on
Windows, Homebrew on macOS, the system package manager on Linux), and **installs
the `markitdown-mcp` engine** — pausing only so you can approve each install. It
edits no config files; the MCP server and hook ship with the plugin.

Then **restart Claude Code**.

> Prefer to do the prerequisite yourself? You can skip `/setup` and just run
> `pip install markitdown-mcp` (see [Manual prerequisites](#prerequisites)).

### Verify

```text
/mcp      → markitdown should be listed and connected
/hooks    → a PreToolUse → Read hook should appear
```

Open any supported file (a `.csv`, `.pdf`, `.docx`, …) and you should get the
**Convert / Read-as-is** prompt.

---

## Supported file types

`.pdf` · `.docx .doc .docm` · `.pptx .ppt .pptm` · `.xlsx .xls .xlsm` ·
`.html .htm` · `.csv .json .xml` · `.epub .msg .zip .ipynb` ·
images `.jpg .jpeg .png .gif .bmp .tif .tiff .webp` ·
audio `.wav .mp3 .m4a .mp4 .flac .ogg .aac .opus`

To change the list, edit the `SUPPORTED` set in
[`hooks/markitdown-ask.py`](hooks/markitdown-ask.py). For example, remove
`.json` and `.xml` if prompting on config files gets noisy.

## How it works

The Read tool's own Approve/Reject prompt always means "run the read", so the
hook can't make *Approve* trigger a conversion. Instead it **denies** the read
and hands Claude an explicit two-option question where **Convert** is the
primary choice.

When you pick **Read as-is**, Claude writes the target path into a one-shot
bypass marker (`hooks/.markitdown-bypass`) and retries the read; the hook sees
the matching marker, deletes it, and lets that single read through. The marker
is per-file and consumed immediately, so it never goes stale.

## Troubleshooting

**`markitdown` MCP server won't connect / "command not found".**
The `markitdown-mcp` launcher isn't on `PATH`. Confirm `markitdown-mcp --help`
runs in a fresh terminal. On Windows, reinstall Python with "Add to PATH"; on
macOS/Linux, add pip's bin directory to `PATH` (see Prerequisites).

**The convert/read prompt never appears.**
The hook calls `python` directly (no shell — so Git Bash/PowerShell version
doesn't matter). Make sure a **`python`** command works in a fresh terminal:

- **Windows:** `python --version` should print 3.10+. If not, reinstall Python
  from python.org with **"Add to PATH"** checked.
- **macOS/Linux:** `/setup` creates a `python` → `python3` shim automatically. If
  you set things up manually and only have `python3`, create the shim yourself:
  `ln -sf "$(command -v python3)" ~/.local/bin/python` (and ensure `~/.local/bin`
  is on `PATH`).

Then restart Claude Code.

## Uninstall

```text
/plugin uninstall markitdown-gateway@markitdown-gateway
```

(Optionally `pip uninstall markitdown-mcp` to remove the engine.)

## Note on duplicate setups

If you previously wired markitdown up by hand (a `markitdown` entry in
`~/.claude.json` and a hook in `~/.claude/settings.json`), remove that manual
configuration before installing this plugin — otherwise the server and hook run
twice and you'll get a double prompt.
