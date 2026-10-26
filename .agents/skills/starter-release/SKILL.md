---
name: starter-release
description: Automates version bumping, template export, and GitHub release workflows for Typst_Template and Typst_Starter. Use when the user requests to bump the Typst_Template version, sync/export to Typst_Starter, or create a release for Typst_Starter.
---

# Typst Release Workflow Skill

This skill automates version upgrades, template exports, and GitHub Releases across `Typst_Template` (private/core) and `Typst_Starter` (public/distribution).

---

## 1. Supported Scenarios

| Scenario | User Trigger Examples | Actions Taken |
| :--- | :--- | :--- |
| **A. Template Bump Only** | "Templateを0.3.0にアップデートして"<br>"Bump Typst_Template version to 0.3.0" | Updates package references in `Typst_Template`, updates local package junction, tests examples, and commits. |
| **B. Starter Release (Template-Linked)** | "Templateの変更を反映してStarterを2.3.0にリリースして"<br>"Starterを2.3.0にバージョンアップしてリリース" | Runs `export-to-starter.ps1`, updates Starter files, compiles installers, tags, creates GitHub Release, and uploads binary assets. |
| **C. Full Release (Both)** | "Templateを0.3.0にして、Starterも2.3.0にリリースして"<br>"Update Template to 0.3.0 and release Starter 2.3.0" | Executes Scenario A, then runs Scenario B sequentially. |

---

## 2. Detailed Procedures

### Scenario A: Bump Typst_Template Version

When bumping the local package `@local/typst-template:<OldVersion>` to `<NewVersion>`:

1. **Locate and Update Version References in `Typst_Template`**:
   - `typst.toml`: Update `version = "<NewVersion>"`
   - `lib.typ`: Update header comment `// Package Entrypoint for @local/typst-template:<NewVersion>`
   - `install-local.ps1`: Update `$PackageVersion = "<NewVersion>"`
   - `init.ps1`: Update `$PackageVersion = "<NewVersion>"`
   - `README.md`: Replace all `@local/typst-template:<OldVersion>` with `@local/typst-template:<NewVersion>`
   - `.vscode/typst.code-snippets`: Update import statements and descriptions to `<NewVersion>`
   - `init_module/.vscode/typst.code-snippets`: Update import statements and descriptions to `<NewVersion>`
   - `.github/workflows/compile-typst.yml`: Update step name and `PACKAGE_DIR` version path to `<NewVersion>`
   - `init_module/.github/workflows/compile-typst.yml`: Update step name and `PACKAGE_DIR` version path to `<NewVersion>`
   - `examples/*.typ`: Update `#import "@local/typst-template:<NewVersion>": *`

2. **Re-register Local Package**:
   ```powershell
   pwsh .\install-local.ps1
   ```

3. **Verify Examples**:
   ```powershell
   pwsh -Command '
   Get-ChildItem -Path examples -Filter "*.typ" | ForEach-Object {
       typst compile $_.FullName "$($_.DirectoryName)/test_temp.pdf"
       if ($LASTEXITCODE -ne 0) { throw "Compilation failed for $($_.FullName)" }
       Remove-Item "$($_.DirectoryName)/test_temp.pdf" -ErrorAction SilentlyContinue
   }
   Write-Host "All template examples compiled successfully!" -ForegroundColor Green
   '
   ```

4. **Git Commit & Push**:
   ```powershell
   git add .
   git commit -m "chore: bump template package version to <NewVersion>"
   git push origin main
   ```

---

### Scenario B: Export & Release Typst_Starter

When releasing `Typst_Starter` version `<StarterVersion>` (e.g., `2.3.0`):

1. **Analyze Recent Commits & Generate Release Notes**:
   - Run `git log` since the previous release in `Typst_Template` (and `Typst_Starter`).
   - Extract key features, fixes, and refactorings.
   - Compose release notes in standard markdown with sections:
     - `## What's Changed in v<StarterVersion>`
     - `### 🚀 主な新機能・改善点`
     - `### 📦 パッケージの利用方法`
     - `### 📥 インストーラーによるセットアップ`

2. **Update `export-to-starter.ps1` Default Version**:
   - Update `[string]$Version = "<StarterVersion>"` in `export-to-starter.ps1`.
   - Update synopsis comment to reflect `<StarterVersion>`.

3. **Run Export Script**:
   ```powershell
   pwsh .\export-to-starter.ps1 -Version "<StarterVersion>"
   ```
   *(This bootstraps `package/starter/<StarterVersion>`, exports allowlisted files, and registers `@local/starter:<StarterVersion>`)*

