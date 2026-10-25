# Starter Package

Typst Starter のローカルパッケージです。

> ⚠️ このディレクトリは **開発者向け** です。
> 通常の利用者はこのディレクトリを直接編集する必要はありません。

---

## 概要

`package/starter/2.1.0/` は Typst のローカルパッケージ（`@local/starter:2.1.0`）の実体です（後方互換性のために `1.0.0` も同梱されています）。

- **一般的な利用者**: リリースされているインストーラー（`Typst-Starter-Setup-*.exe` 等）を実行するだけで、Typst のローカルパッケージフォルダ（`%APPDATA%\typst\packages\local\starter\2.1.0\`）へ自動配置されます。
- **ドキュメントでの利用**: 利用者の `.typ` ファイルから `#import "@local/starter:2.1.0": *` の 1 行で読み込まれます。

---

## ディレクトリ構成

```
package/
└── starter/
    ├── 1.0.0/                ← 旧バージョン（後方互換用）
    └── 2.1.0/                ← 現行メジャーバージョン (Typst 0.15.1 対応)
        ├── typst.toml        ← パッケージメタ情報
        ├── lib.typ           ← 公開API（エントリーポイント）
        ├── report.typ        ← レポートテンプレート (report / project / report-header)
        ├── thesis.typ        ← 学術論文テンプレート (thesis / thesis-cover / thesis-abstract / thesis-toc / start-appendix)
        ├── slide.typ         ← スライドテンプレート (slide / slides, Touying 0.8.0)
        ├── common.typ        ← 外部パッケージ管理 & 多言語ラベル設定
        ├── fonts.typ         ← フォント設定（原ノ味明朝・原ノ味角ゴシック優先）
        └── utils.typ         ← ユーティリティ関数（u, ans, crect, frect, eqtag, P/C/H 等）
```

---

## 公開 API

利用者は `lib.typ` 経由で以下のテンプレート関数・ユーティリティを利用します：

| 関数                                                    | 説明                                                                            |
| ------------------------------------------------------- | ------------------------------------------------------------------------------- |
| `report()`                                              | レポート統合テンプレート（show rule）                                           |
| `project()` + `report-header()`                         | ページ設定とヘッダーを分離したレポート構成                                      |
| `thesis()`                                              | 学術論文・学位論文テンプレート（show rule、章連動採番・ランニングヘッダー付き） |
| `thesis-cover()` / `thesis-abstract()` / `thesis-toc()` | 論文用の表紙・要旨・目次（図目次・表目次対応）コンポーネント                    |
| `start-appendix()`                                      | 論文の付録モードへの切り替え（A, A.1, (A.1), 図 A.1 へ自動切替）                |
| `slide()` / `slides()`                                  | スライドテンプレート（show rule、Touying university theme）                     |

```typ
#import "@local/starter:2.1.0": *

#show: report.with(
  title: "レポートタイトル",
  author: "著者名",
)
```

---

## typst.toml

パッケージのメタ情報を定義します。

| フィールド | 値        |
| ---------- | --------- |
| name       | `starter` |
| version    | `2.1.0`   |
| entrypoint | `lib.typ` |
| license    | `MIT`     |
| compiler   | `0.15.1`  |

---

## 内部モジュール

以下は内部および共通モジュールです。

| モジュール   | 役割                                                                                                           |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| `common.typ` | 外部パッケージ（physica, unify, cetz, showybox, whalogen）の一元管理とローカライズラベル（図・表・式・付録等） |
| `fonts.typ`  | フォントファミリーの定義（原ノ味明朝・ゴシック + New Computer Modern）                                         |
| `utils.typ`  | ユーティリティ関数（bk, qed, crect, frect, ans, u, eqtag 等）                                                  |

---

## 編集時の注意

- 編集後は `scripts/install-package.ps1` でローカル環境への再インストールが必要です
- 変更後は全 `examples` と `learning` のコンパイルを確認し、`installer/build.ps1` でインストーラーバイナリを再生成してください
