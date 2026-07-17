// report.typ
// レポートテンプレートモジュール
//
// ページ設定、フォント、余白、ヘッダー、フッター、
// 見出し、図表、数式のナンバリングなどを適用する。
//
// 利用方法:
//   #import "@local/starter:1.0.0": *
//   #show: report.with(
//     title: "レポートタイトル",
//     author: "著者名",
//   )

// --- 内部モジュール ---
#import "fonts.typ": _report-font-family, _report-math-font-family
#import "theme.typ": _get-labels
#import "components.typ": _report-header, _title-page, _table-of-contents

/// レポートテンプレート
///
/// ドキュメント全体にレポート用のスタイルを適用する show rule 関数。
///
/// - title: レポートのタイトル（デフォルト: ""）
/// - author: 著者名（デフォルト: ""）
/// - student-id: 学生番号（デフォルト: ""）
/// - date: 日付（デフォルト: none）
/// - lang: 言語コード（デフォルト: "ja"）
/// - supplement-lang: ラベル言語（デフォルト: "ja"）
/// - indent: 段落インデントの有無（デフォルト: false）
/// - heading-numbering: 見出しナンバリング（デフォルト: none）
/// - equation-numbering: 数式ナンバリング "1" or "1.1"（デフォルト: none）
/// - title-page: 独立した表紙ページの有無（デフォルト: false）
/// - toc: 目次の有無（デフォルト: false）
/// - body: ドキュメント本文
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
  // --- ラベル取得 ---
  let labels = _get-labels(supplement-lang)

  // --- フォント取得 ---
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

  // --- 数式フォント ---
  show math.equation: set text(
    font: math-font-family,
    size: 11pt,
  )

  // インライン分数は横書きスタイル
  show math.equation.where(block: false): set math.frac(style: "horizontal")

  // ブロック数式のページ跨ぎを許可
  show math.equation.where(block: true): set block(breakable: true)

  // --- 見出し設定 ---
  set heading(
    numbering: heading-numbering,
  )

  // 見出し前後のスペースと数式の太字化
  show heading: it => {
    show math.equation: math.bold
    v(0.5em)
    it
    v(0.5em)
  }

  // --- 数式ナンバリング ---
  // セクションごとにリセット（"1.1" の場合）
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

  // --- タイトル・ヘッダー ---
  if title-page {
    _title-page(
      title: title,
      author: author,
      student-id: student-id,
      date: date,
    )
  } else {
    _report-header(
      title: title,
      author: author,
      student-id: student-id,
      date: date,
    )
  }

  // --- 目次 ---
  if toc {
    _table-of-contents()
  }

  // --- 本文 ---
  body
}
