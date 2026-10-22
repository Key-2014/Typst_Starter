// utils.typ
// ユーティリティ関数モジュール

#import "@preview/unify:0.8.1": qty

// --- テキスト・数式補助 ---
#let bk = h(1em)
#let qed = h(1fr) + $qed$
#let rhs = [(右辺)]
#let lhs = [(左辺)]

// --- 順列・組合せ記法 ---
#let combination(n, r) = math.attach(math.upright("C"), bl: n, br: r)
#let permutation(n, r) = math.attach(math.upright("P"), bl: n, br: r)
#let hcombination(n, r) = math.attach(math.upright("H"), bl: n, br: r)

// --- ボックス装飾 ---
// 中央揃え枠線ボックス
#let crect(body) = align(center, block(
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body)
))

// 全幅枠線ボックス
#let frect(body) = block(
  width: 100%,
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body)
)

// 解答ボックス
#let ans(body) = box(
  stroke: 1pt,
  inset: (x: 5pt, y: 5pt),
  outset: (y: 3pt),
  radius: 2pt,
  baseline: 20%,
  if type(body) == str { body } else { $#body$ }
)

// 単位フォーマッタ（unify ラッパー）
#let u(unit-str, b: false) = {
  // '*' をスペースに正規化し "kg*m/s^2" 等を unify でパース可能にする
  let normalized = unit-str.replace("*", " ").trim()
  let m = normalized.match(regex("^([+-]?\\d+(?:\\.\\d+)?(?:[eE][+-]?\\d+)?)\\s+(.+)$"))

  if m != none and not b {
    // 数値と単位の両方が与えられた場合（例: "9.81 m/s^2"）
    let num-part = m.captures.at(0)
    let unit-part = m.captures.at(1)
    qty(num-part, unit-part)
  } else {
    // 単位のみをフォーマットする場合
    let body = qty("", normalized)
    let content = if b { $[#body]$ } else { body }
    $#h(0.16667em) #content$
  }
}

// グローバル数式カウンターに影響を与えずに手動タグを付与する
#let eqtag(content, tag) = {
  math.equation(content, block: true, numbering: _ => "(" + tag + ")")
}
