// 02_Image - 画像の挿入
//
// レポートに画像を挿入する方法を示します。
// figure と image を使って、キャプション付きの画像を配置します。

#import "@local/starter:1.0.0": *

#show: report.with(
  title: "画像の挿入例",
  author: "Typst 太郎",
  student-id: "12345678",
  date: datetime.today().display(),
  heading-numbering: "1.",
)

= 画像の挿入

Typst では `image()` 関数で画像を挿入し、`figure()` で囲むことでキャプションと番号を付けることができます。

== 基本的な画像挿入

画像を挿入するには以下のように記述します：

```typst
#figure(
  image("sample.png", width: 80%),
  caption: [サンプル画像],
)
```

== 画像の配置

画像のサイズは `width` パラメータで制御できます。

- `width: 50%` — ページ幅の50%
- `width: 80%` — ページ幅の80%
- `width: 100%` — ページ全幅

== 画像の参照

`figure` にラベルを付けると、本文中から参照できます。

```typst
#figure(
  image("sample.png", width: 60%),
  caption: [実験装置の写真],
) <fig-apparatus>

@fig-apparatus に実験装置を示す。
```

= 注意事項

- 画像ファイルは `images/` ディレクトリに配置することを推奨します
- 対応形式: PNG, JPEG, SVG
- SVG 形式はベクター画像として高品質に表示されます
