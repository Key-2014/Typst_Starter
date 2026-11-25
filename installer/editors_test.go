package main

import (
	"encoding/json"
	"errors"
	"io/fs"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestDetectEditorsInBase(t *testing.T) {
	t.Run("fallback to Code when no editor directories exist", func(t *testing.T) {
		base := t.TempDir()
		targets := detectEditorsInBase(base)
		if len(targets) != 1 {
			t.Fatalf("expected 1 fallback target, got %d", len(targets))
		}
		if targets[0].Name != "Code" || targets[0].Exists {
			t.Fatalf("unexpected fallback target: %+v", targets[0])
		}
		expectedDir := filepath.Join(base, "Code", "User")
		if targets[0].UserDir != expectedDir {
			t.Fatalf("expected UserDir %q, got %q", expectedDir, targets[0].UserDir)
		}
	})

	t.Run("detects multiple existing editor directories", func(t *testing.T) {
		base := t.TempDir()
		for _, ed := range []string{"Code", "Cursor", "Antigravity"} {
			if err := os.MkdirAll(filepath.Join(base, ed, "User"), 0755); err != nil {
				t.Fatalf("mkdir failed: %v", err)
			}
		}

		targets := detectEditorsInBase(base)
		if len(targets) != 3 {
			t.Fatalf("expected 3 detected editors, got %d: %+v", len(targets), targets)
		}

		expectedOrder := []string{"Antigravity", "Code", "Cursor"}
		for i, want := range expectedOrder {
			if targets[i].Name != want || !targets[i].Exists {
				t.Fatalf("target[%d] = %+v, want Name=%s Exists=true", i, targets[i], want)
			}
		}
	})
}

func TestMergeTypstSettings_IdempotentAndSafe(t *testing.T) {
	t.Run("creates file when missing", func(t *testing.T) {
		dir := t.TempDir()
		path := filepath.Join(dir, ".vscode", "settings.json")

		if err := mergeTypstSettings(path, "Test"); err != nil {
			t.Fatalf("mergeTypstSettings failed: %v", err)
		}

		data, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("failed to read created settings.json: %v", err)
		}

		var parsed map[string]any
		if err := json.Unmarshal(data, &parsed); err != nil {
			t.Fatalf("created settings.json is not valid JSON: %v", err)
		}
		typstMap := parsed["[typst]"].(map[string]any)
		qsMap := typstMap["editor.quickSuggestions"].(map[string]any)
		if val, ok := qsMap["strings"].(bool); !ok || !val {
			t.Fatalf("expected strings=true, got %v", qsMap["strings"])
		}
	})

	t.Run("preserves unrelated keys and is strictly idempotent on re-run", func(t *testing.T) {
		dir := t.TempDir()
		path := filepath.Join(dir, "settings.json")
		initial := "{\n  \"editor.fontSize\": 14,\n  \"[typst]\": {\n    \"editor.tabSize\": 2\n  }\n}\n"
		if err := os.WriteFile(path, []byte(initial), 0644); err != nil {
			t.Fatalf("write initial failed: %v", err)
		}

		if err := mergeTypstSettings(path, "Test"); err != nil {
			t.Fatalf("first merge failed: %v", err)
		}

		afterFirst, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read after first merge failed: %v", err)
		}

		var parsed map[string]any
		if err := json.Unmarshal(afterFirst, &parsed); err != nil {
			t.Fatalf("merged JSON invalid: %v", err)
		}
		if parsed["editor.fontSize"] != float64(14) {
			t.Fatalf("lost unrelated top-level key: %v", parsed)
		}
		typstMap := parsed["[typst]"].(map[string]any)
		if typstMap["editor.tabSize"] != float64(2) {
			t.Fatalf("lost unrelated [typst] key: %v", typstMap)
		}
		qsMap := typstMap["editor.quickSuggestions"].(map[string]any)
		if val, ok := qsMap["strings"].(bool); !ok || !val {
			t.Fatalf("expected strings=true, got %v", qsMap["strings"])
		}

		// Make file read-only for the second run to prove it does not rewrite when already enabled.
		if err := os.Chmod(path, 0444); err != nil {
			t.Fatalf("chmod 0444 failed: %v", err)
		}
		t.Cleanup(func() { _ = os.Chmod(path, 0644) })

		if err := mergeTypstSettings(path, "Test"); err != nil {
			t.Fatalf("second merge should be a no-op and succeed even on read-only file: %v", err)
		}

		afterSecond, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read after second merge failed: %v", err)
		}
		if string(afterFirst) != string(afterSecond) {
			t.Fatalf("expected byte-for-byte identical settings.json on second run")
		}
	})

	t.Run("leaves JSONC with comments and trailing commas untouched", func(t *testing.T) {
		dir := t.TempDir()
		path := filepath.Join(dir, "settings.json")
		jsonc := "{\n  // user comment\n  \"editor.wordWrap\": \"on\",\n}\n"
		if err := os.WriteFile(path, []byte(jsonc), 0644); err != nil {
			t.Fatalf("write jsonc failed: %v", err)
		}

		if err := mergeTypstSettings(path, "Test"); err != nil {
			t.Fatalf("mergeTypstSettings on JSONC returned error: %v", err)
		}

		after, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read failed: %v", err)
		}
		if string(after) != jsonc {
			t.Fatalf("JSONC file was modified:\ngot:\n%s\nwant:\n%s", string(after), jsonc)
		}
	})
}

