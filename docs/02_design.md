# Typst Starter 実装仕様書
Version: 1.0.0 (Draft)

---

# 1. 概要

本書は Typst Starter Version 1.0.0 の実装仕様を定義する。

要求仕様書で定義した内容を実現するため、以下を設計対象とする。

- リポジトリ構成
- ローカルパッケージ構成
- 学習用ソースコード
- サンプルプロジェクト
- ドキュメント構成
- 公開API

本仕様書は AI エージェントによる実装を想定した仕様書である。

---

# 2. 設計方針

Typst Starter は

> 「使えるようにする」

だけではなく、

> 「学べるようにする」

ことを目的とする。

そのため、本リポジトリは以下の3層構造で構成する。

```
Package
    ↓
Examples
    ↓
Learning
```

各層の役割は明確に分離する。

---

# 3. リポジトリ構成

```
Typst_Starter/

├── README.md
├── LICENSE
├── CHANGELOG.md

├── docs/
│   ├── 01_requirements.md
│   ├── 02_design.md
│   ├── 03_package_api.md
│   └── images/

├── package/

├── project-template/

├── examples/

├── learning/

├── scripts/

├── assets/

└── .github/
```

---

# 4. ディレクトリ責務

## README.md

利用者が最初に読むドキュメント。

環境構築から最初のレポート作成までを案内する。

---

## docs/

設計資料。

開発者向け。

---

## package/

Starterのローカルパッケージ。

Typstから直接読み込まれる。

内部実装を含む。

---

## project-template/

新規プロジェクト開始用。

Packageを利用する最小構成を提供する。

---

## examples/

Packageの利用例。

利用者がコピーして利用することを目的とする。

---

## learning/

Starter内部の実装を学習するためのソースコード。

Packageを利用しない。

Typstの設定方法を理解することを目的とする。

---

## assets/

README用画像。

比較画像。

スクリーンショット。

---

## scripts/

補助スクリプト。

Version1.0ではPowerShellのみ対応。

---

# 5. package構成

```
package/

starter/

1.0.0/

typst.toml

lib.typ

report.typ

slide.typ

theme.typ

fonts.typ

packages.typ

components.typ

utils.typ
```

---

# 6. package責務

## lib.typ

公開APIのみ。

利用者はlib.typのみ利用する。

---

## report.typ

レポートテンプレート。

---

## slide.typ

スライドテンプレート。

---

## theme.typ

ページ設定。

余白。

Heading。

Figure。

Caption。

テーマ全体を管理する。

---

## fonts.typ

フォント設定。

Harano Ajiを優先し、

存在しない場合は標準日本語フォントへフォールバックする。

---

## packages.typ

Starter内部で利用するPackageを管理する。

例

- physica
- cetz
- tablex

利用者は直接importしない。

---

## utils.typ

内部Utility。

公開しない。

---

## components.typ

内部Component。

公開しない。

---

# 7. Project Template

```
project-template/

main.typ

refs.bib

images/

.vscode/

.gitignore
```

main.typ は

```
#import "@local/starter:1.0.0": report

#show: report.with(...)
```

のみで利用できる最小構成とする。

---

# 8. Examples

ExamplesはPackageを利用する。

```
01_First_Report

02_Image

03_Table

04_Equation

05_Bibliography

06_Slide
```

各Exampleは独立してコンパイル可能とする。

---

# 9. Learning

Learningは

Starterを理解するための教材である。

Packageを利用しない。

```
learning/

01_minimal.typ

02_page.typ

03_text.typ

04_heading.typ

05_figure.typ

06_table.typ

07_report_template.typ

08_slide_template.typ
```

---

## 学習方針

各ファイルは

前段階との差分のみ追加する。

利用者は

01→08

の順に読むことで

Starterの内部実装を理解できる。

---

# 10. README構成

READMEは以下の章構成とする。

```
1. Typst Starterとは

2. 特徴

3. 必要環境

4. Typst導入

5. VSCode導入

6. VSCode拡張機能

7. Tinymist推奨設定

8. 日本語フォント

9. Starter Package導入

10. 最初のレポート

11. Examples

12. Learning

13. GitHub（発展）

14. Typst公式ドキュメント

15. License
```

---

# 11. 外部Package

Starter内部では

Typst UniverseのPackageを利用する。

利用Packageは

packages.typ

で一元管理する。

READMEでは

各Packageの役割を簡潔に説明する。

---

# 12. フォント設計

Harano Ajiは推奨とする。

必須ではない。

Starterは

Harano Ajiが存在しない場合でも

日本語組版が可能であること。

---

# 13. Typst_Templateとの関係

Typst_Template

↓

テンプレート開発

↓

Starter Package

↓

Typst Starter

という関係を維持する。

Typst Starterでは

テンプレート開発は行わない。

Starter用に安定版のみ採用する。

---

# 14. 実装優先順位

Priority1

- package
- project-template

Priority2

- learning


Priority3

- README
- examples

Priority4

- scripts
- assets

---

# 15. Version1.0 完了条件

以下を満たした時点でVersion1.0とする。

✓ package完成

✓ Project Template完成

✓ README完成

✓ Examples完成

✓ Learning完成

✓ Windows動作確認

✓ 新規利用者による導入確認

---

# 16. 将来計画

Version1.x

- examples追加
- learning追加
- Template追加

Version2.x

- Linux対応
- macOS対応
- GUI Installer
- VSCode設定自動化
- Package拡充

---

# 17. 実装原則

本プロジェクトでは

**利用者が使用するコード**

と

**利用者が学習するコード**

を明確に分離する。

Packageは

保守性

再利用性

APIの安定性

を重視する。

Learningは

可読性

教育効果

コメント量

を重視する。

この2つは同じ実装を目的としながら、

異なる責務を持つものとして設計する。