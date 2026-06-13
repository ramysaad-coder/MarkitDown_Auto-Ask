# Installing MarkitDown Auto-Ask — Step-by-Step Guide

This guide walks you through installing the **MarkitDown Auto-Ask** plugin for
Claude Code, from start to finish. No technical experience is needed — just
follow the steps in order, and approve the installs when asked.

**Time required:** about 5–10 minutes (most of it is the computer downloading
things in the background).

---

## What this plugin does

Normally, when Claude opens a document for you (a PDF, Word file, Excel sheet,
PowerPoint, image, and so on), it just reads the raw file. This plugin adds a
friendly checkpoint: **every time Claude is about to open one of those files, it
pauses and asks you a simple question:**

> **Convert this file to Markdown, or read it as-is?**

- **Convert to Markdown** — Claude turns the document into clean, tidy text
  first (great for messy PDFs, Word docs, spreadsheets, etc.).
- **Read as-is** — Claude opens the original file unchanged.

You pick, Claude continues. That's the whole idea. Behind the scenes it uses a
tool called **markitdown** to do the converting.

---

## Before you start

You need **two things**. The plugin takes care of almost everything else for you.

| You need… | How to check / get it |
| --- | --- |
| **Claude Code** installed and working | If you can already chat with Claude in the Claude Code app, terminal, or IDE extension, you're set. If not, install it first from Anthropic. |
| An **internet connection** | The setup downloads a few things the first time. |

> **You do _not_ need to install Python or anything else yourself.** The plugin's
> setup step checks your computer and installs whatever is missing — you only
> click "approve."

This plugin works on **Windows** and **macOS** (and Linux).

---

## Where to type the commands in this guide

Throughout this guide you'll type short commands that start with a slash, like
`/plugin`. You type these into the **same box where you normally chat with
Claude** — the message/prompt box in Claude Code. Type the command, press
**Enter**, and wait for Claude to respond.

When you start typing `/`, Claude Code usually shows a little menu of matching
commands — that's normal and helpful, but you can also just type the whole
command yourself.

Whenever the computer needs your permission to install or run something, a small
**approval prompt** appears. Read it, and choose **Allow / Yes / Approve** to
continue. Approving these is expected and safe — it's how the setup installs what
it needs.

---

## Step 1 — Add the plugin source

This tells Claude Code where to find the plugin.

**Type this and press Enter:**

```
/plugin marketplace add ramysaad-coder/MarkitDown_Auto-Ask
```

**What you'll see:** Claude Code confirms it added the source (it may ask you to
trust/confirm it — choose yes). This downloads a tiny list of what's available;
it does not install anything heavy yet.

---

## Step 2 — Install the plugin

Now install the plugin itself.

**Type this and press Enter:**

```
/plugin install markitdown-gateway@markitdown-gateway
```

> The name looks doubled on purpose: it means *the plugin called
> `markitdown-gateway`* from *the source called `markitdown-gateway`*. Type it
> exactly as shown.

**What you'll see:** Claude Code confirms the plugin is installed and enabled. It
may mention that an MCP server and a hook were added — that's the plugin's two
working parts. You don't need to do anything with them.

---

## Step 3 — Run the automatic setup

This is the step that makes everything actually work. It checks your computer,
installs the **markitdown** engine (and Python, if your computer doesn't have
it), and gets the plugin ready.

**Type this and press Enter:**

```
/markitdown-gateway:setup
```

**What happens now:**

1. Claude detects whether you're on **Windows** or **Mac**.
2. It checks whether **Python** (a free, standard tool the engine needs) is
   installed. If it's missing, Claude installs it for you —
   using **winget** on Windows or **Homebrew** on Mac.
3. It installs the **markitdown** engine.

**Your only job:** when an **approval prompt** appears for an installation,
choose **Allow / Yes**. There may be a few. This is the *"approve installations"*
part — and the only input the setup needs from you.

> **This step can take a few minutes.** The markitdown engine pulls in several
> supporting pieces (for reading PDFs, Office files, images, and audio), so let
> it run. When it's done, Claude will tell you the prerequisites are ready.

---

## Step 4 — Restart Claude Code

For the plugin to switch on, Claude Code needs a fresh start.

