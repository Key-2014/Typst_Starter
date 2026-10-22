// thesis.typ
// 学術論文・学位論文テンプレートモジュール（学士・修士・博士論文対応）
// Typst 0.15.1 完全準拠（context & here() ベース）

#import "common.typ": *
#import "fonts.typ": _report-font-family, _report-math-font-family
#import "utils.typ": *

// --- 内部状態管理 ---
#let in-appendix = state("thesis-in-appendix", false)
#let show-running-header = state("thesis-show-running-header", false)

// --- 付録モードへの切り替え ---
// 付録章の直前で呼び出すことで、見出し・数式・図表の採番を A, A.1, (A.1), 図 A.1 へ自動切替する
#let start-appendix() = {
  in-appendix.update(true)
  counter(heading).update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)
}

// --- 論文メイン設定ルール ---
#let thesis(
  title: "",
  author: "",
  lang: "ja",
  supplement-lang: "ja",
  paper: "a4",
  margin: (top: 30mm, bottom: 30mm, left: 30mm, right: 30mm),
  twoside: false,
  body,
) = {
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)
  let font-family = _report-font-family(lang)
  let math-font-family = _report-math-font-family(lang)

  // --- ページ・ランニングヘッダー設定 ---
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
    header: context {
      if not show-running-header.get() {
        return none
      }
      let current-physical-page = here().page()
      let current-page = counter(page).display()
      let h1-list = query(heading.where(level: 1))
      let active-h1 = none
      for h in h1-list {
        if h.location().page() <= current-physical-page {
          active-h1 = h
        }
      }

      let header-title = if active-h1 != none {
        let h-num = counter(heading).at(active-h1.location())
        let app = in-appendix.at(active-h1.location())
        let prefix = if active-h1.numbering == none {
          ""
        } else if app {
          labels.appendix + " " + numbering("A", h-num.at(0)) + " "
        } else if h-num.len() > 0 and h-num.at(0) > 0 {
          if lang == "ja" {
            "第" + str(h-num.at(0)) + "章 "
          } else {
            "Chapter " + str(h-num.at(0)) + " "
          }
        } else {
          ""
        }
        prefix + active-h1.body
      } else {
        title
      }

      set text(size: 9pt, fill: luma(90))
      grid(
        columns: (1fr, auto),
        align(left)[#header-title],
        align(right)[#current-page],
      )
      v(0.3em)
      line(length: 100%, stroke: 0.5pt + luma(180))
    },
    footer: context {
      // ランニングヘッダー無効時（前付けページ等）のみ下部中央にページ番号を表示
      if not show-running-header.get() {
        align(center)[#counter(page).display()]
      }
    },
  )

  // --- 段落・フォント設定 ---
  set par(
    justify: true,
    first-line-indent: (amount: 1em, all: true),
    leading: 0.85em,
  )

  set text(
    font: font-family,
    size: 11pt,
    lang: lang,
  )

  // --- 参考文献設定 ---
  set bibliography(
    title: labels.citation,
    style: "ieee",
  )

  // --- 数式スタイル ---
  show math.equation: set text(font: math-font-family)
  show math.equation.where(block: false): set math.frac(style: "horizontal")
  show math.equation.where(block: true): set block(breakable: true)

  // --- 章連動の数式採番: (1.1) または (A.1) ---
  set math.equation(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if app { numbering("A", ch) } else { str(ch) }
      "(" + ch-str + "." + numbering("1", ..nums) + ")"
    },
    supplement: labels.eq,
  )

  // --- 章連動の図表採番: 図 1.1, 表 1.1 ---
  set figure(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if app { numbering("A", ch) } else { str(ch) }
      ch-str + "." + numbering("1", ..nums)
    },
    supplement: labels.fig,
  )
  show figure.where(kind: table): set figure(supplement: labels.tab)
  show figure.where(kind: table): set figure.caption(position: top)

  // --- 見出し採番 & 章改ページ制御 ---
  set heading(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let n = nums.pos()
      if app {
        if n.len() == 1 {
          labels.appendix + " " + numbering("A", n.at(0))
        } else {
          numbering("A", n.at(0)) + "." + n.slice(1).map(str).join(".")
        }
      } else {
        if n.len() == 1 {
          if lang == "ja" {
            "第" + str(n.at(0)) + "章"
          } else {
            "Chapter " + str(n.at(0))
          }
        } else {
          n.map(str).join(".")
        }
      }
    },
  )

  show heading.where(level: 1): set heading(supplement: none)

  // 各章（レベル1見出し）で数式・図表カウンターをリセットし改ページ
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)

    pagebreak(weak: true)
    v(2em)
    {
      show math.equation: math.bold
      text(18pt, weight: "bold")[#it]
    }
    v(1.5em)
  }

  show heading.where(level: 2): it => {
    v(1.2em)
    {
      show math.equation: math.bold
      text(14pt, weight: "bold")[#it]
    }
    v(0.8em)
  }

  show heading.where(level: 3): it => {
    v(1em)
    {
      show math.equation: math.bold
      text(12pt, weight: "bold")[#it]
    }
    v(0.6em)
  }

  body
}

// --- レイアウトコンポーネント: 論文表紙ページ ---
#let thesis-cover(
  academic-year: "",
  thesis-type: auto,
  title: "",
  affiliation: "",
  student-id: "",
  author: "",
  supervisor: "",
  date: "",
  lang: "ja",
) = {
  let resolved-thesis-type = if thesis-type == auto {
    if lang == "ja" { "卒業論文" } else { "Bachelor's Thesis" }
  } else {
    thesis-type
  }

  set page(header: none, footer: none)

  align(center + horizon)[
    #if academic-year != "" or resolved-thesis-type != "" [
      #text(16pt)[
        #if academic-year != "" [#academic-year #if lang == "ja" [年度] else [Academic Year]]
        #h(0.5em)
        #resolved-thesis-type
      ]
      #v(2.5em)
    ]

    #text(24pt, weight: "bold")[#title]

    #v(7em)

    #align(center)[
      #block(width: 70%)[
        #grid(
          columns: (auto, 1fr),
          row-gutter: 1.3em,
          if lang == "ja" [所属:] else [Affiliation:], h(1.5em) + affiliation,
          if lang == "ja" [学生番号:] else [Student ID:], h(1.5em) + student-id,
          if lang == "ja" [氏名:] else [Author:], h(1.5em) + author,
          if lang == "ja" [指導教員:] else [Supervisor:], h(1.5em) + supervisor,
          if lang == "ja" [提出日:] else [Date:], h(1.5em) + date,
        )
      ]
    ]
  ]
  pagebreak()
  counter(page).update(1)
}

