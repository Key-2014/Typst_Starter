# Typst Starter 実装計画書
Version: 1.0.0 (Draft)

---

# 1. 概要

本書は Typst Starter Version 1.0.0 の実装タスクを定義する。

要求仕様書・実装仕様書・API仕様書に基づき、
AIエージェントが段階的に実装できるよう、
実装フェーズ・タスク・完了条件を整理する。

---

# 2. 実装方針

実装は以下の優先順位で行う。

```
Package
    ↓
Project Template
    ↓
README
    ↓
Examples
    ↓
Learning
    ↓
Assets
```

各フェーズ終了時に動作確認を行う。

---

# Phase 1
## Package 実装

### 目的

Starter Package の骨組みを構築する。

---

### 作業内容

- package ディレクトリ作成
- typst.toml 作成
- lib.typ 作成
- report.typ 作成
- slide.typ 作成
- theme.typ 作成
- fonts.typ 作成
- packages.typ 作成
- utils.typ 作成
- components.typ 作成

---

### 完了条件

- Package が import できる
- report が利用できる
- slide が利用できる

---

# Phase 2
## Project Template

### 目的

利用者がすぐレポートを書き始められるテンプレートを作成する。

---

### 作業内容

作成するファイル

```
project-template/

main.typ

refs.bib

images/

.vscode/settings.json

.gitignore
```

---

### 完了条件

Project Template をコピーするだけで
レポートを書き始められる。

---

# Phase 3
## README

### 目的

初心者向け導入ドキュメントを作成する。

---

### 作業内容

以下の章を作成する。

- Typst Starterとは
- 特徴
- 必要環境
- Typst導入
- VSCode導入
- 拡張機能
- Tinymist推奨設定
- 日本語フォント
- Package導入
- 最初のレポート
- Examples
- Learning
- GitHub（発展）
- Typst公式
- License

---

### 完了条件

READMEのみで環境構築が完了する。

---

# Phase 4
## Examples

### 目的

Starter Package の利用例を提供する。

---

### 作業内容

作成するExamples

```
01_First_Report

02_Image

03_Table

04_Equation

05_Bibliography

06_Slide
```

---

### 完了条件

全Exampleが独立してコンパイル可能。

---

# Phase 5
## Learning

### 目的

Starter の内部実装を学習できる教材を作成する。

---

### 作業内容

```
01_minimal.typ

02_page.typ

03_text.typ

04_heading.typ

05_figure.typ

06_table.typ

07_report_template.typ

08_slide_template.typ
```

すべてコメント付きで実装する。

---

### 完了条件

01→08 の順に読むことで
Starter の実装を理解できる。

---

# Phase 6
## Assets

### 目的

README 用画像を作成する。

---

### 作業内容

- VSCode画面
- Tinymist設定画面
- フォント比較画像
- ディレクトリ構造図

---

### 完了条件

README中の画像リンク切れがない。

---

# Phase 7
## 最終確認

以下を実施する。

- ディレクトリ確認
- README確認
- Package確認
- Examples確認
- Learning確認

---

# Version 1.0.0 Definition of Done

以下をすべて満たした場合、
Version1.0.0 とする。

□ Package完成

□ Project Template完成

□ README完成

□ Examples完成

□ Learning完成

□ Windowsで動作確認済み

□ READMEのみで導入可能

□ examplesが全てコンパイル成功

□ learningが全てコンパイル成功

□ 公開APIが仕様書と一致