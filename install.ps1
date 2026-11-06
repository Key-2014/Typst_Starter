# Typst Starter Windows Installer Script
# Usage (PowerShell or cmd.exe):
#   powershell -NoProfile -ExecutionPolicy Bypass -c "irm https://raw.githubusercontent.com/Key-2014/Typst_Starter/main/install.ps1 | iex"

$ErrorActionPreference = "Stop"

$RepoOwner = "Key-2014"
$RepoName = "Typst_Starter"
$BinaryName = "Typst-Starter-Setup-windows-amd64.exe"
$DownloadUrl = "https://github.com/$RepoOwner/$RepoName/releases/latest/download/$BinaryName"

$LocalAppData = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { Join-Path $HOME "AppData\Local" }
$BinDir = Join-Path $LocalAppData "TypstStarter\bin"
$ExePath = Join-Path $BinDir "typst-starter.exe"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "         Typst Starter Quick Installer            " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path $BinDir)) {
    New-Item -ItemType Directory -Path $BinDir -Force | Out-Null
}

Write-Host "[1/2] Downloading latest Typst Starter setup..." -ForegroundColor Yellow
$OldPath = "$ExePath.old"
if (Test-Path $ExePath) {
    Remove-Item $OldPath -ErrorAction SilentlyContinue
    Rename-Item -Path $ExePath -NewName "$ExePath.old" -Force -ErrorAction SilentlyContinue
}

try {
    # Use Invoke-WebRequest / curl
    Invoke-WebRequest -Uri $DownloadUrl -OutFile $ExePath -UseBasicParsing
    Remove-Item $OldPath -ErrorAction SilentlyContinue
    Write-Host "      [OK] Downloaded to: $ExePath" -ForegroundColor Green
}
catch {
    Write-Host "[ERROR] Failed to download from $DownloadUrl" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# ユーザー環境変数 PATH への登録
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $userPath) { $userPath = "" }
$paths = $userPath -split ';' | Where-Object { $_ -ne '' }
if ($paths -notcontains $BinDir) {
    $newPath = ($paths + $BinDir) -join ';'
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "      [OK] Added $BinDir to User PATH." -ForegroundColor Green
}

# 現在のプロセス PATH にも追加
if (($env:Path -split ';') -notcontains $BinDir) {
    $env:Path = "$BinDir;$env:Path"
}

Write-Host ""
Write-Host "[2/2] Running setup..." -ForegroundColor Yellow
& $ExePath --silent

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Installation Complete!" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now use the 'typst-starter' command from any terminal:"
Write-Host "  typst-starter update            Update package to latest"
Write-Host "  typst-starter init              Create a report project"
Write-Host "  typst-starter init thesis       Create a thesis project"
Write-Host "  typst-starter init slide        Create a slide project"
Write-Host ""
