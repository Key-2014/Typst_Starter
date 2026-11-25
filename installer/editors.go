package main

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"
)

var editorCandidates = []string{
	"Antigravity IDE",
	"Antigravity",
	"Code",
	"Code - Insiders",
	"Cursor",
	"Windsurf",
	"VSCodium",
}

type editorTarget struct {
	Name    string
	UserDir string
	Exists  bool
}

func getEditorConfigBaseDir() (string, error) {
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
		return appData, nil
	case "darwin":
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, "Library", "Application Support"), nil
	default:
		if xdgConfig := os.Getenv("XDG_CONFIG_HOME"); xdgConfig != "" {
			return xdgConfig, nil
		}
		home, err := os.UserHomeDir()
		if err != nil {
			return "", err
		}
		return filepath.Join(home, ".config"), nil
	}
}

func detectEditorsInBase(base string) []editorTarget {
	var detected []editorTarget
	for _, name := range editorCandidates {
		userDir := filepath.Join(base, name, "User")
		if info, err := os.Stat(userDir); err == nil && info.IsDir() {
			detected = append(detected, editorTarget{
				Name:    name,
				UserDir: userDir,
				Exists:  true,
			})
		}
	}

	if len(detected) == 0 {
		detected = append(detected, editorTarget{
			Name:    "Code",
			UserDir: filepath.Join(base, "Code", "User"),
			Exists:  false,
		})
	}
	return detected
}

func detectEditors() ([]editorTarget, error) {
	base, err := getEditorConfigBaseDir()
	if err != nil {
		return nil, err
	}
	return detectEditorsInBase(base), nil
}

func installSnippetsAndSettings(editors []editorTarget) {
	for _, ed := range editors {
		snippetsDir := filepath.Join(ed.UserDir, "snippets")
		if err := os.MkdirAll(snippetsDir, 0755); err != nil {
			fmt.Printf("      [WARNING] Failed to create snippets dir for %s: %v\n", ed.Name, err)
			continue
		}

		snippetFile := filepath.Join(snippetsDir, "typst-starter.code-snippets")
		if err := os.WriteFile(snippetFile, embeddedSnippetsBytes, 0644); err != nil {
			fmt.Printf("      [WARNING] Failed to write snippets for %s: %v\n", ed.Name, err)
			continue
		}
		fmt.Printf("      [OK] %s snippets: %s\n", ed.Name, snippetFile)

		settingsFile := filepath.Join(ed.UserDir, "settings.json")
		if err := mergeTypstSettings(settingsFile, ed.Name); err != nil {
			fmt.Printf("      [WARNING] Failed to update %s settings.json: %v\n", ed.Name, err)
		}
	}
}

// mergeTypstSettings idempotently ensures [typst].editor.quickSuggestions.strings = true
// without overwriting unrelated user settings or modifying JSONC files.
func mergeTypstSettings(settingsPath, label string) error {
	data, err := os.ReadFile(settingsPath)
	if os.IsNotExist(err) || (err == nil && strings.TrimSpace(string(data)) == "") {
		if mkErr := os.MkdirAll(filepath.Dir(settingsPath), 0755); mkErr != nil {
			return fmt.Errorf("failed to prepare directory for %s: %w", settingsPath, mkErr)
		}
		defaultJSON := "{\n  \"[typst]\": {\n    \"editor.quickSuggestions\": {\n      \"strings\": true\n    }\n  }\n}\n"
		if wErr := os.WriteFile(settingsPath, []byte(defaultJSON), 0644); wErr != nil {
			return fmt.Errorf("failed to write %s: %w", settingsPath, wErr)
		}
		fmt.Printf("      [OK] %s settings.json created with [typst] quickSuggestions.\n", label)
		return nil
	}
	if err != nil {
		return fmt.Errorf("failed to read %s: %w", settingsPath, err)
	}

	var root map[string]any
	if err := json.Unmarshal(data, &root); err != nil {
		raw := string(data)
		if strings.Contains(raw, `"[typst]"`) && strings.Contains(raw, `"editor.quickSuggestions"`) && strings.Contains(raw, `"strings"`) {
			fmt.Printf("      [OK] %s settings.json (JSONC) appears to already configure [typst] quickSuggestions; left untouched.\n", label)
			return nil
		}
		fmt.Printf("      [INFO] Skipped %s settings.json (JSONC comments or non-strict JSON; left untouched).\n", label)
		fmt.Println("             To enable snippet suggestions inside Typst strings, ensure your settings.json contains:")
		fmt.Println("             \"[typst]\": { \"editor.quickSuggestions\": { \"strings\": true } }")
		return nil
	}
	if root == nil {
		root = make(map[string]any)
	}

	typstMap, ok := root["[typst]"].(map[string]any)
	if !ok {
		typstMap = make(map[string]any)
		root["[typst]"] = typstMap
	}

	qsMap, ok := typstMap["editor.quickSuggestions"].(map[string]any)
	if !ok {
		qsMap = make(map[string]any)
		typstMap["editor.quickSuggestions"] = qsMap
	}

	if existing, ok := qsMap["strings"].(bool); ok && existing {
		fmt.Printf("      [OK] %s settings.json already enables [typst] quickSuggestions.\n", label)
		return nil
	}

	qsMap["strings"] = true
	out, err := json.MarshalIndent(root, "", "  ")
	if err != nil {
		return fmt.Errorf("failed to serialize %s: %w", settingsPath, err)
	}
	out = append(out, '\n')
	if err := os.WriteFile(settingsPath, out, 0644); err != nil {
		return fmt.Errorf("failed to write %s: %w", settingsPath, err)
	}
	fmt.Printf("      [OK] %s settings.json updated with [typst] quickSuggestions.\n", label)
	return nil
}

