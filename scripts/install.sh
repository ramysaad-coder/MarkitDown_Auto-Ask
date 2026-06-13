#!/usr/bin/env bash
#
# markitdown-gateway — macOS / Linux bootstrap
# Ensures Python 3.10+ and the markitdown-mcp engine are installed.
# The MCP server and Read hook are provided by the plugin, so once these
# prerequisites are in place they activate after a Claude Code restart.
#
# Run:  bash install.sh
#
set -e
echo "[markitdown-gateway] Unix setup"

find_py() {
  for c in python3 python; do
    if command -v "$c" >/dev/null 2>&1; then
      v=$("$c" -c 'import sys;print("%d.%d"%sys.version_info[:2])' 2>/dev/null) || continue
      maj=${v%%.*}; min=${v##*.}
      if [ "$maj" -ge 3 ] && [ "$min" -ge 10 ]; then echo "$c"; return 0; fi
    fi
  done
  return 1
}

PY="$(find_py || true)"

if [ -z "$PY" ]; then
  echo "Python 3.10+ not found. Installing..."
  OS="$(uname -s)"
  if [ "$OS" = "Darwin" ]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Installing Homebrew (you may be prompted for your password)..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      [ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
      [ -x /usr/local/bin/brew ]   && eval "$(/usr/local/bin/brew shellenv)"
    fi
    brew install python pipx
  else
    # Linux: use the available package manager.
    if   command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y python3 python3-pip pipx
    elif command -v dnf     >/dev/null 2>&1; then sudo dnf install -y python3 python3-pip pipx
    elif command -v pacman  >/dev/null 2>&1; then sudo pacman -S --noconfirm python python-pip python-pipx
    elif command -v zypper  >/dev/null 2>&1; then sudo zypper install -y python3 python3-pip python3-pipx
    else echo "Unsupported Linux distro. Please install Python 3.10+ manually, then re-run."; exit 1
    fi
  fi
  PY="$(find_py || true)"
  [ -z "$PY" ] && { echo "Python install finished but it isn't on PATH yet. Open a NEW terminal and re-run setup."; exit 1; }
fi
echo "Using Python: $PY  ($("$PY" --version 2>&1))"

echo "Installing/upgrading markitdown-mcp..."
# pipx gives a clean, PATH-visible CLI install and sidesteps PEP 668 ("externally managed") errors.
if command -v pipx >/dev/null 2>&1; then
  pipx install markitdown-mcp 2>/dev/null || pipx upgrade markitdown-mcp || true
  pipx ensurepath >/dev/null 2>&1 || true
else
  "$PY" -m pip install --upgrade markitdown-mcp \
    || "$PY" -m pip install --user --upgrade markitdown-mcp \
    || "$PY" -m pip install --break-system-packages --upgrade markitdown-mcp
fi

if command -v markitdown-mcp >/dev/null 2>&1; then
  echo "[OK] markitdown-mcp is installed and on PATH."
else
  echo "[warn] markitdown-mcp not on PATH. Add your Python/pipx bin dir to PATH (often ~/.local/bin), then restart your shell."
fi

echo ""
echo "[done] Prerequisites ready. Restart Claude Code, then check /mcp and /hooks."
