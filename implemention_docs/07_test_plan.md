# Typst Starter テスト計画書
Version: 1.0.0 (Draft)

---

# 1. 目的

Typst Starter Version 1.0.0 が
要求仕様・実装仕様・API仕様を満たしていることを確認する。

---

# 2. テスト環境

対象OS

- Windows 11

Typst

- 最新安定版

VSCode

- 最新版

拡張機能

- Tinymist Typst
- vscode-pdf

---

# 3. テスト項目

## 3.1 README

### テスト内容

READMEのみを読み、
環境構築できること。

確認項目

□ Typst導入

□ VSCode導入

□ 拡張機能導入

□ Tinymist設定

□ Package導入

---

## 3.2 Package

確認項目

□ importできる

□ report利用可能

□ slide利用可能

□ コンパイル成功

---

## 3.3 Project Template

確認項目

□ main.typ がコンパイルできる

□ PDF生成

□ refs.bib利用可能

□ images利用可能

---

## 3.4 Examples

すべて確認する。

□ 01_First_Report

□ 02_Image

□ 03_Table

□ 04_Equation

□ 05_Bibliography

□ 06_Slide

すべて単独でコンパイル成功。

---

## 3.5 Learning

確認項目

01〜08

すべてコンパイル成功。

コメントが読める。

学習順序が自然である。

---

## 3.6 Fonts

Harano Ajiあり

□ 正常表示

Harano Ajiなし

□ フォールバック成功

□ 日本語表示成功

---

## 3.7 外部Package

Starter内部で利用するPackageが

正常に読み込まれること。

対象

- physica
- cetz
- tablex
- その他利用Package

---

## 3.8 API

仕様書と一致すること。

確認項目

□ 公開APIのみ利用

□ 非公開モジュールへ依存しない

□ import方法が統一されている

---

# 4. 利用者テスト

対象

Typst未経験者

VSCode初心者

---

実施内容

READMEのみを渡す。

質問なしで導入できるか確認する。

---

確認項目

□ Typst導入できた

□ Package導入できた

□ 最初のレポートを書けた

□ Examplesが開けた

□ Learningを読めた

---

# 5. リグレッションテスト

Package更新時は

以下を必ず再確認する。

□ main.typ

□ report

□ slide

□ Examples

□ Learning

---

# 6. リリース判定

Version1.0.0 は

以下をすべて満たした場合にリリース可能とする。

□ 全テスト成功

□ README確認済み

□ Windows確認済み

□ Package確認済み

□ Examples確認済み

□ Learning確認済み

□ API仕様との一致確認済み

□ 要求仕様との整合性確認済み