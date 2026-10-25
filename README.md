# Typst Starter

> 「誰でも短時間で Typst によるレポート作成を開始できる」

Typst Starter は、Windows 環境において Typst を初めて利用する人を対象に、Typst の導入から最初のレポート作成までを支援するスターターキットです。

---

## 1. Typst Starter とは

Typst Starter は、以下の 3 層構造で構成されています。

```
Package      ← レポート・論文・スライド作成に必要なテンプレート
    ↓
Examples     ← Package の利用例（01〜07）
    ↓
Learning     ← Typst の設定方法を学ぶ教材（01〜09）
```

Typst 公式ドキュメントは非常に充実しているため、細かい説明はそちらを参照してください。

---

## 2. 特徴

- 🚀 **ワンクリック自動セットアップ** — インストーラーを実行するだけでパッケージ配置と作業フォルダ作成が完了
- 🇯🇵 **日本語最適化** — 原ノ味明朝・原ノ味角ゴシックフォント優先、フォールバック設定付き
- 📐 **A4 レポートテンプレート** — ページ設定・見出し・数式ナンバリング・図表キャプションを自動適用
- 🎓 **学位論文テンプレート (`thesis`)** — 卒業論文・修士論文向けに表紙・要旨・図表目次・章連動採番 `(1.1)`・ランニングヘッダー・付録モードを完備
- 🖥️ **スライドテンプレート (`slide`)** — Touying フレームワーク（university theme）による 16:9 スライド
- 🧮 **充実のパッケージ同梱** — 数学・物理・化学・作図・定理環境（physica, unify, cetz, fletcher, showybox, theorion, whalogen 等）を一元管理
- 📖 **段階的学習教材** — Typst の設定方法を 01→09 の順に学べる
- 📝 **実用的なテンプレート** — すぐにレポートや論文・スライドを書き始められる構成

---

## 3. 必要環境

| 項目     | 要件                                  | 備考                                   |
| -------- | ------------------------------------- | -------------------------------------- |
| OS       | Windows 10 / 11（macOS / Linux 対応） | 各OS向けインストーラーを提供           |
| Typst    | 最新安定版                            | CLIツール                              |
| エディタ | Visual Studio Code（推奨）            |                                        |
| 拡張機能 | Tinymist Typst, vscode-pdf            | VSCode 拡張機能                        |
| フォント | 原ノ味フォント（推奨・必須ではない）  | システムフォントへの自動フォールバック |

---

## 4. Typst 導入

### winget を使ったインストール（推奨）

PowerShell を開き、以下を実行します：

```powershell
winget install --id Typst.Typst
```

### 手動インストール

