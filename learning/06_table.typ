// 06_table.typ
// 学習ステップ 6: 表の詳細設定
//
// 05_figure.typ との違い:
// - 表のさまざまなスタイルを学ぶ
// - 罫線、列幅、セル結合の方法
//
// ポイント:
// - table は columns で列数を指定
// - table.header でヘッダー行を定義
// - table.hline で水平罫線を追加

// --- ページ設定（02 と同じ）---
#set page(
  paper: "a4",
  margin: (x: 25mm, y: 30mm),
  numbering: "1",
)

#set par(justify: true, leading: 0.8em)

// --- テキスト設定（03 と同じ）---
#set text(
  font: ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math"),
  size: 11pt,
  lang: "ja",
)

// --- 見出し設定（04 と同じ）---
#set heading(numbering: "1.1")
#show heading: it => { v(0.5em); it; v(0.5em) }

// --- 図表設定（05 と同じ）---
#set figure(supplement: [図])
#show figure.where(kind: table): set figure(supplement: [表])
#show figure.where(kind: table): set figure.caption(position: top)

= 表の詳細設定

== 基本の表

最もシンプルな表の作り方です。

#figure(
  table(
    columns: 3,
    table.header([*元素*], [*記号*], [*原子番号*]),
    [水素], [H], [1],
    [ヘリウム], [He], [2],
    [リチウム], [Li], [3],
    [炭素], [C], [6],
  ),
  caption: [元素の一覧],
)

== 列幅の指定

列幅を明示的に指定できます。

#figure(
  table(
    columns: (1fr, 2fr, 1fr),
    align: (center, left, center),
    table.header([*ID*], [*説明*], [*値*]),
    [1], [これは長い説明文のサンプルです], [42],
    [2], [別の説明文], [17],
  ),
  caption: [列幅を指定した表],
)

== ストライプ（交互背景色）

```typst
#table(
  columns: 3,
  fill: (_, y) => if calc.odd(y) { luma(240) },
  ..
)
```

#figure(
  table(
    columns: 3,
    fill: (_, y) => if calc.odd(y) { luma(240) },
    table.header([*月*], [*売上*], [*前年比*]),
    [1月], [100万円], [+5%],
    [2月], [120万円], [+8%],
    [3月], [95万円], [-2%],
    [4月], [110万円], [+3%],
  ),
  caption: [交互背景色の表],
)

// 次のステップ: 07_report_template.typ でテンプレート化を学びます
