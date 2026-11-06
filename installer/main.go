package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"io"
	"io/fs"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"
	"time"
)

const (
	Version   = "2.4.0"
	RepoOwner = "Key-2014"
	RepoName  = "Typst_Starter"
)

type Config struct {
	Silent        bool
	PackageOnly   bool
	CreateProject bool
}

func main() {
	args := os.Args[1:]

	if len(args) > 0 {
		switch args[0] {
		case "version", "-v", "--version":
			fmt.Printf("Typst Starter v%s\n", Version)
			return
		case "help", "-h", "--help":
			printHelp()
			return
		case "update":
			runUpdate()
			return
		case "init":
			runInit(args[1:])
			return
		}
	}

	cfg := Config{}
	for _, arg := range args {
		switch arg {
		case "--silent", "-s", "-y":
			cfg.Silent = true
		case "--package-only":
			cfg.PackageOnly = true
		case "--create-project":
			cfg.CreateProject = true
		case "-v", "--version":
			fmt.Printf("Typst Starter v%s\n", Version)
			return
		case "-h", "--help":
			printHelp()
			return
		}
	}

	runInstall(cfg)
}

func printHelp() {
	fmt.Printf("Typst Starter v%s\n", Version)
	fmt.Println()
	fmt.Println("Usage:")
	fmt.Println("  typst-starter [flags]")
	fmt.Println("  typst-starter <command> [arguments]")
	fmt.Println()
	fmt.Println("Commands:")
	fmt.Println("  update                  Check and update to the latest Typst Starter package")
	fmt.Println("  init [template] [name]  Create a new Typst project (template: report, thesis, slide)")
	fmt.Println("  version                 Show current version")
	fmt.Println("  help                    Show this help message")
	fmt.Println()
	fmt.Println("Flags:")
	fmt.Println("  -s, --silent            Non-interactive mode (do not wait for Enter key)")
	fmt.Println("  --package-only          Install package and CLI only (skip project creation)")
	fmt.Println("  --create-project        Always create a new project directory even if ~/My_Typst exists")
	fmt.Println("  -v, --version           Show current version")
	fmt.Println("  -h, --help              Show help message")
}

func runInstall(cfg Config) {
	fmt.Println("==================================================")
	fmt.Printf("        Typst Starter Installer v%s            \n", Version)
	fmt.Println("==================================================")
	fmt.Println()

	// 1. パッケージ配置先ディレクトリの特定
	packageDir, err := getTypstPackageDir()
	if err != nil {
		fmt.Printf("[ERROR] Failed to determine Typst package directory: %v\n", err)
		exitWithPause(1, cfg.Silent)
	}

	fmt.Printf("[1/4] Installing Typst Starter package...\n")
	fmt.Printf("      Target: %s\n", packageDir)

	if err := extractFS(embeddedPackageFS, "resources/package", packageDir); err != nil {
		fmt.Printf("[ERROR] Failed to extract package: %v\n", err)
		exitWithPause(1, cfg.Silent)
	}
	fmt.Println("      [OK] Package installed successfully.")
	fmt.Println()

	// 2. VS Code グローバルスニペットの配置
	fmt.Printf("[2/4] Installing VS Code global snippets...\n")
	if snippetPath, err := installVSCodeSnippets(); err != nil {
		fmt.Printf("      [WARNING] Failed to install VS Code snippets: %v\n", err)
	} else {
		fmt.Printf("      Target: %s\n", snippetPath)
		fmt.Println("      [OK] Global snippets installed successfully.")
	}
	fmt.Println()

	// 3. CLI 自身のインストール & PATH 登録
	fmt.Printf("[3/4] Setting up typst-starter CLI tool...\n")
	if err := installCLI(); err != nil {
		fmt.Printf("      [WARNING] CLI setup encountered an issue: %v\n", err)
	} else {
		fmt.Println("      [OK] CLI tool configured.")
	}
	fmt.Println()

	// 4. プロジェクト作成先の決定
	if cfg.PackageOnly {
		fmt.Println("[4/4] Skipping project creation (--package-only specified).")
	} else {
		fmt.Printf("[4/4] Setting up project directory...\n")
		targetProjectDir, skipped, err := getTargetProjectDir("My_Typst", cfg.CreateProject)
		if err != nil {
			fmt.Printf("[ERROR] Failed to determine project directory: %v\n", err)
			exitWithPause(1, cfg.Silent)
		}

		if skipped {
			fmt.Printf("      [INFO] Existing project found at: %s\n", targetProjectDir)
			fmt.Println("             Skipped creating a duplicate. Run 'typst-starter init' to create a new project.")
		} else {
			if err := extractFS(embeddedTemplateFS, "resources/template", targetProjectDir); err != nil {
				fmt.Printf("[ERROR] Failed to create project directory: %v\n", err)
				exitWithPause(1, cfg.Silent)
			}
			fmt.Printf("      [OK] Initial project created at: %s\n", targetProjectDir)
		}
	}
	fmt.Println()

	fmt.Println("==================================================")
	fmt.Println("Installation Completed Successfully!")
	fmt.Println("==================================================")
	fmt.Println()
	fmt.Println("Commands available:")
	fmt.Println("  typst-starter update            Update package to the latest release")
	fmt.Println("  typst-starter init              Create a new report project")
	fmt.Println("  typst-starter init thesis       Create a new graduation thesis project")
	fmt.Println("  typst-starter init slide        Create a new slide presentation project")
	fmt.Println()

	exitWithPause(0, cfg.Silent)
}

