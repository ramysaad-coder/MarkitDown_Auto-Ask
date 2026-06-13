#!/usr/bin/env python3
"""PreToolUse hook for the Read tool (markitdown gateway).

When Claude is about to Read a file whose type the markitdown MCP server can
convert, this BLOCKS the read and tells Claude to ask the user how to proceed:

    Convert to Markdown  (primary)  -> markitdown MCP convert_to_markdown
    Read as-is                       -> read the raw file with the Read tool

Because the Read tool's own Approve/Reject prompt always means
"run the read", we can't make Approve trigger a conversion. So instead the
hook denies the read and Claude drives an explicit two-option question where
"Convert" is the primary (approve) choice.

Loop-breaker: when the user chooses "Read as-is", Claude writes the target
path into a one-shot bypass marker and retries the Read. The hook sees the
matching marker, consumes (deletes) it, and lets that single read through.

For any other file type the hook stays silent (exit 0) and the Read proceeds
normally. Input is the PreToolUse JSON payload on stdin.
"""
import sys
import json
import os

# File extensions the markitdown MCP server knows how to convert.
SUPPORTED = {
    ".pdf",
    ".docx", ".doc", ".docm",
    ".pptx", ".ppt", ".pptm",
    ".xlsx", ".xls", ".xlsm",
    ".html", ".htm",
    ".csv", ".json", ".xml",
    ".epub", ".msg", ".zip", ".ipynb",
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".tif", ".tiff", ".webp",
    ".wav", ".mp3", ".m4a", ".mp4", ".flac", ".ogg", ".aac", ".opus",
}

# One-shot "read as-is" bypass marker, lives next to this script.
MARKER = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                      ".markitdown-bypass")


def _norm(p):
    return os.path.normcase(os.path.normpath(os.path.abspath(p)))


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        return  # malformed input -> don't block the read

    tool_input = data.get("tool_input") or {}
    path = tool_input.get("file_path") or ""
    ext = os.path.splitext(path)[1].lower()

    if ext not in SUPPORTED:
        return  # not a markitdown type -> read normally, no prompt

    # One-shot bypass: user chose "Read as-is" and Claude wrote this path.
    if os.path.exists(MARKER):
        try:
            with open(MARKER, "r", encoding="utf-8") as fh:
                wanted = fh.read().strip()
        except Exception:
            wanted = ""
        # Consume the marker no matter what so it never goes stale.
        try:
            os.remove(MARKER)
        except OSError:
            pass
        if wanted and path and _norm(wanted) == _norm(path):
            return  # allow this single read-as-is to go through

    reason = (
        "markitdown-supported file ({0}). Ask the user with AskUserQuestion, "
        "two options:\n"
        "  1. 'Convert to Markdown' (recommended) -> call the markitdown MCP "
        "tool convert_to_markdown with uri='file:///{1}'.\n"
        "  2. 'Read as-is' -> write the exact path '{1}' (no quotes) to the "
        "file '{2}', then retry the same Read.\n"
        "Do NOT read this file until the user has chosen."
    ).format(ext, path.replace("\\", "/"), MARKER.replace("\\", "/"))

    out = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "permissionDecision": "deny",
            "permissionDecisionReason": reason,
        }
    }
    print(json.dumps(out))


if __name__ == "__main__":
    main()
    sys.exit(0)
