# Scripts

Typst Starter 用の補助スクリプトです。

> 💡 **通常のご利用ではスクリプトの実行は不要です**
> リリースされているインストーラー（`Typst-Starter-Setup-*.exe` 等）を実行すると、Typst Starter パッケージ（`@local/starter:2.0.0`）はローカルパッケージフォルダ（`%APPDATA%\typst\packages\local\starter\2.0.0\`）へ**自動的に配置**されます。
> 
> 本スクリプト（`install-package.ps1`）は、パッケージを自分で開発・修正した際の手動再インストールや、CLI/CI でのセットアップ時に利用する補助ツールです。

---

## スクリプト一覧

| スクリプト | 説明 |
|---|---|
| `install-package.ps1` | Starter Package (`@local/starter:2.0.0`) をローカルにインストールする（開発・手動セットアップ用） |

---

## install-package.ps1

Starter Package（`package/starter/2.0.0/`）を手動で Typst のローカルパッケージディレクトリにコピーします。

### 実行方法

**パッケージのみ配置する場合:**
```powershell
powershell -ExecutionPolicy Bypass -File scripts\install-package.ps1
```

**パッケージ配置と同時に初期プロジェクト（My_Typst）を作成する場合:**
```powershell
# 標準レポート用
powershell -ExecutionPolicy Bypass -File scripts\install-package.ps1 -CreateProject

# 学位論文（卒論・修論）用テンプレートで初期化する場合
powershell -ExecutionPolicy Bypass -File scripts\install-package.ps1 -CreateProject -TemplateType thesis

# スライド用テンプレートで初期化する場合
powershell -ExecutionPolicy Bypass -File scripts\install-package.ps1 -CreateProject -TemplateType slide
```

### 動作

1. `package/starter/2.0.0/` の全ファイルを
2. `%APPDATA%\typst\packages\local\starter\2.0.0\`（macOS/Linux では `~/.local/share/typst/packages/local/starter/2.0.0/`）にコピーします
3. `-CreateProject` を指定した場合は、ユーザーホーム直下に `My_Typst` プロジェクトフォルダを初期化します

### インストール先（Windows）

```
C:\Users\<ユーザー名>\AppData\Roaming\typst\packages\local\starter\2.0.0\
```

---

## 対応 OS

- **`install-package.ps1`**: Windows / macOS / Linux (PowerShell)
- **クロスプラットフォーム対応**: リリースバイナリ（`installer/` / `dist/`）にて Windows, macOS, Linux 向けの単一バイナリインストーラーを提供しています。
