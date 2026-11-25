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

# 1.5. エディタ横断のグローバルスニペット & 推奨設定配置
function Get-EditorConfigBaseDir {
    if ($IsWindows -or $env:OS -eq "Windows_NT") {
        return $BaseDataDir
    }
    elseif ($IsMacOS) {
        return (Join-Path $HOME "Library/Application Support")
    }
    else {
        if ($env:XDG_CONFIG_HOME) { return $env:XDG_CONFIG_HOME }
        return (Join-Path $HOME ".config")
    }
}

function Get-DetectedEditors {
    $editorBase = Get-EditorConfigBaseDir
    $candidates = @(
        "Antigravity IDE",
        "Antigravity",
        "Code",
        "Code - Insiders",
        "Cursor",
        "Windsurf",
        "VSCodium"
    )
    $detected = @()
    foreach ($name in $candidates) {
        $userDir = Join-Path (Join-Path $editorBase $name) "User"
        if (Test-Path $userDir -PathType Container) {
            $detected += [pscustomobject]@{
                Name    = $name
                UserDir = $userDir
            }
        }
    }
    if ($detected.Count -eq 0) {
        $detected += [pscustomobject]@{
            Name    = "Code"
            UserDir = Join-Path (Join-Path $editorBase "Code") "User"
        }
    }
    return $detected
}

function Merge-TypstSettingsJson {
    param (
        [string]$Path,
        [string]$Label
    )

    $parentDir = Split-Path -Parent $Path
    if (-not (Test-Path $Path)) {
        if (-not (Test-Path $parentDir)) {
            New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
        }
        $defaultJson = "{`n  `"[typst]`": {`n    `"editor.quickSuggestions`": {`n      `"strings`": true`n    }`n  }`n}`n"
        [System.IO.File]::WriteAllText($Path, $defaultJson, [System.Text.UTF8Encoding]::new($false))
        Write-Host "[OK] $Label settings.json created with [typst] quickSuggestions." -ForegroundColor Green
        return
    }

    $raw = Get-Content -Path $Path -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) {
        $defaultJson = "{`n  `"[typst]`": {`n    `"editor.quickSuggestions`": {`n      `"strings`": true`n    }`n  }`n}`n"
        [System.IO.File]::WriteAllText($Path, $defaultJson, [System.Text.UTF8Encoding]::new($false))
        Write-Host "[OK] $Label settings.json created with [typst] quickSuggestions." -ForegroundColor Green
        return
    }

    # JSONC のコメントを保持するため、コメントを含む場合はパース・書き換えを行わず保護する
    if (($raw -match '(?m)(^|[^:])//') -or ($raw -match '/\*')) {
        if ($raw.Contains('"[typst]"') -and $raw.Contains('"editor.quickSuggestions"') -and $raw.Contains('"strings"')) {
            Write-Host "[OK] $Label settings.json (JSONC) appears to already configure [typst] quickSuggestions; left untouched." -ForegroundColor DarkGreen
        }
        else {
            Write-Host "[INFO] Skipped $Label settings.json (JSONC comments detected; left untouched)." -ForegroundColor Yellow
        }
        return
    }

    try {
        $jsonObj = $raw | ConvertFrom-Json -ErrorAction Stop
    }
    catch {
        Write-Host "[INFO] Skipped $Label settings.json (non-strict JSON; left untouched)." -ForegroundColor Yellow
        return
    }

    if ($null -eq $jsonObj) {
        $jsonObj = New-Object PSObject
    }

    if (($null -ne $jsonObj.'[typst]') -and ($jsonObj.'[typst]' -is [System.Management.Automation.PSCustomObject]) -and
        ($null -ne $jsonObj.'[typst]'.'editor.quickSuggestions') -and ($jsonObj.'[typst]'.'editor.quickSuggestions' -is [System.Management.Automation.PSCustomObject]) -and
        ($jsonObj.'[typst]'.'editor.quickSuggestions'.'strings' -eq $true)) {
        Write-Host "[OK] $Label settings.json already enables [typst] quickSuggestions." -ForegroundColor DarkGreen
        return
    }

    if ($null -eq $jsonObj.'[typst]' -or $jsonObj.'[typst]' -isnot [System.Management.Automation.PSCustomObject]) {
        $jsonObj | Add-Member -MemberType NoteProperty -Name '[typst]' -Value (New-Object PSObject) -Force
    }
    $typstObj = $jsonObj.'[typst]'

    if ($null -eq $typstObj.'editor.quickSuggestions' -or $typstObj.'editor.quickSuggestions' -isnot [System.Management.Automation.PSCustomObject]) {
        if ($null -ne $typstObj.'editor.quickSuggestions') {
            $typstObj.psobject.Properties.Remove('editor.quickSuggestions')
        }
        $typstObj | Add-Member -MemberType NoteProperty -Name 'editor.quickSuggestions' -Value (New-Object PSObject) -Force
    }
    $qsObj = $typstObj.'editor.quickSuggestions'

    if ($null -eq $qsObj.'strings') {
        $qsObj | Add-Member -MemberType NoteProperty -Name 'strings' -Value $true -Force
    }
    else {
        $qsObj.'strings' = $true
    }

    $mergedJson = ($jsonObj | ConvertTo-Json -Depth 100) + "`n"
    [System.IO.File]::WriteAllText($Path, $mergedJson, [System.Text.UTF8Encoding]::new($false))
    Write-Host "[OK] $Label settings.json updated with [typst] quickSuggestions." -ForegroundColor Green
}

