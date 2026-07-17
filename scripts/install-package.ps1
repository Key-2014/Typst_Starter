$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$PackageSource = Join-Path $RepoRoot "package\starter\1.0.0"
$TypstDataDir = Join-Path $env:APPDATA "typst\packages\local\starter\1.0.0"

if (-not (Test-Path $PackageSource)) {
    Write-Host "[ERROR] Package source not found: $PackageSource" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $TypstDataDir)) {
    New-Item -ItemType Directory -Path $TypstDataDir -Force | Out-Null
    Write-Host "[OK] Created directory: $TypstDataDir" -ForegroundColor Green
}

Copy-Item -Path (Join-Path $PackageSource "*") -Destination $TypstDataDir -Recurse -Force
Write-Host "[OK] Package installed to: $TypstDataDir" -ForegroundColor Green

Write-Host ""
Write-Host "Installed files:" -ForegroundColor Cyan
Get-ChildItem -Path $TypstDataDir -Recurse -File | ForEach-Object {
    Write-Host "  $($_.Name)" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Cyan
