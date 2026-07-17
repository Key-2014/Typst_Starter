# Examples

Starter Package の利用例です。

---

## Examples 一覧

| Example | 内容 | 主な学習ポイント |
|---|---|---|
| `01_First_Report` | 最も基本的なレポート | テンプレートの使い方、見出しの書き方 |
| `02_Image` | 画像の挿入 | figure, image, キャプション、参照 |
| `03_Table` | 表の作成 | table, 列幅、ストライプ |
| `04_Equation` | 数式の記述 | 数式ナンバリング、physica, ans, eqtag |
| `05_Bibliography` | 参考文献の引用 | .bib ファイル、@key による引用 |
| `06_Slide` | スライドの作成 | Touying テーマ、title-slide |

---

## 利用方法

### コンパイル

各 Example は独立してコンパイルできます。

VSCode で `main.typ` を開くと自動的にプレビューされます。

コマンドラインでコンパイルする場合：

```powershell
typst compile examples/01_First_Report/main.typ
```

### コピーして利用

Examples の内容は自由にコピーして利用できます。
気になる Example のコードを自分のレポートに取り入れてください。

---

## 利用順について

Examples に順番はありますが、**利用順は自由** です。
必要な Example だけを参照してください。

---

## Package について

すべての Examples は Starter Package（`@local/starter:1.0.0`）を利用しています。

```typ
#import "@local/starter:1.0.0": *
```

Package がインストールされていない場合はコンパイルできません。
インストール方法は [README.md](../README.md) の「Starter Package 導入」を参照してください。
