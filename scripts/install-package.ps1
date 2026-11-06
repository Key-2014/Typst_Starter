param (
    [switch]$CreateProject,
    [string]$ProjectName = "My_Typst",
    [ValidateSet("report", "thesis", "slide")]
    [string]$TemplateType = "report"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$PackageSource = Join-Path $RepoRoot "package\starter\2.4.0"
$TemplateSource = Join-Path $RepoRoot "project-template"

if ($IsWindows -or $env:OS -eq "Windows_NT") {
    $BaseDataDir = if ($env:APPDATA) { $env:APPDATA } else { Join-Path $HOME "AppData\Roaming" }
}
elseif ($env:XDG_DATA_HOME) {
    $BaseDataDir = $env:XDG_DATA_HOME
}
else {
    $BaseDataDir = Join-Path $HOME ".local/share"
}
$TypstDataDir = Join-Path $BaseDataDir "typst\packages\local\starter\2.4.0"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "     Typst Starter Package Installer v2.4.0       " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 1. パッケージ配置 (2.4.0)
if (-not (Test-Path $PackageSource)) {
    Write-Host "[ERROR] Package source not found: $PackageSource" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $TypstDataDir)) {
    New-Item -ItemType Directory -Path $TypstDataDir -Force | Out-Null
    Write-Host "[OK] Created directory: $TypstDataDir" -ForegroundColor Green
}

Copy-Item -Path (Join-Path $PackageSource "*") -Destination $TypstDataDir -Recurse -Force
Write-Host "[OK] Package (@local/starter:2.4.0) installed to: $TypstDataDir" -ForegroundColor Green

# 1.5. VS Code グローバルスニペット配置
$SnippetSource = Join-Path $TemplateSource ".vscode\typst.code-snippets"
if (Test-Path $SnippetSource) {
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        $CodeSnippetsDir = Join-Path $BaseDataDir "Code\User\snippets"
    }
    elseif ($IsMacOS) {
        $CodeSnippetsDir = Join-Path $HOME "Library/Application Support/Code/User/snippets"
    }
    else {
        $ConfigBase = if ($env:XDG_CONFIG_HOME) { $env:XDG_CONFIG_HOME } else { Join-Path $HOME ".config" }
        $CodeSnippetsDir = Join-Path $ConfigBase "Code/User/snippets"
    }

    if (-not (Test-Path $CodeSnippetsDir)) {
        New-Item -ItemType Directory -Path $CodeSnippetsDir -Force | Out-Null
    }
    $SnippetTarget = Join-Path $CodeSnippetsDir "typst-starter.code-snippets"
    Copy-Item -Path $SnippetSource -Destination $SnippetTarget -Force
    Write-Host "[OK] VS Code global snippets installed to: $SnippetTarget" -ForegroundColor Green
}

# 2. プロジェクト初期化 (オプション)
if ($CreateProject) {
    $BaseDir = if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { (Get-Location).Path }
    $TargetProjectDir = Join-Path $BaseDir $ProjectName
    $counter = 1
    while (Test-Path $TargetProjectDir) {
        $TargetProjectDir = Join-Path $BaseDir "${ProjectName}_$counter"
        $counter++
    }

    New-Item -ItemType Directory -Path $TargetProjectDir -Force | Out-Null
    Copy-Item -Path (Join-Path $TemplateSource "*") -Destination $TargetProjectDir -Recurse -Force

    if ($TemplateType -eq "thesis") {
        $ThesisSample = Join-Path $RepoRoot "examples\07_Thesis\main.typ"
        if (Test-Path $ThesisSample) {
            Copy-Item -Path $ThesisSample -Destination (Join-Path $TargetProjectDir "main.typ") -Force
        }
    }
    elseif ($TemplateType -eq "slide") {
        $SlideSample = Join-Path $RepoRoot "examples\06_Slide\main.typ"
        if (Test-Path $SlideSample) {
            Copy-Item -Path $SlideSample -Destination (Join-Path $TargetProjectDir "main.typ") -Force
        }
    }

    Write-Host "[OK] Created initial project ($TemplateType) at: $TargetProjectDir" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation complete!" -ForegroundColor Cyan