func runInit(args []string) {
	templateType := "report"
	projectName := ""

	if len(args) > 0 {
		arg0 := strings.ToLower(args[0])
		if arg0 == "report" || arg0 == "thesis" || arg0 == "slide" {
			templateType = arg0
			if len(args) > 1 {
				projectName = args[1]
			}
		} else {
			projectName = args[0]
		}
	}

	if projectName == "" {
		switch templateType {
		case "thesis":
			projectName = "My_Thesis"
		case "slide":
			projectName = "My_Slide"
		default:
			projectName = "My_Typst"
		}
	}

	baseDir, err := os.UserHomeDir()
	if err != nil || baseDir == "" {
		baseDir = "."
	}

	// 常に重複しない名前を生成
	targetPath := filepath.Join(baseDir, projectName)
	if _, err := os.Stat(targetPath); err == nil {
		counter := 1
		for {
			cand := filepath.Join(baseDir, fmt.Sprintf("%s_%d", projectName, counter))
			if _, err := os.Stat(cand); os.IsNotExist(err) {
				targetPath = cand
				break
			}
			counter++
		}
	}

	fmt.Printf("Creating %s project at: %s ...\n", templateType, targetPath)

	if err := extractFS(embeddedTemplateFS, "resources/template", targetPath); err != nil {
		fmt.Printf("[ERROR] Failed to create project: %v\n", err)
		os.Exit(1)
	}

	// thesis または slide の場合は main.typ を上書き
	if templateType == "thesis" {
		if content, err := embeddedVariantsFS.ReadFile("resources/variants/thesis.typ"); err == nil {
			_ = os.WriteFile(filepath.Join(targetPath, "main.typ"), content, 0644)
		}
	} else if templateType == "slide" {
		if content, err := embeddedVariantsFS.ReadFile("resources/variants/slide.typ"); err == nil {
			_ = os.WriteFile(filepath.Join(targetPath, "main.typ"), content, 0644)
		}
	}

	fmt.Println("[OK] Project created successfully!")
	fmt.Printf("Open the folder in VSCode: %s\n", targetPath)
}

type gitHubRelease struct {
	TagName string `json:"tag_name"`
	Assets  []struct {
		Name               string `json:"name"`
		BrowserDownloadURL string `json:"browser_download_url"`
	} `json:"assets"`
}

