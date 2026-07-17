// 04_heading.typ
// 学習ステップ 4: 見出し設定
//
// 03_text.typ との違い:
// - set heading() でナンバリングを設定
// - show heading で見出しの前後にスペースを追加
// - 見出し内の数式を太字に
//
// ポイント:
// - set で既定値を変更し、show で表示方法をカスタマイズする
// - show ルールは「この要素が現れたら、こう表示する」というルール

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

// --- ★ 新規追加: 見出し設定 ---
// ナンバリング形式: "1.1" → 1, 1.1, 1.1.1 ...
#set heading(
  numbering: "1.1",
)

// --- ★ 新規追加: 見出しの show ルール ---
// 見出しの前後にスペースを追加し、
// 見出し内の数式を太字にする
#show heading: it => {
  show math.equation: math.bold
  v(0.5em)  // 見出し前のスペース
  it
  v(0.5em)  // 見出し後のスペース
}

= 見出し設定の学習

このドキュメントでは見出しにナンバリングを設定しています。

== set と show の違い

=== set ルール

`set` は要素のデフォルト値を変更します。

```typst
#set heading(numbering: "1.1")
```

これにより、すべての見出しに自動的に番号が付きます。

=== show ルール

`show` は要素の表示方法をカスタマイズします。

```typst
#show heading: it => {
  v(0.5em)
  it
  v(0.5em)
}
```

これにより、見出しの前後にスペースが追加されます。

== 見出しと数式 $E = m c^2$

見出し内の数式は自動的に太字になります。

= 第2章

このように章番号が自動的に付与されます。

// 次のステップ: 05_figure.typ で図のキャプション設定を学びます