func TestEnsureGitignorePDF_Idempotent(t *testing.T) {
	t.Run("creates gitignore when missing", func(t *testing.T) {
		dir := t.TempDir()
		path := filepath.Join(dir, ".gitignore")

		if err := ensureGitignorePDF(path); err != nil {
			t.Fatalf("ensureGitignorePDF failed: %v", err)
		}
		got, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read failed: %v", err)
		}
		if !strings.Contains(string(got), "*.pdf") {
			t.Fatalf("expected *.pdf in created .gitignore, got %q", string(got))
		}
	})

	t.Run("appends once when missing and stays identical on re-run", func(t *testing.T) {
		dir := t.TempDir()
		path := filepath.Join(dir, ".gitignore")
		initial := "# commented *.pdf\n*.tmp"
		if err := os.WriteFile(path, []byte(initial), 0644); err != nil {
			t.Fatalf("write failed: %v", err)
		}

		if err := ensureGitignorePDF(path); err != nil {
			t.Fatalf("first ensureGitignorePDF failed: %v", err)
		}
		afterFirst, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read failed: %v", err)
		}
		if count := strings.Count(string(afterFirst), "\n*.pdf"); count != 1 {
			t.Fatalf("expected 1 *.pdf rule, got %d in:\n%s", count, string(afterFirst))
		}

		if err := ensureGitignorePDF(path); err != nil {
			t.Fatalf("second ensureGitignorePDF failed: %v", err)
		}
		afterSecond, err := os.ReadFile(path)
		if err != nil {
			t.Fatalf("read failed: %v", err)
		}
		if string(afterFirst) != string(afterSecond) {
			t.Fatalf("expected byte-for-byte identical .gitignore on second run:\nfirst:\n%s\nsecond:\n%s", string(afterFirst), string(afterSecond))
		}
	})
}