// ensureGitignorePDF idempotently ensures *.pdf is excluded in .gitignore.
func ensureGitignorePDF(gitignorePath string) error {
	data, err := os.ReadFile(gitignorePath)
	if os.IsNotExist(err) {
		if mkErr := os.MkdirAll(filepath.Dir(gitignorePath), 0755); mkErr != nil {
			return fmt.Errorf("failed to prepare directory for %s: %w", gitignorePath, mkErr)
		}
		content := "# Typst PDF output\n*.pdf\n"
		if wErr := os.WriteFile(gitignorePath, []byte(content), 0644); wErr != nil {
			return fmt.Errorf("failed to write %s: %w", gitignorePath, wErr)
		}
		fmt.Printf("      [OK] Created .gitignore with *.pdf exclusion: %s\n", gitignorePath)
		return nil
	}
	if err != nil {
		return fmt.Errorf("failed to read %s: %w", gitignorePath, err)
	}

	raw := string(data)
	normalized := strings.ReplaceAll(raw, "\r\n", "\n")
	for _, line := range strings.Split(normalized, "\n") {
		trimmed := strings.TrimSpace(line)
		if trimmed == "" || strings.HasPrefix(trimmed, "#") {
			continue
		}
		if trimmed == "*.pdf" || trimmed == "/*.pdf" || trimmed == "**/*.pdf" {
			fmt.Println("      [OK] .gitignore already excludes *.pdf.")
			return nil
		}
	}

	var updated string
	if strings.TrimSpace(raw) == "" {
		updated = "# Typst PDF output\n*.pdf\n"
	} else if strings.HasSuffix(raw, "\n") {
		updated = raw + "# Typst PDF output\n*.pdf\n"
	} else {
		updated = raw + "\n# Typst PDF output\n*.pdf\n"
	}

	if wErr := os.WriteFile(gitignorePath, []byte(updated), 0644); wErr != nil {
		return fmt.Errorf("failed to update %s: %w", gitignorePath, wErr)
	}
	fmt.Printf("      [OK] Added *.pdf exclusion to .gitignore: %s\n", gitignorePath)
	return nil
}

// syncExistingProjectConfig removes legacy workspace snippets and idempotently
// syncs .vscode/settings.json and .gitignore for an existing project directory.
func syncExistingProjectConfig(projectDir string) {
	legacySnippet := filepath.Join(projectDir, ".vscode", "typst.code-snippets")
	if info, err := os.Stat(legacySnippet); err == nil && !info.IsDir() {
		if rmErr := os.Remove(legacySnippet); rmErr != nil {
			fmt.Printf("      [WARNING] Failed to remove legacy workspace snippet %s: %v\n", legacySnippet, rmErr)
		} else {
			fmt.Printf("      [OK] Removed legacy workspace snippet: %s (migrated to global snippets)\n", legacySnippet)
		}
	}

	label := filepath.Base(projectDir) + " (.vscode)"
	settingsPath := filepath.Join(projectDir, ".vscode", "settings.json")
	if err := mergeTypstSettings(settingsPath, label); err != nil {
		fmt.Printf("      [WARNING] Failed to sync %s: %v\n", settingsPath, err)
	}

	gitignorePath := filepath.Join(projectDir, ".gitignore")
	if err := ensureGitignorePDF(gitignorePath); err != nil {
		fmt.Printf("      [WARNING] Failed to sync %s: %v\n", gitignorePath, err)
	}
}
