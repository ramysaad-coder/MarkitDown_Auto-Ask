# macOS test plan (quick)

~10 minutes on any Mac. Goal: validate the paths that can't be exercised on
Windows — the `install.sh` bootstrap, the `python3` hook fallback, `markitdown-mcp`
on PATH, and the end-to-end Convert / Read-as-is flow.

Run the **Smoke tests** on any Mac that already has Python. Run **Test E** only
if you want to validate the auto-install-Python branch (needs a Mac *without*
Python 3.10+ — e.g. a fresh user account or VM).

---

## 0. Setup

```bash
git clone <your-git-host>/markitdown-gateway
cd markitdown-gateway
chmod +x scripts/install.sh        # in case the exec bit didn't survive
```

---

## Test A — bootstrap script runs and installs the engine

```bash
bash scripts/install.sh
```

**Pass if** the final two lines are:

```
[OK] markitdown-mcp is installed and on PATH.
[done] Prerequisites ready. Restart Claude Code, then check /mcp and /hooks.
```

If you instead see `[warn] markitdown-mcp not on PATH`, add the bin dir and
re-open the shell:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc   # pip --user
# or, for pipx:  pipx ensurepath
exec zsh
command -v markitdown-mcp        # should now print a path
```

## Test B — the MCP server actually speaks MCP

```bash
printf '%s\n' \
 '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"probe","version":"1.0"}}}' \
 '{"jsonrpc":"2.0","method":"notifications/initialized"}' \
 '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' \
 | markitdown-mcp 2>/dev/null
```

**Pass if** the output includes a `convert_to_markdown` tool in the `tools/list`
result.

## Test C — the hook script + the `python3` fallback (the key Mac risk)

On macOS bare `python` is usually absent, so the hook must fall back to
`python3`. Simulate the exact command Claude Code runs:

```bash
ROOT="$(pwd)"
echo '{"tool_name":"Read","tool_input":{"file_path":"/tmp/report.pdf"}}' \
 | sh -c "python \"$ROOT/hooks/markitdown-ask.py\" || python3 \"$ROOT/hooks/markitdown-ask.py\""
```

**Pass if** you get ONE JSON object with `"permissionDecision":"deny"` and a
reason mentioning `convert_to_markdown`.

Now confirm a non-supported file stays silent:

```bash
echo '{"tool_name":"Read","tool_input":{"file_path":"/tmp/app.py"}}' \
 | sh -c "python \"$ROOT/hooks/markitdown-ask.py\" || python3 \"$ROOT/hooks/markitdown-ask.py\""
```

**Pass if** there is **no output**.

## Test D — end-to-end inside Claude Code

```bash
/plugin marketplace add <local path or git URL>
/plugin install markitdown-gateway@markitdown-gateway
/markitdown-gateway:setup      # approve installs
# restart Claude Code
```

Then:

1. `/mcp` → **Pass if** `markitdown` is listed and connected.
2. `/hooks` → **Pass if** a `PreToolUse → Read` hook appears.
3. Create a sample and read it:
   ```bash
   printf 'product,units\nWidget,120\n' > /tmp/sample.csv
   ```
   Ask Claude to read `/tmp/sample.csv`.
   - **Pass if** you get the **Convert to Markdown / Read as-is** question.
   - Choose **Convert** → Claude returns a Markdown table. ✅
4. Read it again, choose **Read as-is** → Claude shows the raw CSV lines, and a
   single read goes through (no loop). ✅ (verifies the bypass-marker path)

## Test E — auto-install Python branch (optional, needs a clean Mac)

On a Mac **without** Python 3.10+ (fresh user/VM):

```bash
bash scripts/install.sh
```

**Pass if** it installs Homebrew (if absent, prompting for your password), then
`python` + `pipx`, then `markitdown-mcp`, ending on `[done]`. Re-run Test B.

---

## Report back

For each test note Pass/Fail and paste any line starting with `[warn]` or an
error. The most likely real-world fixes are PATH-related (Test A's warn box) —
everything else should pass as-is.