func runUpdate() {
	fmt.Printf("Checking for updates (current version: v%s)...\n", Version)

	client := &http.Client{Timeout: 15 * time.Second}
	req, err := http.NewRequest("GET", fmt.Sprintf("https://api.github.com/repos/%s/%s/releases/latest", RepoOwner, RepoName), nil)
	if err != nil {
		fmt.Printf("[ERROR] Failed to create update request: %v\n", err)
		os.Exit(1)
	}
	req.Header.Set("User-Agent", "Typst-Starter-CLI")

	resp, err := client.Do(req)
	if err != nil {
		fmt.Printf("[ERROR] Failed to connect to GitHub: %v\n", err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		fmt.Printf("[ERROR] GitHub returned status %s\n", resp.Status)
		os.Exit(1)
	}

	var rel gitHubRelease
	if err := json.NewDecoder(resp.Body).Decode(&rel); err != nil {
		fmt.Printf("[ERROR] Failed to parse release info: %v\n", err)
		os.Exit(1)
	}

	latestVer := strings.TrimPrefix(rel.TagName, "v")
	fmt.Printf("Latest available version: v%s\n", latestVer)

	if latestVer == Version {
		fmt.Println("You already have the latest version installed.")
		fmt.Println("Re-installing package files to ensure completeness...")
	} else {
		fmt.Printf("Updating from v%s -> v%s ...\n", Version, latestVer)
	}

	// 適切なアセットを特定
	expectedAsset := getExpectedAssetName()
	var downloadURL string
	for _, a := range rel.Assets {
		if a.Name == expectedAsset {
			downloadURL = a.BrowserDownloadURL
			break
		}
	}

	if downloadURL == "" {
		fmt.Printf("[ERROR] Could not find release asset '%s' for your platform.\n", expectedAsset)
		os.Exit(1)
	}

	// 一時ファイルにダウンロード
	tmpFile, err := os.CreateTemp("", "typst-starter-update-*"+filepath.Ext(expectedAsset))
	if err != nil {
		fmt.Printf("[ERROR] Failed to create temp file: %v\n", err)
		os.Exit(1)
	}
	tmpPath := tmpFile.Name()
	defer os.Remove(tmpPath)

	fmt.Printf("Downloading %s ...\n", expectedAsset)
	dlResp, err := client.Get(downloadURL)
	if err != nil {
		tmpFile.Close()
		fmt.Printf("[ERROR] Download failed: %v\n", err)
		os.Exit(1)
	}
	defer dlResp.Body.Close()

	if _, err := io.Copy(tmpFile, dlResp.Body); err != nil {
		tmpFile.Close()
		fmt.Printf("[ERROR] Failed to write downloaded file: %v\n", err)
		os.Exit(1)
	}
	tmpFile.Close()

	_ = os.Chmod(tmpPath, 0755)

	fmt.Println("Applying update...")
	cmd := exec.Command(tmpPath, "--package-only", "--silent")
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	if err := cmd.Run(); err != nil {
		fmt.Printf("[ERROR] Update execution failed: %v\n", err)
		os.Exit(1)
	}

	fmt.Println()
	fmt.Printf("[OK] Successfully updated to Typst Starter v%s!\n", latestVer)
}

func getExpectedAssetName() string {
	osName := runtime.GOOS
	archName := runtime.GOARCH

	switch osName {
	case "windows":
		return "Typst-Starter-Setup-windows-amd64.exe"
	case "darwin":
		if archName == "arm64" {
			return "Typst-Starter-Setup-darwin-arm64"
		}
		return "Typst-Starter-Setup-darwin-amd64"
	case "linux":
		return "Typst-Starter-Setup-linux-amd64"
	default:
		return fmt.Sprintf("Typst-Starter-Setup-%s-%s", osName, archName)
	}
}

// OS別のVS Codeユーザースニペットディレクトリを返します
func getVSCodeSnippetsDir() (string, error) {
	switch runtime.GOOS {
	case "windows":
		appData := os.Getenv("APPDATA")
		if appData == "" {
			home, err := os.UserHomeDir()
			if err != nil {
				return "", err
			}
			appData = filepath.Join(home, "AppData", "Roaming")
		}
		return filepath.Join(appData, "Code", "User", "snippets"), nil
	case "darwin":
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, "Library", "Application Support", "Code", "User", "snippets"), nil
	default: // linux 等
		if xdgConfig := os.Getenv("XDG_CONFIG_HOME"); xdgConfig != "" {
			return filepath.Join(xdgConfig, "Code", "User", "snippets"), nil
		}
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, ".config", "Code", "User", "snippets"), nil
	}
}

// VS Codeグローバルスニペット (typst-starter.code-snippets) を配置します
func installVSCodeSnippets() (string, error) {
	snippetsDir, err := getVSCodeSnippetsDir()
	if err != nil {
		return "", err
	}

	if err := os.MkdirAll(snippetsDir, 0755); err != nil {
		return "", err
	}

	content, err := embeddedTemplateFS.ReadFile("resources/template/.vscode/typst.code-snippets")
	if err != nil {
		return "", fmt.Errorf("failed to read embedded snippets: %w", err)
	}

	targetFile := filepath.Join(snippetsDir, "typst-starter.code-snippets")
	if err := os.WriteFile(targetFile, content, 0644); err != nil {
		return "", fmt.Errorf("failed to write snippets to %s: %w", targetFile, err)
	}

	return targetFile, nil
}

