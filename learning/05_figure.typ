// 05_figure.typ
// 学習ステップ 5: 図のキャプション設定
//
// 04_heading.typ との違い:
// - set figure() で図のキャプションラベルを日本語化
// - 数式のナンバリングを追加
// - 参考文献の設定を追加
//
// ポイント:
// - figure の supplement で「図」「表」などのラベルを設定
// - 数式ナンバリングは equation-numbering で制御

// --- ページ設定（02 と同じ）---
#set page(
  paper: "a4",
  margin: (x: 25mm, y: 30mm),
  numbering: "1",
)

#set par(
  justify: true,
  leading: 0.8em,
)

// --- テキスト設定（03 と同じ）---
#set text(
  font: ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math"),
  size: 11pt,
  lang: "ja",
)

#show math.equation: set text(
  font: ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho"),
  size: 11pt,
)

// --- 見出し設定（04 と同じ）---
#set heading(numbering: "1.1")

#show heading: it => {
  show math.equation: math.bold
  v(0.5em)
  it
  v(0.5em)
}

// --- ★ 新規追加: 図・表の設定 ---
// 図のキャプションラベルを「図」に設定
#set figure(supplement: [図])

// 表のキャプションラベルを「表」に設定
#show figure.where(kind: table): set figure(supplement: [表])

// 表のキャプションを表の上に配置（学術論文の慣例）
#show figure.where(kind: table): set figure.caption(position: top)

// --- ★ 新規追加: 数式設定 ---
// インライン分数は横書きスタイル
#show math.equation.where(block: false): set math.frac(style: "horizontal")

// ブロック数式のページ跨ぎを許可
#show math.equation.where(block: true): set block(breakable: true)

// 数式番号とラベル
#set math.equation(
  numbering: "(1)",
  supplement: [式],
)

// --- ★ 新規追加: 参考文献設定 ---
#set bibliography(
  title: "参考文献",
  style: "ieee",
)

= 図・表・数式の設定

== 図のキャプション

図のキャプションには自動的に「図 1:」のようなラベルが付きます。

（ここでは画像ファイルがないため、コード例のみ示します）

```typst
#figure(
  image("photo.png", width: 80%),
  caption: [実験装置の写真],
) <fig-apparatus>

@fig-apparatus に装置を示す。
```

== 表のキャプション

表のキャプションは表の上に配置されます。

#figure(
  table(
    columns: 3,
    table.header([*項目*], [*値*], [*単位*]),
    [長さ], [1.0], [m],
    [質量], [2.5], [kg],
  ),
  caption: [測定値の一覧],
) <tab-data>

@tab-data に測定値を示す。

== 数式番号

$ F = m a $ <eq-newton>

@eq-newton はニュートンの運動方程式である。

// 次のステップ: 06_table.typ で表の詳細な設定を学びます
