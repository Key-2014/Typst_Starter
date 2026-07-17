# Typst Starter ドキュメント仕様書
Version: 1.0.0 (Draft)

---

# 1. 概要

本書は Typst Starter に含まれるすべてのドキュメントの役割と構成を定義する。

対象は以下とする。

- Repository README
- 各ディレクトリREADME
- CHANGELOG
- LICENSE

---

# 2. ドキュメント設計方針

ドキュメントは

「読む人」

によって役割を分離する。

| 利用者    | ドキュメント    |
| --------- | --------------- |
| 初心者    | README          |
| 利用者    | examples README |
| 学習者    | learning README |
| 開発者    | package README  |
| OSS利用者 | CHANGELOG       |
| 開発者    | docs            |

---

# 3. Repository README

READMEは

初心者が最初に読む資料とする。

## 章構成

1. Typst Starterとは

2. 特徴

3. 必要環境

4. Typst導入

5. VSCode導入

6. 拡張機能

7. Tinymist推奨設定

8. 日本語フォント

9. Starter Package導入

10. 最初のレポート

11. Project Template

12. Examples

13. Learning

14. GitHub（発展）

15. Typst公式ドキュメント

16. License

---

READMEのみで

環境構築から

最初のPDF生成まで

実施できること。

---

# 4. package/README.md

目的

Starter Package の説明。

対象

開発者。

記載内容

- packageとは
- ディレクトリ構成
- 公開API
- typst.toml
- 内部モジュール
- 編集時の注意

利用者は通常編集しないことを明記する。

---

# 5. project-template/README.md

目的

テンプレートの利用方法。

内容

- コピー方法
- ディレクトリ説明
- main.typ
- refs.bib
- images
- .vscode

Starter Packageとの関係。

---

# 6. examples/README.md

目的

Examplesの利用方法。

内容

Examples一覧

各Exampleの説明

利用順は自由であること。

Packageを利用していること。

Examplesは

コピーして利用してもよいこと。

---

# 7. learning/README.md

目的

Learning教材の説明。

内容

Learningの目的

推奨学習順

01〜08の説明

Packageとの違い

LearningはPackageを利用していないこと。

Starter内部実装を理解するための教材であること。

---

# 8. scripts/README.md

目的

PowerShellスクリプトの説明。

内容

各スクリプトの役割

実行方法

対応OS

注意事項

---

# 9. docs/README.md

目的

設計資料一覧。

内容

各仕様書の説明。

読む順番。

---

# 10. CHANGELOG.md

Keep a Changelog形式を採用する。

Versionごとに

追加

変更

修正

削除

を記録する。

Version1.0.0

Initial Release

- Starter Package
- Project Template
- Learning
- Examples

---

# 11. LICENSE

MIT License を採用する。

READMEからリンクする。

---

# 12. ドキュメント作成ルール

すべてMarkdownで記述する。

見出しは

# → ## → ###

を使用する。

コードは

言語指定付きコードブロックを使用する。

画像は

assets/

から参照する。

---

# 13. 完了条件

以下を満たすこと。

□ Repository README完成

□ package README完成

□ project-template README完成

□ examples README完成

□ learning README完成

□ scripts README完成

□ docs README完成

□ CHANGELOG完成

□ LICENSE完成

□ READMEリンク切れ無し