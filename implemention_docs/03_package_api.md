# Typst Starter ローカルパッケージ API仕様書
Version: 1.0.0 (Draft)

---

# 1. 目的

本仕様書は Typst Starter が提供するローカルパッケージの公開APIを定義する。

このAPIは

- Project Template
- Examples
- README
- 利用者

すべてが利用する唯一のインターフェースである。

内部実装は自由に変更できるが、
公開APIは後方互換性を維持する。

---

# 2. 設計方針

## 2.1 シンプルであること

初心者でも理解できるAPIとする。

```
#import "@local/starter:1.0.0": *
```

だけで使い始められることを目標とする。

---

## 2.2 実装を隠蔽する

利用者は

lib.typ

utils.typ

components.typ

などを意識しない。

公開APIのみ利用する。

---

## 2.3 命名を分かりやすくする

関数名は

略称ではなく

意味が分かる名前を採用する。

例

report()

slide()

appendix()

など。

---

# 3. Package名

暫定

```
starter
```

正式名称は後日決定する。

---

# 4. バージョニング

Semantic Versioningを採用する。

```
1.0.0
```

```
1.1.0
```

```
2.0.0
```

互換性を維持する。

---

# 5. ディレクトリ構成

```
starter/

1.0.0/

typst.toml

lib.typ

report.typ

slide.typ

utils.typ

components.typ

theme.typ
```

---

# 6. 公開API

利用者は

```
#import "@local/starter:1.0.0": *
```

のみ使用する。

他ファイルへのimportは禁止する。

---

# 7. 公開マクロ

Version1.0.0

```
report()

slide()

```

のみ公開する。

---

## report()

レポートテンプレート。

ページ設定

フォント

余白

ヘッダー

フッター

などを適用する。

---

## slide()

スライドテンプレート。

16:9

タイトル

本文

などを提供する。

---

# 8. 非公開モジュール

以下は公開しない。

```
utils.typ

components.typ

theme.typ
```

これらは内部実装とする。

利用者は直接importしない。

---

# 9. typst.toml

Package情報を定義する。

含める内容

Package名

Version

Entry Point

作者

License

Description

---

# 10. import方法

推奨

```
#import "@local/starter:1.0.0": *
```

Version固定。

Versionを書かないimportは採用しない。

---

# 11. Project Template

main.typ

では

```
#import "@local/starter:1.0.0": *
```

のみ記述する。

テンプレート内部を直接importしない。

---

# 12. Examples

Exampleも

Project Templateと同じAPIを利用する。

Example専用APIは禁止。

---

# 13. Typst_Templateとの関係

Typst_Template

↓

Starter Package

という流れを維持する。

Starterでは

APIのみ保証する。

内部構造は変更可能。

---

# 14. 命名規則

公開マクロ

小文字

英単語

スネークケースは使用しない。

例

```
report()

slide()

```

内部関数

先頭に

_

を付与する。

例

```
_make_title()

_apply_theme()

```

---

# 15. コメント

すべての公開マクロに

説明コメントを書く。

Exampleから参照できるようにする。

---

# 16. 今後追加予定

Version1.1

```
article()

poster()

```

Version2.0

```
thesis()

resume()

```

---

# 17. 後方互換性

Version1.xでは

```
report()

slide()
```

のシグネチャを変更しない。

変更が必要な場合はVersion2とする。