// OS別のTypstローカルパッケージディレクトリを返します
func getTypstPackageDir() (string, error) {
	if runtime.GOOS == "windows" {
		appData := os.Getenv("APPDATA")
		if appData == "" {
			home, err := os.UserHomeDir()
			if err != nil {
				return "", err
			}
			appData = filepath.Join(home, "AppData", "Roaming")
		}
		return filepath.Join(appData, "typst", "packages", "local", "starter", Version), nil
	}

	// macOS / Linux
	if xdgData := os.Getenv("XDG_DATA_HOME"); xdgData != "" {
		return filepath.Join(xdgData, "typst", "packages", "local", "starter", Version), nil
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(home, ".local", "share", "typst", "packages", "local", "starter", Version), nil
}

// CLIバイナリを固定パスへ配置し、環境変数PATHを構成します
func installCLI() error {
	selfPath, err := os.Executable()
	if err != nil {
		return err
	}
	selfPath, _ = filepath.EvalSymlinks(selfPath)

	var targetDir string
	var targetBinName string

	if runtime.GOOS == "windows" {
		localAppData := os.Getenv("LOCALAPPDATA")
		if localAppData == "" {
			home, err := os.UserHomeDir()
			if err != nil {
				return err
			}
			localAppData = filepath.Join(home, "AppData", "Local")
		}
		targetDir = filepath.Join(localAppData, "TypstStarter", "bin")
		targetBinName = "typst-starter.exe"
	} else {
		home, err := os.UserHomeDir()
		if err != nil {
			return err
		}
		targetDir = filepath.Join(home, ".local", "bin")
		targetBinName = "typst-starter"
	}

	if err := os.MkdirAll(targetDir, 0755); err != nil {
		return err
	}

	targetPath := filepath.Join(targetDir, targetBinName)

	// すでにターゲット位置から実行されている場合はコピー不要
	if strings.EqualFold(selfPath, targetPath) {
		ensurePATH(targetDir)
		return nil
	}

	// コピー処理（ロックされている場合は旧ファイルを退避）
	if _, err := os.Stat(targetPath); err == nil {
		oldPath := targetPath + ".old"
		_ = os.Remove(oldPath)
		_ = os.Rename(targetPath, oldPath)
	}

	if err := copyFile(selfPath, targetPath, 0755); err != nil {
		return fmt.Errorf("failed to copy CLI to %s: %w", targetPath, err)
	}

	ensurePATH(targetDir)
	return nil
}

func ensurePATH(targetDir string) {
	if runtime.GOOS == "windows" {
		// PowerShell 経由でユーザー環境変数 PATH に存在するか確認し、なければ追加
		script := fmt.Sprintf(`
$dir = '%s'
$current = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-not $current) { $current = "" }
$paths = $current -split ';' | Where-Object { $_ -ne '' }
if ($paths -notcontains $dir) {
    $newPath = ($paths + $dir) -join ';'
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
}
`, strings.ReplaceAll(targetDir, "'", "''"))

		cmd := exec.Command("powershell", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", script)
		_ = cmd.Run()
	}
}

func copyFile(src, dst string, mode os.FileMode) error {
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()

	out, err := os.OpenFile(dst, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, mode)
	if err != nil {
		return err
	}
	defer out.Close()

	if _, err := io.Copy(out, in); err != nil {
		return err
	}
	return out.Sync()
}

// 作業用プロジェクトの出力先パスを決定します
func getTargetProjectDir(defaultName string, forceCreate bool) (string, bool, error) {
	baseDir, err := os.UserHomeDir()
	if err != nil || baseDir == "" {
		baseDir, err = os.Getwd()
		if err != nil {
			baseDir = "."
		}
	}

	primaryPath := filepath.Join(baseDir, defaultName)
	if _, err := os.Stat(primaryPath); err == nil {
		if !forceCreate {
			return primaryPath, true, nil
		}
		// forceCreate == true の場合は連番を生成
		counter := 1
		for {
			targetPath := filepath.Join(baseDir, fmt.Sprintf("%s_%d", defaultName, counter))
			if _, err := os.Stat(targetPath); os.IsNotExist(err) {
				return targetPath, false, nil
			}
			counter++
		}
	}

	return primaryPath, false, nil
}

// embed.FS 内の指定サブフォルダ以下のファイルを再帰的に展開・保存します
func extractFS(embedFS fs.FS, subDir string, targetDir string) error {
	fsys, err := fs.Sub(embedFS, subDir)
	if err != nil {
		return err
	}

	return fs.WalkDir(fsys, ".", func(path string, d fs.DirEntry, err error) error {
		if err != nil {
			return err
		}

		outPath := filepath.Join(targetDir, path)

		if d.IsDir() {
			return os.MkdirAll(outPath, 0755)
		}

		if err := os.MkdirAll(filepath.Dir(outPath), 0755); err != nil {
			return err
		}

		inFile, err := fsys.Open(path)
		if err != nil {
			return err
		}
		defer inFile.Close()

		outFile, err := os.OpenFile(outPath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0644)
		if err != nil {
			return err
		}
		defer outFile.Close()

		_, err = io.Copy(outFile, inFile)
		return err
	})
}

func exitWithPause(code int, silent bool) {
	if !silent {
		fmt.Println("Press Enter to exit...")
		_, _ = bufio.NewReader(os.Stdin).ReadString('\n')
	}
	os.Exit(code)
}