function Sync-ExistingProjectConfig {
    param ([string]$ProjectDir)

    $legacySnippet = Join-Path $ProjectDir ".vscode\typst.code-snippets"
    if (Test-Path $legacySnippet -PathType Leaf) {
        Remove-Item -Path $legacySnippet -Force
        Write-Host "[OK] Removed legacy workspace snippet: $legacySnippet (migrated to global snippets)" -ForegroundColor Green
    }

    $label = "$(Split-Path -Leaf $ProjectDir) (.vscode)"
    Merge-TypstSettingsJson -Path (Join-Path $ProjectDir ".vscode\settings.json") -Label $label

    $gitignorePath = Join-Path $ProjectDir ".gitignore"
    if (-not (Test-Path $gitignorePath)) {
        [System.IO.File]::WriteAllText($gitignorePath, "# Typst PDF output`n*.pdf`n", [System.Text.UTF8Encoding]::new($false))
        Write-Host "[OK] Created .gitignore with *.pdf exclusion: $gitignorePath" -ForegroundColor Green
    }
    else {
        $rawGi = Get-Content -Path $gitignorePath -Raw -Encoding UTF8
        $hasPdf = $false
        if ($null -ne $rawGi) {
            foreach ($line in ($rawGi -replace "`r`n", "`n") -split "`n") {
                $t = $line.Trim()
                if ($t -eq "" -or $t.StartsWith("#")) { continue }
                if ($t -eq "*.pdf" -or $t -eq "/*.pdf" -or $t -eq "**/*.pdf") {
                    $hasPdf = $true
                    break
                }
            }
        }
        if ($hasPdf) {
            Write-Host "[OK] .gitignore already excludes *.pdf." -ForegroundColor DarkGreen
        }
        else {
            $updatedGi = if ([string]::IsNullOrWhiteSpace($rawGi)) {
                "# Typst PDF output`n*.pdf`n"
            }
            elseif ($rawGi.EndsWith("`n")) {
                $rawGi + "# Typst PDF output`n*.pdf`n"
            }
            else {
                $rawGi + "`n# Typst PDF output`n*.pdf`n"
            }
            [System.IO.File]::WriteAllText($gitignorePath, $updatedGi, [System.Text.UTF8Encoding]::new($false))
            Write-Host "[OK] Added *.pdf exclusion to .gitignore: $gitignorePath" -ForegroundColor Green
        }
    }
}

$SnippetSource = Join-Path $TemplateSource ".vscode\typst.code-snippets"
if (Test-Path $SnippetSource) {
    foreach ($ed in (Get-DetectedEditors)) {
        $CodeSnippetsDir = Join-Path $ed.UserDir "snippets"
        if (-not (Test-Path $CodeSnippetsDir)) {
            New-Item -ItemType Directory -Path $CodeSnippetsDir -Force | Out-Null
        }
        $SnippetTarget = Join-Path $CodeSnippetsDir "typst-starter.code-snippets"
        Copy-Item -Path $SnippetSource -Destination $SnippetTarget -Force
        Write-Host "[OK] $($ed.Name) global snippets installed to: $SnippetTarget" -ForegroundColor Green

        Merge-TypstSettingsJson -Path (Join-Path $ed.UserDir "settings.json") -Label $ed.Name
    }
}

# 2. 既存プロジェクト設定の同期 & プロジェクト初期化 (オプション)
$BaseDir = if ($env:USERPROFILE) { $env:USERPROFILE } elseif ($HOME) { $HOME } else { (Get-Location).Path }
$DefaultProjectDir = Join-Path $BaseDir $ProjectName
if (Test-Path $DefaultProjectDir -PathType Container) {
    Write-Host "[INFO] Existing project found at: $DefaultProjectDir (syncing .vscode / .gitignore)" -ForegroundColor Cyan
    Sync-ExistingProjectConfig -ProjectDir $DefaultProjectDir
}

if ($CreateProject) {
    $TargetProjectDir = $DefaultProjectDir
    $counter = 1
    while (Test-Path $TargetProjectDir) {
        $TargetProjectDir = Join-Path $BaseDir "${ProjectName}_$counter"
        $counter++
    }

    New-Item -ItemType Directory -Path $TargetProjectDir -Force | Out-Null
    Copy-Item -Path (Join-Path $TemplateSource "*") -Destination $TargetProjectDir -Recurse -Force

    # グローバルスニペットへ統一するため、ワークスペース側の重複スニペットは除外する
    $WorkspaceSnippet = Join-Path $TargetProjectDir ".vscode\typst.code-snippets"
    if (Test-Path $WorkspaceSnippet -PathType Leaf) {
        Remove-Item -Path $WorkspaceSnippet -Force
    }

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
