// report.typ
// レポート・一般ドキュメント用テンプレートモジュール
//
// 利用方法 1（Starter 一体型スタイル）:
//   #import "@local/starter:2.0.0": *
//   #show: report.with(
//     title: "レポートタイトル",
//     author: "著者名",
//     student-id: "12345678",
//     date: datetime.today().display(),
//     heading-numbering: "1.1",
//   )
//
// 利用方法 2（project + report-header 分離スタイル）:
//   #import "@local/starter:2.0.0": *
//   #show: project.with(heading-numbering: "1.1", equation-numbering: "1.1")
//   #report-header(title: "レポートタイトル", author: "著者名")

#import "common.typ": *
#import "fonts.typ": _report-font-family, _report-math-font-family
#import "utils.typ": *

// --- レイアウトコンポーネント: コンパクトヘッダー ---
// 表紙ページを作らない短中編レポート向けの先頭ヘッダー
#let report-header(
  title: "",
  author: "",
  student-id: "",
  date: none,
  lang: "ja",
) = {
  if title != "" {
    align(center)[
      #text(17pt, weight: "bold")[#title]
      #v(1em)
    ]
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
}

// --- 内部コンポーネント: 独立表紙 & 目次 ---
#let _title-page(
  title: "",
  author: "",
  student-id: "",
  date: none,
) = {
  page(numbering: none, align(center + horizon)[
    #if title != "" [ #text(24pt, weight: "bold")[#title] \ ]
    #v(2em)
    #if student-id != "" [ #text(14pt)[学生番号: #student-id] \ ]
    #if author != "" [ #text(14pt)[氏名: #author] \ ]
    #if date != none [ \ #text(12pt)[#date] ]
  ])
  counter(page).update(1)
}

#let _table-of-contents(title-label: "目次") = {
  align(center)[#text(16pt, weight: "bold")[#title-label]]
  v(1em)
  outline(title: none, indent: auto)
  pagebreak()
}

// --- メイン設定ルール（project: ページ・組版設定のみ適用） ---
#let project(
  lang: "ja",
  supplement-lang: "ja",
  heading-numbering: none,
  equation-numbering: none,
  indent: false,
  body,
) = {
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)
  let font-family = _report-font-family(lang)
  let math-font-family = _report-math-font-family(lang)

  // --- ページ設定 ---
  set page(
    paper: "a4",
    margin: (x: 25mm, y: 30mm),
    numbering: "1",
  )

  // --- 段落設定 ---
  set par(
    justify: true,
    first-line-indent: (
      amount: if indent { 1em } else { 0em },
      all: indent,
    ),
    leading: 0.8em,
  )

  // --- テキスト設定 ---
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

  // --- 数式設定 ---
  show math.equation: set text(
    font: math-font-family,
    size: 11pt,
  )
  show math.equation.where(block: false): set math.frac(style: "horizontal")
  show math.equation.where(block: true): set block(breakable: true)

  // --- 見出し設定 ---
  set heading(
    numbering: heading-numbering,
  )

  show heading: it => {
    show math.equation: math.bold
    v(0.5em)
    it
    v(0.5em)
  }

  // --- 数式ナンバリング制御 ---
  show heading.where(level: 1): it => {
    if equation-numbering == "1.1" and heading-numbering != none {
      counter(math.equation).update(0)
    }
    it
  }

  let target-numbering = if equation-numbering == "1" {
    "(1)"
  } else if equation-numbering == "1.1" {
    (..nums) => {
      let h = counter(heading).at(here())
      if h.len() > 0 and h.at(0) != 0 and heading-numbering != none {
        "(" + str(h.at(0)) + "." + numbering("1", ..nums) + ")"
      } else {
        "(" + numbering("1", ..nums) + ")"
      }
    }
  } else {
    equation-numbering
  }

  set math.equation(
    numbering: target-numbering,
    supplement: labels.eq,
  )

  // --- 図表設定 ---
  set figure(supplement: labels.fig)
  show figure.where(kind: table): set figure(supplement: labels.tab)
  show figure.where(kind: table): set figure.caption(position: top)

  body
}

// --- レポート統合テンプレート（report: ヘッダー・表紙・目次を一体制御） ---
#let report(
  title: "",
  author: "",
  student-id: "",
  date: none,
  lang: "ja",
  supplement-lang: "ja",
  indent: false,
  heading-numbering: none,
  equation-numbering: none,
  title-page: false,
  toc: false,
  body,
) = {
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)

  show: project.with(
    lang: lang,
    supplement-lang: supplement-lang,
    heading-numbering: heading-numbering,
    equation-numbering: equation-numbering,
    indent: indent,
  )

  if title-page {
    _title-page(
      title: title,
      author: author,
      student-id: student-id,
      date: date,
    )
  } else if title != "" or author != "" or student-id != "" or date != none {
    report-header(
      title: title,
      author: author,
      student-id: student-id,
      date: date,
      lang: lang,
    )
  }

  if toc {
    _table-of-contents(title-label: labels.toc)
  }

  body
}
