# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

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
