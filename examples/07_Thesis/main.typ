// 07_Thesis - 学位論文（卒業論文・修士論文）の作成
//
// Starter Package の thesis() テンプレートを使った学位論文の例です。
// 表紙、概要（ローマ数字ページ番号）、目次・図目次・表目次、
// 章番号に連動する数式・図表番号、ランニングヘッダー、
// 付録モードへの切り替え（start-appendix）を備えています。

#import "@local/starter:2.0.0": *

// 1. 論文テンプレートを適用
#show: thesis.with(
  title: "Typst による学術論文執筆用テンプレートの構築と検証",
  author: "Typst 太郎",
  lang: "ja",
  supplement-lang: "ja",
)

// 2. 表紙ページの生成
#thesis-cover(
  academic-year: "2026",
  thesis-type: "卒業論文",
  title: "Typst による学術論文執筆用\nテンプレートの構築と検証",
  affiliation: "○○大学 理学部 物理学科",
  student-id: "12345678",
  author: "Typst 太郎",
  supervisor: "○○ △△ 教授",
  date: "2026年12月20日",
  lang: "ja",
)

// 3. 概要（前付け: ローマ数字ページ番号 i, ii, ...）
#thesis-abstract(lang: "ja")[
  本論文では，現代的な組版システム「Typst」を用いて，日本語の理学・工学系論文を効率的かつ美しく組版するためのテンプレート設計について述べる．
  Typst 0.15 の構文に準拠し，章ごとに連動する数式・図表の採番制御，ランニングヘッダー，付録モード，前付けと本文のページ番号自動切り替えを実装した．
  本稿では，これらの機能が意図通りに動作することを検証し，その有用性を示す．
]

// 4. 目次・図目次・表目次の生成（終了後に自動でアラビア数字 1 ページへ切り替え）
#thesis-toc(
  lang: "ja",
  depth: 3,
  include-figures: true,
  include-tables: true,
)

// 5. 本文（第1章）
= はじめに

本章では，研究の背景および本論文の目的について述べる．

近年，学術論文の執筆において軽量マークアップ言語の需要が高まっている．
特に Typst @feynman は，高速なプレビューと直感的な文法を備えており，学術分野で注目を集めている．

== 論文の構成
本論文は以下の構成をとる．
第2章では，数式表記や図表の配置，章番号に連動した採番システムの検証結果について述べる．
第3章では，本研究のまとめを行う．

= 数式・図表および章連動採番の検証

本章では，章番号に連動した各種カウンター（数式番号，図番号，表番号）の動作を確認する．

== 数式の記述と採番
電磁気学の基本方程式であるマクスウェル方程式は，`physica` パッケージを用いて以下のように記述できる．

$
  div vb(E) = rho / epsilon_0
$ <eq:gauss>

$
  curl vb(B) - 1/c^2 pdv(vb(E), t) = mu_0 vb(j)
$ <eq:ampere>

@eq:gauss および @eq:ampere のように，数式番号は章番号（第2章）と連動して `(2.1)`，`(2.2)` と自動採番される．

== 図および表の配置と採番
Typst 内でのベクター作図には `cetz` パッケージを利用できる．
@fig:circle に作図例を示す．

#figure(
  canvas({
    import draw: *
    circle((0, 0), radius: 1.5, fill: blue.lighten(80%), stroke: 1.5pt + blue)
    content((0, 0), text(size: 11pt, weight: "bold")[CeTZ Canvas])
  }),
  caption: [CeTZ によるベクターグラフィックスの描画例],
) <fig:circle>

また，@tab:sample に基礎物理定数の表を示す．
表のキャプションは慣例に従い上部に自動配置される．

#figure(
  table(
    columns: (auto, auto, auto),
    align: (left, center, right),
    stroke: (x, y) => if y == 0 { (bottom: 1.5pt) } else if y == 3 { (bottom: 1.5pt) } else { none },
    table.header([*定数名*], [*記号*], [*標準値*]),
    [真空中の光速], [$c$], [#qty("2.99792458e8", "m/s")],
    [電気素量], [$e$], [#qty("1.602176634e-19", "C")],
    [プランク定数], [$h$], [#qty("6.62607015e-34", "J s")],
  ),
  caption: [基礎物理定数の標準値],
) <tab:sample>

図番号は @fig:circle のように `図 2.1`，表番号は @tab:sample のように `表 2.1` となり，章番号と同期している．

= まとめ

本論文では，Typst Starter の `thesis()` テンプレートによる学位論文の構成例を示した．
章ごとのカウンターリセット，図表および数式の連動採番，ランニングヘッダー表示が自動的に適用される．

// 6. 付録モードへの切り替え
#start-appendix()

= 導出の詳細

`#start-appendix()` を呼び出すと，以降の章は付録モードに切り替わる．

== 波動方程式の導出
真空中におけるマクスウェル方程式から，電場 $vb(E)$ に対する波動方程式は以下のように導出される．

$
  laplacian vb(E) - 1/c^2 pdv(vb(E), t, [2]) = 0
$ <eq:wave>

付録モードでは，見出し番号は「付録 A」，数式番号は @eq:wave のように `(A.1)` と英文字採番へ切り替わる．

#figure(
  canvas({
    import draw: *
    rect((-2, -0.8), (2, 0.8), fill: green.lighten(85%), stroke: 1pt + green.darken(20%))
    content((0, 0), [付録内グラフィック])
  }),
  caption: [付録内における図の採番確認],
) <fig:app-diagram>

図番号も同様に @fig:app-diagram のように `図 A.1` となる．

// 7. 参考文献
#bibliography("refs.bib")
