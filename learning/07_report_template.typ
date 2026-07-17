// 07_report_template.typ
// 学習ステップ 7: レポートテンプレートの作り方
//
// 06_table.typ までの設定をテンプレート関数にまとめます。
// これが Starter の report() 関数の原型です。
//
// ポイント:
// - #let で関数を定義する
// - show: function.with(...) でテンプレートを適用する
// - body パラメータでドキュメント本文を受け取る
// - これにより設定と本文を完全に分離できる

// === テンプレート関数の定義 ===
// この関数が Starter の report() と同じ役割を果たす
#let my-report(
  title: "",
  author: "",
  student-id: "",
  date: none,
  body,
) = {
  // --- ページ設定 ---
  set page(
    paper: "a4",
    margin: (x: 25mm, y: 30mm),
    numbering: "1",
  )

  // --- 段落設定 ---
  set par(
    justify: true,
    leading: 0.8em,
  )

  // --- テキスト設定 ---
  set text(
    font: ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math"),
    size: 11pt,
    lang: "ja",
  )

  // --- 数式フォント ---
  show math.equation: set text(
    font: ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho"),
    size: 11pt,
  )

  show math.equation.where(block: false): set math.frac(style: "horizontal")
  show math.equation.where(block: true): set block(breakable: true)

  // --- 見出し設定 ---
  set heading(numbering: "1.1")

  show heading: it => {
    show math.equation: math.bold
    v(0.5em)
    it
    v(0.5em)
  }

  // --- 図表設定 ---
  set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: table): set figure.caption(position: top)

  // --- 数式番号 ---
  set math.equation(
    numbering: "(1)",
    supplement: [式],
  )

  // --- 参考文献 ---
  set bibliography(
    title: "参考文献",
    style: "ieee",
  )

  // --- ヘッダー（タイトル・著者情報）---
  if title != "" {
    align(center, text(17pt, weight: "bold")[#title])
    v(1em)
  }

  if author != "" or student-id != "" or date != none {
    align(center)[
      #if student-id != "" [ #student-id ]
      #if student-id != "" and author != "" [ #h(2em) ]
      #if author != "" [ #author ]
      #if (student-id != "" or author != "") and date != none [ \ ]
      #if date != none [#date]
    ]
    v(2em)
  }

  // --- 本文を出力 ---
  body
}

// === テンプレートの利用 ===
// show: でテンプレートを適用する
// これ以降の内容がすべて body として渡される
#show: my-report.with(
  title: "自作テンプレートの例",
  author: "Typst 太郎",
  student-id: "12345678",
  date: datetime.today().display(),
)

= はじめに

ここまでの学習内容をテンプレート関数にまとめました。

`show: my-report.with(...)` の1行で、
すべての設定が適用されます。

= show ルールの仕組み

```typst
#show: my-report.with(
  title: "タイトル",
  author: "著者",
)
```

この記法は「ドキュメント全体を `my-report()` 関数に通す」という意味です。

== Starter の report() との違い

Starter の `report()` は、このテンプレートをさらに拡張し、
- フォント設定の分離（fonts.typ）
- テーマ設定の分離（theme.typ）
- コンポーネントの分離（components.typ）
を行っています。

機能は同じですが、保守性と再利用性を高めた構成になっています。

= まとめ

テンプレート関数の作り方を学びました。
`#let` で関数を定義し、`show:` で適用するのが Typst のテンプレートの基本パターンです。

// 次のステップ: 08_slide_template.typ でスライドテンプレートを学びます
