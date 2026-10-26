param (
    [string]$GoPath = "go"
)

$ErrorActionPreference = "Stop"


$InstallerDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $InstallerDir
$DistDir = Join-Path $RepoRoot "dist"
$ResourcesDir = Join-Path $InstallerDir "resources"
$PackageSource = Join-Path $RepoRoot "package\starter\2.2.0"
$TemplateSource = Join-Path $RepoRoot "project-template"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Building Typst Starter Installers (Cross-Platform)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 1. リソース同期
Write-Host "[1/3] Preparing embedded resources..." -ForegroundColor Yellow
$PkgResourceDir = Join-Path $ResourcesDir "package"
$TplResourceDir = Join-Path $ResourcesDir "template"

if (Test-Path $ResourcesDir) { Remove-Item -Path $ResourcesDir -Recurse -Force }
New-Item -ItemType Directory -Path $PkgResourceDir -Force | Out-Null
New-Item -ItemType Directory -Path $TplResourceDir -Force | Out-Null

Copy-Item -Path (Join-Path $PackageSource "*") -Destination $PkgResourceDir -Recurse -Force
Copy-Item -Path (Join-Path $TemplateSource "*") -Destination $TplResourceDir -Recurse -Force
Write-Host "      [OK] Resources copied to installer/resources" -ForegroundColor Green
Write-Host ""

# 2. 出力ディレクトリ準備
Write-Host "[2/3] Preparing dist directory..." -ForegroundColor Yellow
if (-not (Test-Path $DistDir)) { New-Item -ItemType Directory -Path $DistDir -Force | Out-Null }
Write-Host ""

# 3. クロスコンパイル
Write-Host "[3/3] Cross-compiling binaries for release..." -ForegroundColor Yellow

$targets = @(
    @{ OS = "windows"; Arch = "amd64"; Output = "Typst-Starter-Setup-windows-amd64.exe" },
    @{ OS = "linux"; Arch = "amd64"; Output = "Typst-Starter-Setup-linux-amd64" },
    @{ OS = "darwin"; Arch = "amd64"; Output = "Typst-Starter-Setup-darwin-amd64" },
    @{ OS = "darwin"; Arch = "arm64"; Output = "Typst-Starter-Setup-darwin-arm64" }
)

Push-Location $InstallerDir

try {
    foreach ($t in $targets) {
        $outFile = Join-Path $DistDir $t.Output
        Write-Host "      Building for $($t.OS)/$($t.Arch) -> $($t.Output)..." -NoNewline
        
        $env:GOOS = $t.OS
        $env:GOARCH = $t.Arch
        
        & $GoPath build -ldflags="-s -w" -o $outFile .
        
        if (Test-Path $outFile) {
            $size = (Get-Item $outFile).Length / 1MB
            Write-Host (" OK ({0:N2} MB)" -f $size) -ForegroundColor Green
        }
        else {
            Write-Host " FAILED" -ForegroundColor Red
        }
    }
}
finally {
    Pop-Location
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Build Complete! Binaries generated in dist/" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Get-ChildItem -Path $DistDir | Select-Object Name, Length | Format-Table -AutoSize
