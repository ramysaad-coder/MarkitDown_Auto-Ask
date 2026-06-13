<#
  markitdown-gateway — Windows bootstrap
  Ensures Python 3.10+ and the markitdown-mcp engine are installed.
  The MCP server and Read hook themselves are provided by the plugin, so once
  these prerequisites are in place they activate after a Claude Code restart.

  Run:  powershell -ExecutionPolicy Bypass -File install.ps1
#>
$ErrorActionPreference = 'Stop'
Write-Host "[markitdown-gateway] Windows setup" -ForegroundColor Cyan

function Find-Python {
    foreach ($exe in @('python', 'py')) {
        $cmd = Get-Command $exe -ErrorAction SilentlyContinue
        if (-not $cmd) { continue }
        try {
            if ($exe -eq 'py') { $ver = & $exe -3 --version 2>&1 } else { $ver = & $exe --version 2>&1 }
        } catch { continue }
        if ("$ver" -match 'Python (\d+)\.(\d+)') {
            $maj = [int]$Matches[1]; $min = [int]$Matches[2]
            if ($maj -gt 3 -or ($maj -eq 3 -and $min -ge 10)) {
                if ($exe -eq 'py') { return 'py -3' } else { return 'python' }
            }
        }
    }
    return $null
}

function Invoke-Py([string]$pyCmd, [string[]]$pyArgs) {
    if ($pyCmd -eq 'py -3') { & py -3 @pyArgs } else { & python @pyArgs }
}

$py = Find-Python
if (-not $py) {
    Write-Host "Python 3.10+ not found. Installing via winget (please approve)..." -ForegroundColor Yellow
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "winget is unavailable. Install Python 3.10+ from https://www.python.org/downloads/ with 'Add python.exe to PATH' checked, then re-run setup."
    }
    winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    # Refresh PATH for the current process so the new python is visible.
    $machine = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [System.Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
    $py = Find-Python
    if (-not $py) {
        throw "Python was installed but isn't on PATH yet. Open a NEW terminal (or restart) and re-run setup."
    }
}
Write-Host "Using Python: $py  ($(Invoke-Py $py @('--version')))" -ForegroundColor Green

Write-Host "Installing/upgrading markitdown-mcp (please approve)..." -ForegroundColor Yellow
Invoke-Py $py @('-m', 'pip', 'install', '--upgrade', 'pip')
Invoke-Py $py @('-m', 'pip', 'install', '--upgrade', 'markitdown-mcp')

if (Get-Command markitdown-mcp -ErrorAction SilentlyContinue) {
    Write-Host "[OK] markitdown-mcp is installed and on PATH." -ForegroundColor Green
} else {
    Write-Host "[warn] markitdown-mcp installed but not found on PATH. Ensure your Python 'Scripts' directory is on PATH (re-run the python.org installer with 'Add to PATH')." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "[done] Prerequisites ready. Restart Claude Code, then check /mcp and /hooks." -ForegroundColor Cyan
