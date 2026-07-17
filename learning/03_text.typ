// 03_text.typ
// 学習ステップ 3: テキスト・フォント設定
//
// 02_page.typ との違い:
// - set text() でフォントとサイズを設定
// - 日本語フォントのフォールバック設定
// - 数式フォントの設定
//
// ポイント:
// - font にはフォールバックリストを指定できる
// - 最初に見つかったフォントが使われる
// - lang で言語を指定すると、改行位置などが適切になる

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

// --- ★ 新規追加: テキスト・フォント設定 ---
// フォントのフォールバック:
// 1. New Computer Modern — 欧文の美しいフォント
// 2. Harano Aji Mincho — 日本語明朝体（インストールされている場合）
// 3. New Computer Modern Math — 数式用フォント
//
// Harano Aji がインストールされていない場合は
// システムの日本語フォントが自動的に使われます
#set text(
  font: ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math"),
  size: 11pt,
  lang: "ja",  // 日本語の組版ルールを適用
)

// --- ★ 新規追加: 数式フォント設定 ---
// 数式では Math フォントを優先する
#show math.equation: set text(
  font: ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho"),
  size: 11pt,
)

= テキスト・フォント設定の学習

このドキュメントでは `set text()` を使ってフォントを設定しています。

== フォントの仕組み

Typst ではフォントを配列で指定します。
先頭のフォントから順に、そのフォントに含まれるグリフ（文字）を探します。

例えば `"New Computer Modern"` には日本語のグリフがないため、
日本語の文字は次のフォント `"Harano Aji Mincho"` で描画されます。

== 日本語の表示確認

漢字: 東京大学　ひらがな: あいうえお　カタカナ: アイウエオ

== 数式の表示確認

インライン: $E = m c^2$, $alpha + beta = gamma$

ブロック数式:

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

// 次のステップ: 04_heading.typ で見出し設定を学びます
