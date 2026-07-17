# Starter Package

Typst Starter のローカルパッケージです。

> ⚠️ このディレクトリは **開発者向け** です。
> 通常の利用者はこのディレクトリを直接編集する必要はありません。

---

## 概要

`package/starter/1.0.0/` は Typst のローカルパッケージとしてインストールされ、
利用者のドキュメントから `#import "@local/starter:1.0.0": *` で読み込まれます。

---

## ディレクトリ構成

```
package/
└── starter/
    └── 1.0.0/
        ├── typst.toml       ← パッケージメタ情報
        ├── lib.typ           ← 公開API（エントリーポイント）
        ├── report.typ        ← レポートテンプレート
        ├── slide.typ         ← スライドテンプレート
        ├── theme.typ         ← テーマ・ラベル設定
        ├── fonts.typ         ← フォント設定
        ├── packages.typ      ← 外部パッケージ管理
        ├── utils.typ         ← ユーティリティ関数
        └── components.typ    ← レイアウトコンポーネント
```

---

## 公開 API

利用者は `lib.typ` 経由で以下の関数のみを利用します：

| 関数 | 説明 |
|---|---|
| `report()` | レポートテンプレート（show rule） |
| `slide()` | スライドテンプレート（show rule） |

```typ
#import "@local/starter:1.0.0": *

#show: report.with(
  title: "レポートタイトル",
  author: "著者名",
)
```

---

## typst.toml

パッケージのメタ情報を定義します。

| フィールド | 値 |
|---|---|
| name | `starter` |
| version | `1.0.0` |
| entrypoint | `lib.typ` |
| license | `MIT` |

---

## 内部モジュール

以下は内部モジュールであり、利用者は直接 import しません。

| モジュール | 役割 |
|---|---|
| `theme.typ` | ローカライズされたラベル（図・表・式）の管理 |
| `fonts.typ` | フォントファミリーの定義とフォールバック設定 |
| `packages.typ` | 外部パッケージ（physica, cetz 等）の一元管理 |
| `utils.typ` | ユーティリティ関数（bk, qed, crect, ans, u 等） |
| `components.typ` | レイアウトコンポーネント（ヘッダー、表紙、目次） |

---

## 編集時の注意

- **公開 API（`report()`, `slide()`）のシグネチャは変更しない**
  - Version 1.x では後方互換性を維持する
  - 変更が必要な場合は Version 2 とする
- 内部モジュールは自由に変更可能
- 編集後は `scripts/install-package.ps1` で再インストールが必要
- 変更後は全 examples と learning のコンパイルを確認すること
