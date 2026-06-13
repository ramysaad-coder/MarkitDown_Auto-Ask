# Installing MarkitDown Auto-Ask — Step-by-Step Guide

This guide walks you through installing the **MarkitDown Auto-Ask** plugin for
Claude Code, from start to finish. No technical experience is needed — just
follow the steps **in order**, and click **Approve** when asked.

**Time required:** about 5–10 minutes (most of it is your computer downloading
things quietly in the background).

> **Quick definitions** (you'll see these words below):
> - **Claude Code** — the app/program where you chat with Claude.
> - **Plugin** — a small add-on that gives Claude Code a new ability.
> - **Markdown** — just a plain, tidy text format. "Convert to Markdown" means
>   "turn this document into clean, readable text."
> - **markitdown-gateway** — the technical name of this plugin. You'll see it in
>   the commands and lists below. It's the same thing as "MarkitDown Auto-Ask."

---

## What this plugin does

When Claude opens a document for you (a PDF, Word file, Excel sheet, PowerPoint,
image, and so on), this plugin adds a friendly checkpoint. **Whenever Claude is
about to read one of those files, it pauses and asks you:**

> **Convert this file to Markdown, or read it as-is?**

- **Convert to Markdown** — Claude tidies the document into clean text first
  (great for messy PDFs, Word docs, and spreadsheets).
- **Read as-is** — Claude opens the original file unchanged.

You pick one, Claude continues. The choice appears as a simple question with two
options you click. That's the whole idea.

---

## ⚠️ Read this first if you're on a work computer

This setup installs free software (Python and a converter called *markitdown*).
**Many company laptops block software installs.** If that's your situation, you
have two easy options:

- Ask your **IT team** to install **Python 3.10+** for you (a one-line request),
  **or**
- Send them this guide and ask them to run it.

Once Python is present, the rest of this guide finishes on its own. If you're on
a personal computer, you can ignore this box.

---

## Before you start

You need just **two things**:

| You need… | How to check |
| --- | --- |
| **Claude Code**, installed and working | If you can already chat with Claude in the app, you're set. |
| An **internet connection** | Needed for the one-time downloads. |

> **You do _not_ need to install Python yourself** — the setup step does that for
> you if it's missing. You also don't need any other tools (no "Git Bash" or
> similar); the setup handles everything.

This plugin works on **Windows**, **macOS**, and **Linux**.

---

## How to type the commands in this guide

Every command below starts with a slash, like `/plugin`. You type these into the
**same box where you chat with Claude** — type the command, press **Enter**, and
wait for Claude to respond.

**Tips so you don't have to type carefully:**

- **Copy and paste** each command from this guide instead of typing it. That
  avoids mistakes with capital letters, the `@` sign, the `:` sign, and
  underscores — all of which are intentional parts of the commands.
- When you start typing `/`, Claude Code shows a little menu of matching
  commands. That's normal — you can click one or finish typing.
- If a command doesn't work, it's safe to just try it again.

**About the Approve prompts:** at a few points, a small window will ask
permission to install or run something (you'll see words like *Allow*, *Yes*, or
*Approve*). **Choosing Approve is expected and safe** — it's how the setup
installs what it needs. You'll see roughly **two to four** of these in total.

---

## Step 1 — Add the plugin source

This tells Claude Code where to find the plugin (it's published on GitHub).

**Copy, paste, and press Enter:**

```
/plugin marketplace add ramysaad-coder/MarkitDown_Auto-Ask
```

**What you'll see:** Claude Code confirms it added the source. It may ask you to
trust or confirm it — choose **yes**. Nothing big is installed yet; this just
downloads a small list of what's available.

---

## Step 2 — Install the plugin

**Copy, paste, and press Enter:**

```
/plugin install markitdown-gateway@markitdown-gateway
```

> The name looks doubled **on purpose** — it means *the plugin named
> `markitdown-gateway`* from *the source named `markitdown-gateway`*. The `@` in
> the middle is required. Just paste it exactly.

**What you'll see:** Claude Code confirms the plugin is installed.

---

## Step 3 — Switch the plugin on

The plugin won't be active in your current session until you reload. This is one
quick command (no need to close anything).

**Copy, paste, and press Enter:**

```
/reload-plugins
```

**What you'll see:** Claude Code reports that it reloaded plugins (it lists small
counts of things it loaded). The plugin is now switched on.

---

## Step 4 — Run the automatic setup

This installs the **markitdown** converter engine (and Python, if your computer
doesn't already have it), and gets everything ready.

**Copy, paste, and press Enter:**

```
/markitdown-gateway:setup
```

> The `:` (colon) in this command is correct — it's how Claude Code runs a
> plugin's built-in action. Just copy-paste it as shown.

> **This is common and not a problem:** if Claude replies that it doesn't
> recognize the command, the plugin just needs a restart first. Fully close and
> reopen Claude Code (see [Step 5](#step-5--restart-claude-code)), then paste the
> command again — it'll work the second time.

**What happens now:**

1. Claude detects whether you're on **Windows**, **Mac**, or **Linux**.
2. It checks for **Python**. If it's missing, Claude installs it for you —
   using **winget** on Windows, **Homebrew** on Mac (on Mac it may ask for your
   **login password** — that's normal), or your package manager on Linux.
3. It installs the **markitdown** converter.

**Your only job:** when an **Approve** prompt appears, choose **Allow / Yes**.

> **This step can take a few minutes** — the converter pulls in several
> supporting pieces (for PDFs, Office files, images, and audio). As long as text
> is still appearing or a spinner is moving, it's working. If there's been **no
> activity at all for more than ~10 minutes**, it may be waiting on an Approve
> prompt you missed, or a blocked install (see the work-computer note above).

When it finishes, Claude tells you the prerequisites are ready.

---

## Step 5 — Restart Claude Code

Yes, another switch-on step — but a different one: `/reload-plugins` in Step 3
turned the plugin **on**, and this restart lets the **converter connect** now
that the setup has installed it. **How to restart depends on how you use Claude
Code:**

- **Not sure which you use?** If you click an app icon to open Claude, you're on
  the **desktop app** — use that row below.

| If you use… | How to fully restart |
| --- | --- |
| **The desktop app (Windows)** | Close the window. Then check the **system tray** — the little row of icons near the clock at the bottom-right of your screen (you may need to click the small upward arrow `^` to reveal hidden ones). If a Claude icon is there, right-click it and choose **Quit**. **If you don't see a Claude icon there, it's already fully closed** — just open it again. |
| **The desktop app (Mac)** | Press **Cmd + Q** to quit fully — just closing the window isn't enough. Then reopen it. |
| **A terminal / command window** | Type `exit`, press Enter, then start it again by typing `claude`. |
| **Inside VS Code or another code editor** | Reload or restart the editor. |

---

## Step 6 — Check it worked

After restarting, run these two quick checks.

**1. Is the converter connected? Type:**

```
/mcp
```

A short list appears. **Look for the word `markitdown`** with a status like
**connected** (a checkmark or "connected" label) next to it. ✅

**2. Is the question feature active? Type:**

```
/hooks
```

A list appears. **Look for an entry mentioning `Read`** (shown as
`PreToolUse → Read`). Seeing it means the feature is on. ✅

If both appear, you're fully installed. If not, see
[Troubleshooting](#if-something-goes-wrong).

---

## Step 7 — Try it out

Let's see it work.

1. Pick any document — a **PDF**, **Word doc**, **Excel sheet**, or **CSV** — and
   ask Claude to read it. Easiest ways to point Claude at a file:
   - **Easiest — just describe it in plain words**, e.g.
     *"Please read report.pdf in my Downloads folder."* Claude will find it.
   - **Or drag the file** from your folder straight into the chat box, if your
     Claude Code supports it.
   - **Or give the full location** (advanced): right-click the file →
     **Properties** (Windows) or **Get Info** (Mac). Note that this shows the
     **folder** — you still need to add the **file's name** on the end, so the
     whole thing reads like `C:\Users\You\Downloads\report.pdf`.

2. Instead of just opening it, Claude **pauses and asks you**:
   **Convert to Markdown** or **Read as-is**. Click your choice.

3. Choose **Convert to Markdown** — Claude tidies the document and continues. 🎉

From now on, this happens automatically for supported files.

---

## What to expect day-to-day

- **Only document-type files trigger the question.** Plain notes and code-type
  files are read normally, with no interruption.
- **You're always in control** — it's a simple two-way choice each time.
- **Files that trigger the question:**
  - Documents: PDF, Word (`.docx`, `.doc`), PowerPoint (`.pptx`, `.ppt`),
    Excel (`.xlsx`, `.xls`)
  - Web/data: HTML, CSV, JSON, XML
  - Books, email & bundles: EPUB, Outlook `.msg`, ZIP, Jupyter notebooks
  - Images: JPG, PNG, GIF, BMP, TIFF, WEBP
  - Audio: WAV, MP3, M4A, MP4, FLAC, OGG, AAC

  (The question appears when Claude uses its built-in file **Read** action on one
  of these — which is the normal way it opens files.)

---

## If something goes wrong

| What you see | What it means | How to fix it |
| --- | --- | --- |
| `/markitdown-gateway:setup` is "not recognized" | The plugin isn't switched on in this session yet | Run `/reload-plugins` (Step 3). If it still isn't recognized, fully restart Claude Code (Step 5), then try again. |
| `/mcp` doesn't list **markitdown**, or shows **failed** | The converter engine isn't installed or can't be found yet | Make sure you finished **Step 4** and **restarted** (Step 5). If it still fails, see the PATH fixes below. |
| The **Convert / Read-as-is** question never appears | The plugin's feature didn't load | Restart Claude Code (Step 5). If it still doesn't appear, re-run `/markitdown-gateway:setup` and approve the installs, then restart again. |
| Setup says **"winget not available"** (Windows) | Windows can't auto-install Python | Install Python from [python.org](https://www.python.org/downloads/), and on the **first installer screen check "Add python.exe to PATH"**. Then run `/markitdown-gateway:setup` again. |
| `markitdown-mcp ... not on PATH` — **Windows** | Python's program folder isn't findable | This almost always means Python was installed **without** "Add to PATH". Reinstall Python from [python.org](https://www.python.org/downloads/) with **"Add python.exe to PATH" checked**, then run setup again. |
| `markitdown-mcp ... not on PATH` — **Mac/Linux** | The install folder isn't findable yet | Close and reopen your terminal/app. The setup message names the folder to add (often `~/.local/bin`); a technical colleague can add it to your `PATH`. |
| Setup asks for your **password** (Mac) | Mac is installing Homebrew/Python | Normal — type your Mac login password to continue. |
| It seems frozen during setup | It's downloading large files | Give it several minutes. Only worry if there's **no** activity for ~10+ minutes (then check for a missed Approve prompt). |

Still stuck? Copy any **error message** (often shown in red) and send it to
whoever shared this plugin with you — it usually points right at the fix.

---

## Updating the plugin

To get the latest version later:

```
/plugin marketplace update markitdown-gateway
```

Then run `/reload-plugins` (or restart Claude Code).

---

## Turning it off or uninstalling

- **Temporarily turn it off:** type `/plugin`, find **markitdown-gateway**, and
  disable it.
- **Remove it completely:**

  ```
  /plugin uninstall markitdown-gateway@markitdown-gateway
  ```

  Then run `/reload-plugins` (or restart).

The markitdown converter stays installed on your computer (it's harmless). A
technical user can fully remove it with `python -m pip uninstall markitdown-mcp`
(`python3 -m pip` on Mac/Linux).

---

## Frequently asked questions

**Do I need to know how to code?**
No. Copy-paste the commands and approve the installs.

**Is it safe to approve the installation prompts?**
Yes — they install Python and the markitdown converter, which are standard, free,
widely-used tools. Approving them is how the setup works.

**Will this slow down my normal work?**
No. The question only appears for document files (PDF, Word, Excel, etc.). Other
files open normally.

**Does it send my files anywhere?**
No. The converting happens **on your own computer** using the local markitdown
converter.

**It installed but nothing happens — what did I miss?**
Almost always a missing **reload or restart**. Run `/reload-plugins`, or fully
restart Claude Code (Step 5), then check `/mcp` and `/hooks`.

**Why two different "switch on" steps (`/reload-plugins` and restart)?**
`/reload-plugins` turns the plugin on right after installing. The later **restart**
lets the converter connect *after* it's been installed by the setup step. Both
are quick.

---

## Appendix — Manual setup (for advanced users)

If you'd rather not use the automatic `/setup` step, you only need to install the
converter engine yourself; the plugin still provides everything else.

1. Install **Python 3.10 or newer**.
   - Windows: from [python.org](https://www.python.org/downloads/), with
     **"Add python.exe to PATH"** checked.
   - Mac: `brew install python` (or from python.org).
   - Linux: via your package manager (e.g. `sudo apt install python3 python3-pip`).
2. Install the converter. To avoid "wrong Python" problems, call pip through your
   Python:

   ```
   python -m pip install markitdown-mcp     # Windows
   python3 -m pip install markitdown-mcp    # Mac / Linux
   ```

3. Make sure the plugin is installed (Steps 1–3), then **restart Claude Code** and
   verify with `/mcp` and `/hooks`.

This produces the same result as the automatic setup — just done by hand.
