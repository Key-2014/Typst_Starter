# Typst Starter

> 「誰でも短時間で Typst によるレポート作成を開始できる」

Typst Starter は、Windows 環境において Typst を初めて利用する人を対象に、Typst の導入から最初のレポート作成までを支援するスターターキットです。

---

## 1. Typst Starter とは

Typst Starter は、以下の 3 層構造で構成されています。

```
Package      ← レポート・スライド作成に必要なテンプレート
    ↓
Examples     ← Package の利用例
    ↓
Learning     ← Typst の設定方法を学ぶ教材
```

Typst 公式ドキュメントは非常に充実しているため、細かい説明はそちらを参照してください。

---

## 2. 特徴

- 🇯🇵 **日本語最適化** — 原ノ味明朝フォント優先、フォールバック設定付き
- 📐 **A4 レポートテンプレート** — ページ設定・見出し・数式ナンバリングを自動適用
- 🖥️ **スライドテンプレート** — Touying フレームワークによる 16:9 スライド
- 🧮 **数学・物理パッケージ同梱** — physica, unify, cetz, showybox, whalogen
- 📖 **段階的学習教材** — Typst の設定方法を 01→08 の順に学べる
- 📝 **最小構成のテンプレート** — コピーするだけでレポートを書き始められる

---

## 3. 必要環境

| 項目     | 要件                                 |
| -------- | ------------------------------------ |
| OS       | Windows 10 / 11                      |
| Typst    | 最新安定版                           |
| エディタ | Visual Studio Code（推奨）           |
| 拡張機能 | Tinymist Typst, vscode-pdf           |
| フォント | 原ノ味フォント（推奨・必須ではない） |

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

## 9. Starter Package 導入

### GitHub Releases からインストール

1. [Releases ページ](https://github.com/Key-2014/Typst_Starter/releases) から最新のパッケージをダウンロード
2. ダウンロードしたファイルを以下のディレクトリに配置：

```
%APPDATA%\typst\packages\local\starter\1.0.0\
```

> 💡 `%APPDATA%` は通常 `C:\Users\<ユーザー名>\AppData\Roaming` です。

### インストール確認

新しい `.typ` ファイルを作成し、以下を記述してエラーが出なければ成功です：

```typ
#import "@local/starter:1.0.0": *
```

---

## 10. 最初のレポート

Package が導入できたら、以下の手順で最初のレポートを作成します。

### 1. Project Template をコピー

`project-template/` フォルダの内容を新しいフォルダにコピーします。

### 2. main.typ を編集

```typ
#import "@local/starter:1.0.0": *

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
`Ctrl + K V` でサイドにプレビューパネルを開くこともできます。

---

## 11. Project Template

`project-template/` は新規プロジェクトの開始用テンプレートです。

```
project-template/
├── main.typ            ← メインファイル
├── refs.bib            ← 参考文献
├── images/             ← 画像格納用
├── .vscode/            ← VSCode 設定
│   └── settings.json
└── .gitignore          ← PDF 除外設定
```

このフォルダをコピーするだけでレポートを書き始められます。
詳細は [project-template/README.md](project-template/README.md) を参照してください。

---

## 12. Examples

`examples/` には Package の利用例が含まれています。

| Example           | 内容                 |
| ----------------- | -------------------- |
| `01_First_Report` | 最も基本的なレポート |
| `02_Image`        | 画像の挿入方法       |
| `03_Table`        | 表の作成方法         |
| `04_Equation`     | 数式の記述と番号付け |
| `05_Bibliography` | 参考文献の引用       |
| `06_Slide`        | スライドの作成       |

各 Example は独立してコンパイル可能です。コピーして利用しても構いません。
詳細は [examples/README.md](examples/README.md) を参照してください。

---

## 13. Learning

`learning/` は Starter の内部実装を理解するための教材です。

**Package を使いません。** 純粋な Typst のコードのみで書かれています。

01→08 の順に読むことで、Starter が内部で行っている設定を段階的に学べます。

| ファイル                 | 学習内容                   |
| ------------------------ | -------------------------- |
| `01_minimal.typ`         | 最小のドキュメント         |
| `02_page.typ`            | ページ設定                 |
| `03_text.typ`            | フォント設定               |
| `04_heading.typ`         | 見出し設定                 |
| `05_figure.typ`          | 図表・数式設定             |
| `06_table.typ`           | 表の詳細設定               |
| `07_report_template.typ` | テンプレート関数の作り方   |
| `08_slide_template.typ`  | スライドテンプレートの基礎 |

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