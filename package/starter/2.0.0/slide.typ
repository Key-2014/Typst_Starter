// slide.typ
// スライドプレゼンテーション用テンプレートモジュール
// Touying (university テーマ) + Theorion + Fletcher + CeTZ 対応

#import "common.typ": *
#import "fonts.typ": _slide-font-family, _slide-math-font-family
#import "utils.typ": *

// --- スライド・Touying パッケージ ---
#import "@preview/touying:0.8.0": *
#import themes.university: *
#import "@preview/fletcher:0.5.8" as fletcher
#import fletcher: edge, node
#import "@preview/numbly:0.1.0": numbly
#import "@preview/theorion:0.6.0": *

// --- アニメーション対応 Reducer ---
#let fletcher-diagram = touying-reducer.with(
  reduce: fletcher.diagram,
  cover: fletcher.hide,
)
#let cetz-canvas = touying-reducer.with(
  reduce: canvas,
  cover: draw.hide.with(bounds: true),
)

// --- スライドメイン設定ルール ---
#let slides(
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
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)
  let font-family = _slide-font-family(lang)
  let math-font-family = _slide-math-font-family(lang)

  // Theorion 定理環境を有効化
  show: show-theorion

  // Touying university テーマを設定
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

  // 日本語ゴシック体フォント設定
  set text(
    font: font-family,
    size: font-size,
    lang: lang,
  )

  set bibliography(
    title: labels.citation,
    style: "ieee",
  )

  // 数式フォント設定
  show math.equation: set text(
    font: math-font-family,
    size: font-size,
  )

  show math.equation.where(block: false): set math.frac(style: "horizontal")
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

// Starter 1.x 互換エイリアス
#let slide = slides
