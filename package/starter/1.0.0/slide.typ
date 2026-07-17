// slide.typ
// スライドテンプレートモジュール
//
// Touying フレームワークを利用した 16:9 スライドテンプレート。
// 日本語ゴシック体ベースのフォント設定を適用する。
//
// 利用方法:
//   #import "@local/starter:1.0.0": *
//   #show: slide.with(
//     title: [スライドタイトル],
//     author: [著者名],
//   )

// --- 内部モジュール ---
#import "fonts.typ": _slide-font-family, _slide-math-font-family
#import "theme.typ": _get-labels

// --- 外部パッケージ（スライド用） ---
#import "@preview/cetz:0.5.2": canvas, draw
#import "@preview/touying:0.7.4": *
#import themes.university: *
#import "@preview/fletcher:0.5.8" as fletcher
#import fletcher: edge, node
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *

// --- スライド用 Reducer ---
// アニメーション対応の Reducer
#let fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)
#let cetz-canvas = touying-reducer.with(
  reduce: canvas,
  cover: draw.hide.with(bounds: true),
)

/// スライドテンプレート
///
/// ドキュメント全体にスライド用のスタイルを適用する show rule 関数。
///
/// - lang: 言語コード（デフォルト: "ja"）
/// - supplement-lang: ラベル言語（デフォルト: "ja"）
/// - title: スライドタイトル
/// - subtitle: サブタイトル
/// - author: 著者名
/// - date: 日付
/// - institution: 所属機関
/// - logo: ロゴ
/// - aspect-ratio: アスペクト比（デフォルト: "16-9"）
/// - handout: ハンドアウトモード（デフォルト: false）
/// - font-size: フォントサイズ（デフォルト: 19pt）
/// - footer-a: フッター左
/// - footer-b: フッター中央
/// - footer-c: フッター右（デフォルト: ページ番号表示）
/// - body: スライド本文
#let slide(
  lang: "ja",
  supplement-lang: "ja",
  title: [],
  subtitle: [],
  author: [],
  date: none,
  institution: [],
  logo: none,
  aspect-ratio: "16-9",
  handout: false,
  font-size: 19pt,
  footer-a: [],
  footer-b: [],
  footer-c: self => {
    h(1fr)
    context utils.slide-counter.display() + "/" + utils.last-slide-number
    h(1fr)
  },
  body,
) = {
  // --- ラベル取得 ---
  let labels = _get-labels(supplement-lang)

  // --- フォント取得 ---
  let font-family = _slide-font-family(lang)
  let math-font-family = _slide-math-font-family(lang)

  // --- Theorion 定理環境 ---
  show: show-theorion

  // --- Touying テーマ設定 ---
  show: university-theme.with(
    aspect-ratio: aspect-ratio,
    config-common(
      handout: handout,
      frozen-counters: (theorem-counter,),
    ),
    config-info(
      title: title,
      subtitle: subtitle,
      author: author,
      date: date,
      institution: institution,
      logo: logo,
    ),
    config-store(
      footer-a: footer-a,
      footer-b: footer-b,
      footer-c: footer-c,
    ),
  )

  // --- テキスト設定（ゴシック体） ---
  set text(
    font: font-family,
    size: font-size,
    lang: lang,
  )

  // --- 数式フォント ---
  show math.equation: set text(
    font: math-font-family,
    size: font-size,
  )

  // インライン分数は横書きスタイル
  show math.equation.where(block: false): set math.frac(style: "horizontal")

  // ブロック数式のページ跨ぎを許可
  show math.equation.where(block: true): set block(breakable: true)

  set math.equation(
    supplement: labels.eq,
  )

  // --- 図表設定 ---
  set figure(supplement: labels.fig)
  show figure.where(kind: table): set figure(supplement: labels.tab)
  show figure.where(kind: table): set figure.caption(position: top)

  body
}
