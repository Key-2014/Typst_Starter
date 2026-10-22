// 09_thesis_template.typ
// 学習ステップ 9: 学術論文（学位論文）テンプレートの仕組み
//
// レポートテンプレート（07）をさらに発展させ、卒業論文・修士論文で必要となる
// 高度な組版制御の仕組みを学びます。
//
// ポイント:
// - state() を使った「前付け / 本文」「本文 / 付録」の状態管理
// - context と query() を使ったランニングヘッダー（章タイトルの自動取得）
// - 章（レベル1見出し）ごとの数式・図表カウンターのリセットと (1.1) 形式の採番
// - 付録モードへの切り替え関数 start-appendix()

// === 1. 状態変数（state）の定義 ===
// ドキュメントの現在位置が「付録かどうか」「本文のヘッダーを表示するか」を管理する
#let in-appendix = state("my-thesis-appendix", false)
#let show-header = state("my-thesis-header", false)

// 付録に切り替える関数
#let start-appendix() = {
  in-appendix.update(true)
  counter(heading).update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
}

// === 2. 論文テンプレート関数の定義 ===
#let my-thesis(
  title: "",
  author: "",
  body,
) = {
  // --- ページ設定とランニングヘッダー ---
  set page(
    paper: "a4",
    margin: (top: 30mm, bottom: 30mm, left: 30mm, right: 30mm),
    numbering: "1",
    header: context {
      if not show-header.get() { return none }
      let cur-page = here().page()
      let h1-list = query(heading.where(level: 1))
      let active-h1 = none
      for h in h1-list {
        if h.location().page() <= cur-page { active-h1 = h }
      }
      let header-text = if active-h1 != none {
        let n = counter(heading).at(active-h1.location()).at(0)
        let prefix = if in-appendix.at(active-h1.location()) {
          "付録 " + numbering("A", n) + " "
        } else {
          "第" + str(n) + "章 "
        }
        prefix + active-h1.body
      } else {
        title
      }
      set text(size: 9pt, fill: luma(90))
      grid(
        columns: (1fr, auto),
        align(left)[#header-text],
        align(right)[#counter(page).display()],
      )
      v(0.3em)
      line(length: 100%, stroke: 0.5pt + luma(180))
    },
    footer: context {
      if not show-header.get() {
        align(center)[#counter(page).display()]
      }
    },
  )

  // --- 段落・フォント設定 ---
  set par(justify: true, first-line-indent: (amount: 1em, all: true), leading: 0.85em)
  set text(
    font: ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math"),
    size: 11pt,
    lang: "ja",
  )

  // --- 章連動の見出しナンバリング ---
  set heading(
    numbering: (..nums) => {
      let n = nums.pos()
      if in-appendix.get() {
        if n.len() == 1 { "付録 " + numbering("A", n.at(0)) }
        else { numbering("A", n.at(0)) + "." + n.slice(1).map(str).join(".") }
      } else {
        if n.len() == 1 { "第" + str(n.at(0)) + "章" }
        else { n.map(str).join(".") }
      }
    },
  )

  // レベル1見出し（章）ごとにカウンターをリセットし改ページ
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    pagebreak(weak: true)
    v(1.5em)
    text(18pt, weight: "bold")[#it]
    v(1em)
  }

  // --- 章連動の数式・図表番号: (1.1), 図 1.1 ---
  set math.equation(
    numbering: (..nums) => {
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if in-appendix.get() { numbering("A", ch) } else { str(ch) }
      "(" + ch-str + "." + numbering("1", ..nums) + ")"
    },
    supplement: [式],
  )

  set figure(
    numbering: (..nums) => {
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if in-appendix.get() { numbering("A", ch) } else { str(ch) }
      ch-str + "." + numbering("1", ..nums)
    },
    supplement: [図],
  )
  show figure.where(kind: table): set figure(supplement: [表])
  show figure.where(kind: table): set figure.caption(position: top)

  body
}

// === 3. テンプレートの利用 ===
#show: my-thesis.with(
  title: "学位論文テンプレートの仕組み",
  author: "Typst 太郎",
)

// --- 前付け（目次など: ローマ数字ページ番号） ---
#set page(numbering: "i")
#align(center)[
  #text(20pt, weight: "bold")[学位論文テンプレートの仕組み] \
  #v(1em)
  #text(12pt)[Typst 太郎]
]
#v(2em)
#outline(indent: auto)

#pagebreak()
// --- 本文開始: ランニングヘッダーを有効化しアラビア数字 1 ページへ ---
#show-header.update(true)
#counter(page).update(1)
#set page(numbering: "1")

= 論文レイアウトの特徴

学術論文では、通常のレポートに加えて以下の組版ルールが求められます。

1. 前付け（概要・目次）はローマ数字（i, ii, ...）、本文はアラビア数字（1, 2, ...）のページ番号
2. ページ上部に現在の章タイトルを表示するランニングヘッダー
3. 章ごとにリセットされる数式番号 `(1.1)` や図表番号 `図 1.1`

$ E = m c^2 $ <eq:first>

@eq:first のように、第1章の数式は `(1.1)` と採番されます。

= 第2章でのカウンター動作

新しい章に入ると、数式や図表の番号は自動的にリセットされます。

$ F = m a $ <eq:second>

@eq:second のように、第2章の最初の数式は `(2.1)` となります。

#start-appendix()

= 補足資料

`#start-appendix()` を呼ぶと `state` が更新され、見出しが「付録 A」、数式番号が `(A.1)` に切り替わります。

$ a^2 + b^2 = c^2 $

// Starter Package の thesis() では、これらすべての機能に加え
// thesis-cover(), thesis-abstract(), thesis-toc() が用意されています。
