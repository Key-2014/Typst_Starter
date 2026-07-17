// utils.typ
// 内部ユーティリティモジュール
//
// Starter 内部で利用するヘルパー関数群。
// 利用者はこのファイルを直接 import しない。
// lib.typ 経由で公開される。

// --- パッケージ依存 ---
#import "@preview/unify:0.8.1": qty

// --- 基本ユーティリティ ---

/// 全角スペース相当の水平スペース
#let bk = h(1em)

/// QED 記号（右寄せ）
#let qed = h(1fr) + $qed$

/// 右辺ラベル
#let rhs = [(右辺)]

/// 左辺ラベル
#let lhs = [(左辺)]

// --- 数学表記 ---

/// 組合せ nCr
#let combination(n, r) = math.attach(math.upright("C"), bl: n, br: r)

/// 順列 nPr
#let permutation(n, r) = math.attach(math.upright("P"), bl: n, br: r)

/// 重複組合せ nHr
#let hcombination(n, r) = math.attach(math.upright("H"), bl: n, br: r)

// --- ボックス ---

/// 中央寄せの矩形ボックス
#let crect(body) = align(center, block(
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body),
))

/// 全幅の矩形ボックス
#let frect(body) = block(
  width: 100%,
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body),
)

/// 解答ボックス（インライン）
#let ans(body) = box(
  stroke: 1pt,
  inset: (x: 5pt, y: 5pt),
  outset: (y: 3pt),
  radius: 2pt,
  baseline: 20%,
  if type(body) == str { body } else { $#body$ },
)

/// 単位フォーマッタ
/// - unit: 単位文字列（例: "m/s^2"）
/// - b: true の場合 [ ] で囲む
#let u(unit, b: false) = {
  let body = qty("", unit)
  let content = if b { $[#body]$ } else { body }
  $#h(0.16667em) #content$
}

/// 手動数式タグ（グローバルカウンターに影響しない）
/// - content: 数式内容
/// - tag: タグ文字列
#let eqtag(content, tag) = {
  math.equation(content, block: true, numbering: _ => "(" + tag + ")")
}
