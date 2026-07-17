// 02_page.typ
// 学習ステップ 2: ページ設定
//
// 01_minimal.typ との違い:
// - set page() でページサイズと余白を設定
// - set par() で段落の設定を追加
//
// ポイント:
// - set ルールで既存の要素のデフォルト値を変更できる
// - page の paper パラメータで用紙サイズを指定
// - margin で余白を設定

// --- ページ設定 ---
// A4 用紙、上下30mm・左右25mmの余白
#set page(
  paper: "a4",
  margin: (x: 25mm, y: 30mm),
  numbering: "1",  // ページ番号を表示
)

// --- 段落設定 ---
// 両端揃え、行間 0.8em
#set par(
  justify: true,
  leading: 0.8em,
)

= ページ設定の学習

このドキュメントでは `set page()` と `set par()` を使って
ページの基本設定を行っています。

== 用紙サイズ

`paper: "a4"` で A4 サイズを指定しています。
他にも `"a3"`, `"us-letter"` などが使えます。

== 余白

`margin: (x: 25mm, y: 30mm)` で左右25mm、上下30mmの余白を設定しています。
個別に指定する場合は `margin: (top: 30mm, bottom: 30mm, left: 25mm, right: 25mm)` と書きます。

== ページ番号

`numbering: "1"` でページ番号をアラビア数字で表示します。
`"i"` にするとローマ数字になります。

== 段落設定

`justify: true` で両端揃え、`leading: 0.8em` で行間を設定しています。

// 次のステップ: 03_text.typ でフォント設定を学びます
