// components.typ
// 内部コンポーネントモジュール
//
// レイアウトコンポーネント（タイトルブロック、ヘッダー等）を定義する。
// 利用者はこのファイルを直接 import しない。

// --- レポートヘッダー ---
// 表紙ページなしの簡易ヘッダー

/// レポートヘッダーを生成する
/// - title: タイトル
/// - author: 著者名
/// - student-id: 学生番号
/// - date: 日付
#let _report-header(
  title: "",
  author: "",
  student-id: "",
  date: none,
) = {
  if title != "" {
    align(center)[
      #text(17pt, weight: "bold")[#title]
    ]
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
}

// --- 表紙ページ ---
// 独立した表紙ページ

/// 表紙ページを生成する
/// - title: タイトル
/// - author: 著者名
/// - student-id: 学生番号
/// - date: 日付
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

// --- 目次 ---

/// 目次を生成する
#let _table-of-contents() = {
  align(center)[#text(16pt, weight: "bold")[目次]]
  v(1em)
  outline(title: none, indent: auto)
  pagebreak()
}