// --- レイアウトコンポーネント: 概要（要旨）ページ ---
#let thesis-abstract(
  lang: "ja",
  body,
) = {
  let labels = supplement-labels.at(lang, default: supplement-labels.ja)
  set page(numbering: "i")

  align(center)[
    #text(16pt, weight: "bold")[#labels.abstract]
    #v(1.5em)
  ]

  block(width: 92%, align(left)[
    #set par(first-line-indent: (amount: 1em, all: true))
    #body
  ])
  pagebreak()
}

// --- レイアウトコンポーネント: 目次・図目次・表目次 ---
#let thesis-toc(
  lang: "ja",
  depth: 3,
  include-figures: false,
  include-tables: false,
) = {
  let labels = supplement-labels.at(lang, default: supplement-labels.ja)

  // 前付けはローマ数字ページ番号
  set page(numbering: "i")

  align(center)[#text(16pt, weight: "bold")[#labels.toc]]
  v(1.2em)
  outline(title: none, indent: auto, depth: depth)

  if include-figures {
    pagebreak()
    align(center)[#text(16pt, weight: "bold")[#labels.lof]]
    v(1.2em)
    outline(
      title: none,
      target: figure.where(kind: image),
    )
  }

  if include-tables {
    pagebreak()
    align(center)[#text(16pt, weight: "bold")[#labels.lot]]
    v(1.2em)
    outline(
      title: none,
      target: figure.where(kind: table),
    )
  }

  pagebreak()
  // 本文開始: ランニングヘッダーを有効化し、アラビア数字 1 ページへリセット
  show-running-header.update(true)
  counter(page).update(1)
}
