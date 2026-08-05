param (
    [switch]$CreateProject,
    [string]$ProjectName = "My_Typst_Report"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$PackageSource = Join-Path $RepoRoot "package\starter\1.0.0"
$TemplateSource = Join-Path $RepoRoot "project-template"
$TypstDataDir = Join-Path $env:APPDATA "typst\packages\local\starter\1.0.0"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "        Typst Starter Package Installer           " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 1. パッケージ配置
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

# 2. プロジェクト初期化 (オプション)
if ($CreateProject) {
    $TargetProjectDir = Join-Path (Get-Location) $ProjectName
    $counter = 1
    while (Test-Path $TargetProjectDir) {
        $TargetProjectDir = Join-Path (Get-Location) "${ProjectName}_$counter"
        $counter++
    }
    
    New-Item -ItemType Directory -Path $TargetProjectDir -Force | Out-Null
    Copy-Item -Path (Join-Path $TemplateSource "*") -Destination $TargetProjectDir -Recurse -Force
    Write-Host "[OK] Created initial project at: $TargetProjectDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Cyan