4. **Update Typst_Starter Files to `<StarterVersion>`**:
   - `examples/*/main.typ` & `project-template/main.typ`: `#import "@local/starter:<StarterVersion>": *`
   - `installer/main.go`: Update banner `v<StarterVersion>` and target path string `"<StarterVersion>"`
   - `installer/build.ps1`: Update `$PackageSource = Join-Path $RepoRoot "package\starter\<StarterVersion>"`
   - `scripts/install-package.ps1`: Update banner, `$PackageSource`, and `$TypstDataDir` to `<StarterVersion>`
   - `.github/workflows/ci.yml`: Add/update `<StarterVersion>` directory setup
   - `README.md`, `examples/README.md`, `package/README.md`, `scripts/README.md`: Update version text
   - `CHANGELOG.md`: Prepend `## [<StarterVersion>] - YYYY-MM-DD` release notes
   - `project-template/.vscode/typst.code-snippets`: Ensure snippet imports match `@local/starter:<StarterVersion>` (confirm no personal data/PII)

5. **Rebuild Cross-Platform Go Installers**:
   ```powershell
   pwsh .\installer\build.ps1
   ```
   *Verifies generation of 4 binaries in `dist/`: Windows amd64, Linux amd64, macOS amd64, macOS arm64.*

6. **Verify Examples & Check PII**:
   - Compile all `Typst_Starter` examples:
     ```powershell
     pwsh -Command '
     $ex = Get-ChildItem -Path .\examples -Filter "main.typ" -Recurse
     $ex += Get-ChildItem -Path .\project-template -Filter "main.typ"
     foreach ($f in $ex) {
         typst compile $f.FullName "$($f.DirectoryName)/temp_check.pdf"
         if ($LASTEXITCODE -ne 0) { throw "Failed: $($f.FullName)" }
         Remove-Item "$($f.DirectoryName)/temp_check.pdf" -ErrorAction SilentlyContinue
     }
     Write-Host "All Typst_Starter examples verified!" -ForegroundColor Green
     '
     ```
   - Run PII scan on changed files. Never commit student IDs, real names, or supervisor names to `Typst_Starter`.

7. **Git Commit, Tag & Push**:
   ```powershell
   git add .
   git commit -m "v<StarterVersion>: Release v<StarterVersion> with <summary of changes>"
   git tag -a "v<StarterVersion>" -m "Release v<StarterVersion>: <summary of changes>"
   git push origin main
   git push origin "v<StarterVersion>"
   ```

8. **Automate GitHub Release & Asset Uploads**:
   Execute the following automated PowerShell block to create the GitHub Release and upload all 4 dist binaries:
   ```powershell
   pwsh -Command '
   # Retrieve GitHub token from Git credential helper
   $psi = New-Object System.Diagnostics.ProcessStartInfo
   $psi.FileName = "git"
   $psi.Arguments = "credential fill"
   $psi.RedirectStandardInput = $true
   $psi.RedirectStandardOutput = $true
   $psi.UseShellExecute = $false
   $psi.CreateNoWindow = $true
   $p = [System.Diagnostics.Process]::Start($psi)
   $p.StandardInput.WriteLine("protocol=https")
   $p.StandardInput.WriteLine("host=github.com")
   $p.StandardInput.WriteLine("")
   $p.StandardInput.Close()
   $out = $p.StandardOutput.ReadToEnd()
   $p.WaitForExit()

   $token = ""
   foreach ($line in ($out -split "`r?`n")) {
       if ($line -like "password=*") { $token = $line.Substring("password=".Length); break }
   }
   if (-not $token) { throw "GitHub credentials not found." }

   $tag = "v<StarterVersion>"
   $releaseData = @{
       tag_name = $tag
       name = "Typst Starter $tag"
       body = @"<ReleaseBodyText>"@
       draft = $false
       prerelease = $false
   } | ConvertTo-Json

   $headers = @{
       "Authorization" = "token $token"
       "Accept" = "application/vnd.github.v3+json"
       "User-Agent" = "Typst-Release-Agent"
   }
   $resp = Invoke-RestMethod -Uri "https://api.github.com/repos/Key-2014/Typst_Starter/releases" -Method Post -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($releaseData)) -ContentType "application/json; charset=utf-8"

   $uploadBase = $resp.upload_url -replace "\{\?name,label\}", ""
   $distDir = (Resolve-Path ".\dist").Path
   foreach ($asset in (Get-ChildItem -Path $distDir -File)) {
       $uri = "$($uploadBase)?name=$($asset.Name)"
       $bytes = [System.IO.File]::ReadAllBytes($asset.FullName)
       $h = @{ "Authorization" = "token $token"; "User-Agent" = "Typst-Release-Agent" }
       Invoke-RestMethod -Uri $uri -Method Post -Headers $h -Body $bytes -ContentType "application/octet-stream" | Out-Null
       Write-Host "Uploaded $($asset.Name)" -ForegroundColor Green
   }
   Write-Host "Release created: $($resp.html_url)" -ForegroundColor Cyan
   '
   ```

9. **Commit Template Changes (if any)**:
   ```powershell
   git add export-to-starter.ps1
   git commit -m "chore: bump default export version to <StarterVersion> in export-to-starter.ps1"
   git push origin main
   ```
