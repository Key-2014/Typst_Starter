# Project Template

新規プロジェクトを開始するためのテンプレートです。

---

## 使い方

### 1. フォルダをコピー

`project-template/` フォルダの内容を、新しいフォルダにコピーしてください。

```
my-report/             ← 新しいフォルダ
├── main.typ
├── refs.bib
├── images/
├── .vscode/
│   └── settings.json
└── .gitignore
```

### 2. main.typ を編集

タイトル、著者名、学生番号を自分の情報に書き換えてください。

```typ
#import "@local/starter:1.0.0": *

#show: report.with(
  title: "レポートタイトル",
  author: "氏名",
  student-id: "学生番号",
  date: datetime.today().display(),
  heading-numbering: "1.1",
)

= はじめに

ここに本文を書いてください。
```

### 3. PDF を確認

VSCode で `main.typ` を開くと、Tinymist が自動的にプレビューを表示します。

---

## ディレクトリ説明

| ファイル / ディレクトリ | 説明 |
|---|---|
| `main.typ` | メインファイル。ここにレポートを書く |
| `refs.bib` | 参考文献ファイル（BibTeX 形式） |
| `images/` | 画像を格納するディレクトリ |
| `.vscode/settings.json` | VSCode の推奨設定 |
| `.gitignore` | PDF ファイルを Git から除外する設定 |

---

## Starter Package との関係

このテンプレートは Starter Package（`@local/starter:1.0.0`）を利用しています。

`#import "@local/starter:1.0.0": *` の 1 行で、以下が自動的に適用されます：

- ページ設定（A4、余白 25mm/30mm）
- フォント設定（原ノ味明朝 + フォールバック）
- 見出し・図表・数式のスタイル
- 数学・物理パッケージ
- ユーティリティ関数

テンプレートの内部実装を知りたい場合は、[learning/](../learning/) を参照してください。
