package main

import (
	"bufio"
	"fmt"
	"io"
	"io/fs"
	"os"
	"path/filepath"
	"runtime"
)


func main() {
	fmt.Println("==================================================")
	fmt.Println("        Typst Starter Installer v1.0.0            ")
	fmt.Println("==================================================")
	fmt.Println()

	// 1. パッケージ配置先ディレクトリの特定
	packageDir, err := getTypstPackageDir()
	if err != nil {
		fmt.Printf("[ERROR] Failed to determine Typst package directory: %v\n", err)
		pauseAndExit(1)
	}

	fmt.Printf("[1/2] Installing Typst Starter package...\n")
	fmt.Printf("      Target: %s\n", packageDir)

	if err := extractFS(embeddedPackageFS, "resources/package", packageDir); err != nil {
		fmt.Printf("[ERROR] Failed to extract package: %v\n", err)
		pauseAndExit(1)
	}
	fmt.Println("      [OK] Package installed successfully.")
	fmt.Println()

	// 2. プロジェクト作成先の決定
	defaultProjectName := "My_Typst"
	targetProjectDir := getTargetProjectDir(defaultProjectName)

	fmt.Printf("[2/2] Creating initial project...\n")
	fmt.Printf("      Target: %s\n", targetProjectDir)

	if err := extractFS(embeddedTemplateFS, "resources/template", targetProjectDir); err != nil {
		fmt.Printf("[ERROR] Failed to create project directory: %v\n", err)
		pauseAndExit(1)
	}
	fmt.Println("      [OK] Project created successfully.")
	fmt.Println()

	fmt.Println("==================================================")
	fmt.Println("Installation Completed Successfully!")
	fmt.Println("==================================================")
	fmt.Println()
	fmt.Println("Next Steps:")
	fmt.Printf("  1. Open Visual Studio Code\n")
	fmt.Printf("  2. Open folder: %s\n", targetProjectDir)
	fmt.Printf("  3. Open 'main.typ' and start writing your report!\n")
	fmt.Println()

	pauseAndExit(0)
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
		return filepath.Join(appData, "typst", "packages", "local", "starter", "1.0.0"), nil
	}

	// macOS / Linux
	if xdgData := os.Getenv("XDG_DATA_HOME"); xdgData != "" {
		return filepath.Join(xdgData, "typst", "packages", "local", "starter", "1.0.0"), nil
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}
	return filepath.Join(home, ".local", "share", "typst", "packages", "local", "starter", "1.0.0"), nil
}

// 作業用プロジェクトの出力先パスを決定します（ユーザーホーム直下に作成）
func getTargetProjectDir(defaultName string) string {
	baseDir, err := os.UserHomeDir()
	if err != nil || baseDir == "" {
		baseDir, err = os.Getwd()
		if err != nil {
			baseDir = "."
		}
	}

	// 重複を避けるフォルダ名の決定
	projectName := defaultName
	targetPath := filepath.Join(baseDir, projectName)
	counter := 1

	for {
		if _, err := os.Stat(targetPath); os.IsNotExist(err) {
			break
		}
		projectName = fmt.Sprintf("%s_%d", defaultName, counter)
		targetPath = filepath.Join(baseDir, projectName)
		counter++
	}

	return targetPath
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

		// ディレクトリがなければ作成
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

// コンソールが即座に閉じないよう待機して終了します
func pauseAndExit(code int) {
	fmt.Println("Press Enter to exit...")
	bufio.NewReader(os.Stdin).ReadString('\n')
	os.Exit(code)
}
