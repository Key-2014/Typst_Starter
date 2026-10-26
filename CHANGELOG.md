# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [2.2.0] - 2026-10-26

### Added

- **Starter Package v2.2.0** (`package/starter/2.2.0/`)
  - **目次 (`thesis-toc`) デザインのリファクタリング (`thesis.typ`)**
    - 目次エントリ配置ヘルパー `toc-entry()` を導入し、章・節・項番号の配置幅とインデントを厳密化（レベルごとのズレを解消）
    - 第1レベル（章）のドットリーダーを非表示にし、視覚的な階層・メリハリを改善
    - 付録（Appendix）および図目次（LOF）・表目次（LOT）の番号フォーマット対応を強化
  - **VS Code スニペット (`project-template/.vscode/typst.code-snippets`)**
    - Typst Starter 向けのスニペット定義を追加（論文、レポート、スライド、数式、図表、CeTZ 等の入力支援）

### Changed

- すべての Examples (`examples/`) および初期プロジェクトテンプレート (`project-template/`) のインポートを `@local/starter:2.2.0` に更新
- インストーラーおよびパッケージ管理スクリプトを v2.2.0 対応に更新

---

## [2.1.0] - 2026-10-25

### Added

- **Starter Package v2.1.0** (`package/starter/2.1.0/`)
  - **学位論文テンプレート (`thesis.typ`) の機能強化**
    - 製本・印刷余白モード `binding` オプションを追加 (`"digital"` / `"oneside"` / `"twoside"`)
    - 両面印刷（`twoside`）時の奇数・偶数ページでの見開きランニングヘッダー左右交互配置に対応
    - 表紙テンプレート (`thesis-cover`) に `subtitle`（副題）引数を追加し、全体の垂直余白バランスを改善
  - **レポートテンプレート (`report.typ`) の引数整理**
    - `report()` 関数で `title`, `author`, `student-id`, `date` などのメタデータを直接指定可能に
    - `project` および `report-header` との互換性を強化
  - **ユーティリティ改善 (`utils.typ`)**
    - 単位表記関数 `u()` のパース処理を改善（掛け算記号 `*` の正規化など）

### Changed

- テンプレートコード内のコメントおよび内部ドキュメントを英語に統一・整理し国際化対応を推進
- パッケージ内部のフォント・数式フォント設定処理をリファクタリング


---

## [2.0.0] - 2026-10-22

### Added

- **Starter Package v2.0.0** (`package/starter/2.0.0/`)
  - Typst 0.15.1 完全対応（`context` & `here()` 構文ベース）
  - 学位論文（卒業論文・修士論文・博士論文）テンプレート `thesis.typ`（`thesis()`, `thesis-cover()`, `thesis-abstract()`, `thesis-toc()`, `start-appendix()`）を追加
  - 章番号連動の数式・図表採番 `(1.1)`, `図 1.1`, `表 1.1` および付録自動採番 `(A.1)`, `図 A.1`
  - レポートテンプレートの `project()` + `report-header()` 分離スタイル対応
  - 外部パッケージのアップデート（`cetz:0.5.3`, `touying:0.8.0`）

- **Examples & Learning**
  - `examples/07_Thesis` — 学位論文（卒論・修論）の実践サンプルを追加
  - `learning/09_thesis_template.typ` — 学術論文テンプレートの内部実装・状態管理を学ぶステップ教材を追加

- **CI/CD & Installer**
  - `.github/workflows/ci.yml` — 全サンプル（`examples/`, `learning/`, `project-template/`）の自動コンパイル検証ワークフローを追加
  - `scripts/install-package.ps1` に `-TemplateType {report | thesis | slide}` オプションを追加
  - 単一バイナリインストーラー（`installer/`, `dist/`）を v2.0.0 向けに更新

---

## [1.1.1] - 2026-08-06

### Changed

- **Single-binary Installer / Scripts**
  - 初回プロジェクトの作成場所をカレントディレクトリ（`Downloads`等）からユーザーのホームディレクトリ（`C:\Users\{username}\`）直下に変更
  - 生成される初期プロジェクトのデフォルトフォルダ名を `My_Typst_Report` から `My_Typst` に変更
  - ドキュメント (`README.md`) の作成パスおよびチュートリアル手順の表記を更新

---

## [1.1.0] - 2026-08-05

### Added

- **Single-binary Installer** (`installer/`, `dist/`)
  - Go製クロスプラットフォーム単一バイナリインストーラー (`Typst-Starter-Setup-windows-amd64.exe` 等) の追加
  - ダブルクリックによるローカルパッケージ自動配置 (`%APPDATA%\typst\packages\local\starter\1.0.0`)
  - 新規プロジェクト (`project-template`) の自動フォルダ生成機能
  - リソース埋め込み (`go:embed`) とクロスコンパイル用ビルドスクリプト (`installer/build.ps1`)

- **Scripts** (`scripts/`)
  - `install-package.ps1` に `-CreateProject` スイッチを追加（CLIでのパッケージ配置 ＋ プロジェクト初期化対応）

---

## [1.0.0] - 2026-07-17

### Added

- **Starter Package** (`package/starter/1.0.0/`)
  - `report()` — レポートテンプレート
  - `slide()` — スライドテンプレート（Touying university theme）
  - 日本語フォント設定（原ノ味フォント優先 + フォールバック）
  - ローカライズされたキャプションラベル（図・表・式）
  - 外部パッケージ一元管理（physica, unify, cetz, showybox, whalogen）
  - ユーティリティ関数（bk, qed, crect, frect, ans, u, eqtag 等）


- **Project Template** (`project-template/`)
  - 最小構成のレポートテンプレート
  - VSCode 推奨設定
  - 参考文献ファイル
  - .gitignore

- **Examples** (`examples/`)
  - `01_First_Report` — 基本レポート
  - `02_Image` — 画像挿入
  - `03_Table` — 表作成
  - `04_Equation` — 数式記述
  - `05_Bibliography` — 参考文献
  - `06_Slide` — スライド作成

- **Learning** (`learning/`)
  - `01_minimal` 〜 `08_slide_template` — 段階的学習教材（8ファイル）

- **Scripts** (`scripts/`)
  - `install-package.ps1` — ローカルパッケージインストーラー


- **Documentation**
  - README.md（16章構成の導入ガイド）
  - 各ディレクトリの README.md
  - CHANGELOG.md
  - LICENSE（MIT）
  - 設計資料（docs/）