- **Desktop app (Windows/Mac):** fully quit the app, then open it again.
  - Windows: close the window, and if it's still in the system tray (bottom-right),
    right-click it and choose Quit, then reopen.
  - Mac: press **Cmd + Q** to quit fully (closing the window isn't enough), then reopen.
- **Terminal / command line:** type `exit` and press Enter, then start it again
  with `claude`.
- **VS Code / JetBrains extension:** reload or restart the editor.

---

## Step 5 — Check it worked

After restarting, run these two quick checks.

**Check the engine is connected — type:**

```
/mcp
```

You should see **`markitdown`** in the list, marked as **connected**. ✅

**Check the question feature is active — type:**

```
/hooks
```

You should see a hook listed under **`PreToolUse → Read`**. ✅

If both appear, you're fully installed. If not, see
[Troubleshooting](#if-something-goes-wrong-troubleshooting) below.

---

## Step 6 — Try it out

Let's see it in action.

1. Find any document on your computer — a **PDF**, **Word doc**, **Excel sheet**,
   or even a simple **CSV** — and ask Claude to read it. For example:

   > "Please read the file C:\Users\YourName\Documents\report.pdf"

   (On Mac, a path looks like `/Users/YourName/Documents/report.pdf`.)

2. Instead of just opening it, Claude will **pause and ask you**:
   **Convert to Markdown** or **Read as-is**.

3. Choose **Convert to Markdown** — Claude turns the document into clean text and
   continues. 🎉

That's it. From now on, this happens automatically for supported files.

---

## What to expect day-to-day

- **Only document-type files trigger the question.** Plain text, code, and
  similar files are read normally with no interruption.
- **You're always in control** — every prompt is a simple two-way choice.
- **Supported file types** (the ones that trigger the question):
  - Documents: PDF, Word (`.docx`, `.doc`), PowerPoint (`.pptx`, `.ppt`),
    Excel (`.xlsx`, `.xls`)
  - Web/data: HTML, CSV, JSON, XML
  - Books & email: EPUB, Outlook `.msg`, ZIP, Jupyter notebooks
  - Images: JPG, PNG, GIF, BMP, TIFF, WEBP
  - Audio: WAV, MP3, M4A, MP4, FLAC, OGG, AAC

---

## If something goes wrong (Troubleshooting)

| What you see | What it means | How to fix it |
| --- | --- | --- |
| `/mcp` doesn't list **markitdown**, or it says "failed" | The markitdown engine isn't found yet | Make sure you completed **Step 3** (`/markitdown-gateway:setup`) and **restarted** Claude Code. If it still fails, run the setup command again and approve the installs. |
| The **Convert / Read-as-is** question never appears | The plugin's hook didn't load | Restart Claude Code again. On Windows, also make sure **Git for Windows** is installed (it's a common free tool); the hook uses it. |
| Setup says **"winget not available"** (Windows) | Your Windows can't auto-install Python | Install Python yourself from [python.org](https://www.python.org/downloads/), and on the first installer screen **check "Add python.exe to PATH"**. Then run `/markitdown-gateway:setup` again. |
| Setup asks for your **password** (Mac) | Mac is installing Homebrew/Python | This is normal — type your Mac login password to let it continue. |
| `markitdown-mcp ... not on PATH` warning | The engine installed but the computer can't find it yet | Close and reopen your terminal/app, then re-run the setup. On Mac, the message tells you which folder to add. |
| Everything is slow / seems stuck during setup | It's downloading large supporting files | Give it a few minutes. It's working in the background. |

> **On a company/work computer:** if installs are blocked by IT security, you may
> need your IT team to allow installing Python and Python packages, or to install
> Python for you. Once Python is present, re-running `/markitdown-gateway:setup`
> will finish the job.

If you're still stuck, copy any red error text and send it to whoever shared this
plugin with you — it usually points straight at the fix.

---

## Updating the plugin

To get the latest version later:

```
/plugin marketplace update markitdown-gateway
```

Then restart Claude Code.

---

## Turning it off or uninstalling

- **Temporarily turn it off:** use the `/plugin` menu and disable
  **markitdown-gateway**.
- **Remove it completely:**

  ```
  /plugin uninstall markitdown-gateway@markitdown-gateway
  ```

The markitdown engine stays installed on your computer (it's harmless). If you
want to remove that too, a technical user can run `pip uninstall markitdown-mcp`.

---

## Frequently asked questions

**Do I need to know how to code?**
No. Just follow the steps and approve the installs.

**Is it safe to approve the installation prompts?**
Yes — they install Python and the markitdown engine, which are standard,
widely-used, free tools. Approving them is how the setup works.

**Will this slow down my normal work?**
No. The question only appears for document files (PDF, Word, Excel, etc.). All
other files open normally.

**What if I always want the same choice?**
Just pick it each time — it's one click. The plugin is intentionally a per-file
question so you stay in control.

**Does it send my files anywhere?**
No. The converting happens **on your own computer** using the local markitdown
engine.

**It installed but nothing happens — what did I miss?**
Almost always a missing **restart**. Quit Claude Code completely and reopen it
(see Step 4), then check with `/mcp` and `/hooks`.

---

## Appendix — Manual setup (fallback for advanced users)

If you'd rather not use the automatic `/setup` step, you only need to install the
engine yourself; the plugin still provides the MCP server and the hook.

1. Make sure **Python 3.10 or newer** is installed.
   - Windows: from [python.org](https://www.python.org/downloads/), with
     **"Add python.exe to PATH"** checked.
   - Mac: `brew install python` (or from python.org).
2. Install the engine:

   ```
   pip install markitdown-mcp        # Windows
   pip3 install markitdown-mcp       # Mac / Linux
   ```

3. Make sure the plugin is installed (Steps 1–2 above), then **restart Claude
   Code** and verify with `/mcp` and `/hooks`.

That's the same end result as the automatic setup — just done by hand.