1. [Typst の GitHub Releases](https://github.com/typst/typst/releases) から最新版をダウンロード
2. `typst-x86_64-pc-windows-msvc.zip` を展開
3. 展開したフォルダにパスを通す

### インストール確認

```powershell
typst --version
```

バージョンが表示されれば成功です。

---

## 5. VSCode 導入

1. [Visual Studio Code](https://code.visualstudio.com/) をダウンロードしてインストール
2. インストーラーの指示に従って設定

> 💡 VSCode は無料のコードエディタです。Typst ファイルの編集とプレビューに使います。

---

## 6. 拡張機能

VSCode の拡張機能タブ（`Ctrl + Shift + X`）から以下をインストールしてください：

### 必須

| 拡張機能           | 説明                                                 |
| ------------------ | ---------------------------------------------------- |
| **Tinymist Typst** | Typst の言語サポート（補完・プレビュー・エラー表示） |

### 推奨

| 拡張機能       | 説明                         |
| -------------- | ---------------------------- |
| **vscode-pdf** | VSCode 内で PDF をプレビュー |

---

## 7. Tinymist 推奨設定

VSCode の設定ファイル（`.vscode/settings.json`）に以下を追加すると、Typst ファイルの編集がより快適になります：

```json
{
  "[typst]": {
    "editor.quickSuggestions": {
      "strings": true
    }
  }
}
```

> 💡 この設定により、`#import` 文などでのパッケージ名の補完が有効になります。

---

## 8. 日本語フォント

### 原ノ味フォント（推奨）

Starter テンプレートは **原ノ味明朝（Harano Aji Mincho）** を優先フォントとして設定しています。

- [Harano Aji Fonts (GitHub)](https://github.com/trueroad/HaranoAjiFonts)
  - `HaranoAjiMincho-Regular.otf` と `HaranoAjiMincho-Bold.otf` をダウンロード・インストール
  - スライド用に `HaranoAjiGothic-Regular.otf` と `HaranoAjiGothic-Bold.otf` も推奨

### フォントなしでも利用可能

原ノ味フォントがインストールされていない場合でも、システムの日本語フォントに自動的にフォールバックします。
日本語の表示は可能ですが、組版の品質は原ノ味フォント使用時が最も高くなります。

### インストール確認

```powershell
typst fonts | Select-String "Harano"
```

---

## 9. Starter Package 導入（ワンクリック・インストーラー）

Starter Package（`@local/starter:2.1.0`）は、**インストーラーを実行するだけで Typst のローカルパッケージフォルダへ自動配置されます**。ユーザー自身でのファイルコピーや環境設定は一切不要です。

### ① GitHub Releases からインストーラーをダウンロード（推奨）

1. [Releases ページ](https://github.com/Key-2014/Typst_Starter/releases) からお使いの環境に合った最新のインストーラーをダウンロードします：
   - **Windows**: `Typst-Starter-Setup-windows-amd64.exe`
   - **macOS (Apple Silicon)**: `Typst-Starter-Setup-darwin-arm64`
   - **macOS (Intel)**: `Typst-Starter-Setup-darwin-amd64`
   - **Linux**: `Typst-Starter-Setup-linux-amd64`
2. ダウンロードした実行ファイルを起動します（Windows では**ダブルクリックで実行**）。

これだけで、以下の 2 つが自動的に完了します：
1. **Package の自動配置**: Typst のローカルパッケージディレクトリ（Windows: `%APPDATA%\typst\packages\local\starter\2.1.0\`）へパッケージ一式が自動コピーされます。
2. **作業フォルダの自動作成**: ユーザーホームディレクトリ（Windows: `C:\Users\{username}\`）直下に新規レポートプロジェクトフォルダ（`My_Typst`）が作成されます。

> 💡 **追加の環境構築やコマンド操作は不要です。**
> インストーラー完了後、すぐに `#import "@local/starter:2.1.0": *` が利用可能になります。
> macOS / Linux で実行する場合は、ターミナルで実行権限を付与して実行してください：
> ```bash
> chmod +x Typst-Starter-Setup-*
> ./Typst-Starter-Setup-*
> ```

### ② その他のインストール方法（スクリプト・手動）

#### PowerShell スクリプトを使用する場合
リポジトリをクローンまたはダウンロード後、PowerShell で以下を実行してパッケージ配置およびプロジェクト初期化を行えます：

```powershell
# レポート用プロジェクトを作成する場合
.\scripts\install-package.ps1 -CreateProject

# 学位論文（卒論・修論）用プロジェクトを作成する場合
.\scripts\install-package.ps1 -CreateProject -TemplateType thesis
```

#### 手動配置の場合
`package/starter/2.1.0/` フォルダを手動で各 OS のローカルパッケージディレクトリに配置してください：

- **Windows**: `%APPDATA%\typst\packages\local\starter\2.1.0\`
- **macOS / Linux**: `~/.local/share/typst/packages/local/starter/2.1.0/`（または `$XDG_DATA_HOME/typst/packages/local/starter/2.1.0/`）

### インストール確認

VSCode で作成された `My_Typst/main.typ` を開くか、新しい `.typ` ファイルを作成して以下を記述し、エラーが出なければ成功です：

```typ
#import "@local/starter:2.1.0": *
```

---

## 10. 最初のレポート

インストーラー（またはスクリプト）によって自動作成されたプロジェクトフォルダで、以下の手順ですぐに最初のレポートを作成できます。

### 1. VSCode でプロジェクトフォルダを開く

作成された `My_Typst` フォルダ（`C:\Users\{username}\My_Typst`）を VSCode で開きます（ドラッグ＆ドロップまたはメニューの「フォルダを開く」）。

### 2. main.typ を編集

`main.typ` を開き、内容を編集します：

```typ
#import "@local/starter:2.1.0": *

#show: report.with(
  title: "物理学実験レポート",
  author: "氏名",
  student-id: "12345678",
  date: datetime.today().display(),
  heading-numbering: "1.1",
)

= はじめに

ここに本文を書いてください。
```

### 3. PDF をプレビュー

VSCode で `main.typ` を開くと、Tinymist が自動的にプレビューを表示します。
`Ctrl + K V`（macOS は `Cmd + K V`）でサイドにプレビューパネルを開くこともできます。

---

## 11. Project Template

`project-template/` は新規プロジェクトの開始用テンプレートです（インストーラー実行時に `My_Typst` として自動展開されます）。

```
project-template/
├── main.typ            ← メインファイル
├── refs.bib            ← 参考文献
├── images/             ← 画像格納用
├── .vscode/            ← VSCode 設定
│   └── settings.json
└── .gitignore          ← PDF 除外設定
```

既存のテンプレートを複製して新しいレポートを作成したい場合は、このフォルダをコピーするだけでいつでも新しいプロジェクトを開始できます。
詳細は [project-template/README.md](project-template/README.md) を参照してください。

---

## 12. Examples

`examples/` には Package の利用例が含まれています。

| Example           | 内容                           |
| ----------------- | ------------------------------ |
| `01_First_Report` | 最も基本的なレポート           |
| `02_Image`        | 画像の挿入方法                 |
| `03_Table`        | 表の作成方法                   |
| `04_Equation`     | 数式の記述と番号付け           |
| `05_Bibliography` | 参考文献の引用                 |
| `06_Slide`        | スライドの作成                 |
| `07_Thesis`       | 学位論文（卒論・修論）の作成例 |

各 Example は独立してコンパイル可能です。コピーして利用しても構いません。
詳細は [examples/README.md](examples/README.md) を参照してください。

---

## 13. Learning

`learning/` は Starter の内部実装を理解するための教材です。

**Package を使いません。** 純粋な Typst のコードのみで書かれています。

01→09 の順に読むことで、Starter が内部で行っている設定を段階的に学べます。

| ファイル                 | 学習内容                         |
| ------------------------ | -------------------------------- |
| `01_minimal.typ`         | 最小のドキュメント               |
| `02_page.typ`            | ページ設定                       |
| `03_text.typ`            | フォント設定                     |
| `04_heading.typ`         | 見出し設定                       |
| `05_figure.typ`          | 図表・数式設定                   |
| `06_table.typ`           | 表の詳細設定                     |
| `07_report_template.typ` | テンプレート関数の作り方         |
| `08_slide_template.typ`  | スライドテンプレートの基礎       |
| `09_thesis_template.typ` | 学術論文（学位論文）の組版仕組み |

詳細は [learning/README.md](learning/README.md) を参照してください。

---

## 14. GitHub（発展）

レポートを Git で管理することで、変更履歴の記録やバックアップが可能になります。

### GitHub の始め方

1. [GitHub](https://github.com/) でアカウントを作成
2. [GitHub Desktop](https://desktop.github.com/) をインストール（GUI で操作可能）
3. 新しいリポジトリを作成
4. Project Template のフォルダをリポジトリに追加
5. 変更をコミット・プッシュ

> 💡 Git の詳しい使い方は本プロジェクトの範囲外です。
> [GitHub Docs](https://docs.github.com/ja) を参照してください。

---

## 15. Typst 公式ドキュメント

Typst について詳しく学ぶには、公式ドキュメントを参照してください。

- [Typst Documentation](https://typst.app/docs/) — 公式リファレンス
- [Typst Universe](https://typst.app/universe/) — パッケージ・テンプレート一覧
- [Typst GitHub](https://github.com/typst/typst) — ソースコード・Issue

---

## 16. License

[MIT License](LICENSE)