func TestSyncExistingProjectConfig(t *testing.T) {
	projectDir := t.TempDir()
	vscodeDir := filepath.Join(projectDir, ".vscode")
	if err := os.MkdirAll(vscodeDir, 0755); err != nil {
		t.Fatalf("mkdir failed: %v", err)
	}

	mainTyp := "// user custom file\n= Hello\n"
	customSnippet := `{"custom":{"prefix":"cust","body":["hi"]}}`
	legacySnippet := filepath.Join(vscodeDir, "typst.code-snippets")
	customSnippetPath := filepath.Join(vscodeDir, "custom.code-snippets")
	settingsPath := filepath.Join(vscodeDir, "settings.json")
	gitignorePath := filepath.Join(projectDir, ".gitignore")
	mainPath := filepath.Join(projectDir, "main.typ")

	if err := os.WriteFile(mainPath, []byte(mainTyp), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(legacySnippet, []byte(`{}`), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(customSnippetPath, []byte(customSnippet), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(settingsPath, []byte("{\n  \"editor.wordWrap\": \"on\"\n}\n"), 0644); err != nil {
		t.Fatal(err)
	}
	if err := os.WriteFile(gitignorePath, []byte("build/\n"), 0644); err != nil {
		t.Fatal(err)
	}

	syncExistingProjectConfig(projectDir)

	if _, err := os.Stat(legacySnippet); !os.IsNotExist(err) {
		t.Fatalf("expected legacy snippet %s to be removed, stat err=%v", legacySnippet, err)
	}
	if gotCustom, err := os.ReadFile(customSnippetPath); err != nil || string(gotCustom) != customSnippet {
		t.Fatalf("custom snippet was altered or removed: err=%v", err)
	}
	if gotMain, err := os.ReadFile(mainPath); err != nil || string(gotMain) != mainTyp {
		t.Fatalf("main.typ was altered or removed: err=%v", err)
	}

	settingsFirst, err := os.ReadFile(settingsPath)
	if err != nil {
		t.Fatal(err)
	}
	var parsed map[string]any
	if err := json.Unmarshal(settingsFirst, &parsed); err != nil {
		t.Fatalf("invalid settings.json: %v", err)
	}
	if parsed["editor.wordWrap"] != "on" {
		t.Fatalf("lost existing setting editor.wordWrap: %v", parsed)
	}
	if !parsed["[typst]"].(map[string]any)["editor.quickSuggestions"].(map[string]any)["strings"].(bool) {
		t.Fatalf("expected [typst].editor.quickSuggestions.strings = true")
	}

	gitignoreFirst, err := os.ReadFile(gitignorePath)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(gitignoreFirst), "build/") || !strings.Contains(string(gitignoreFirst), "*.pdf") {
		t.Fatalf("unexpected .gitignore contents:\n%s", string(gitignoreFirst))
	}

	// Second run must be byte-for-byte identical.
	syncExistingProjectConfig(projectDir)

	settingsSecond, err := os.ReadFile(settingsPath)
	if err != nil {
		t.Fatal(err)
	}
	gitignoreSecond, err := os.ReadFile(gitignorePath)
	if err != nil {
		t.Fatal(err)
	}
	if string(settingsFirst) != string(settingsSecond) {
		t.Fatalf("settings.json changed on second sync")
	}
	if string(gitignoreFirst) != string(gitignoreSecond) {
		t.Fatalf(".gitignore changed on second sync")
	}
}

func TestEmbeddedResourcesNoWorkspaceSnippet(t *testing.T) {
	if len(embeddedSnippetsBytes) == 0 {
		t.Fatalf("embeddedSnippetsBytes is empty")
	}
	if !strings.Contains(string(embeddedSnippetsBytes), "@local/starter:") {
		t.Fatalf("embeddedSnippetsBytes does not contain @local/starter: import")
	}

	if _, err := embeddedTemplateFS.Open("resources/template/.vscode/typst.code-snippets"); !errors.Is(err, fs.ErrNotExist) {
		t.Fatalf("expected embeddedTemplateFS NOT to contain typst.code-snippets, got err=%v", err)
	}

	for _, reqFile := range []string{
		"resources/template/.vscode/settings.json",
		"resources/template/main.typ",
	} {
		f, err := embeddedTemplateFS.Open(reqFile)
		if err != nil {
			t.Fatalf("expected embeddedTemplateFS to contain %s, got err=%v", reqFile, err)
		}
		_ = f.Close()
	}

	tomlBytes, err := embeddedPackageFS.ReadFile("resources/package/typst.toml")
	if err != nil {
		t.Fatalf("failed to read embedded package typst.toml: %v", err)
	}
	wantVer := `version = "` + PackageVersion + `"`
	if !strings.Contains(string(tomlBytes), wantVer) {
		t.Fatalf("expected embedded typst.toml to contain %q, got:\n%s", wantVer, string(tomlBytes))
	}
}
