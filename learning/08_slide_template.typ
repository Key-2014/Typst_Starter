// 08_slide_template.typ
// 学習ステップ 8: スライドテンプレートの基礎
//
// レポートテンプレート（07）との違い:
// - ページサイズが 16:9 のスライド用
// - ゴシック体ベースのフォント
// - スライド特有のレイアウト
//
// ポイント:
// - Starter の slide() は Touying フレームワークを利用している
// - ここでは Touying を使わない最小のスライドテンプレートを示す
// - 実際の利用では Starter の slide() を使うことを推奨

// === 最小のスライドテンプレート ===
#let my-slide(
  title: "",
  author: "",
  body,
) = {
  // --- ページ設定: 16:9 ---
  set page(
    width: 254mm,     // 16:9 の横幅
    height: 142.9mm,  // 16:9 の高さ
    margin: (x: 20mm, y: 15mm),
  )

  // --- フォント: ゴシック体 ---
  // スライドではゴシック体（サンセリフ）が見やすい
  set text(
    font: ("New Computer Modern", "Harano Aji Gothic", "New Computer Modern Math"),
    size: 18pt,
    lang: "ja",
  )

  // --- 見出し設定 ---
  show heading.where(level: 1): it => {
    // レベル1の見出しでページ区切り
    pagebreak(weak: true)
    v(0.5em)
    text(24pt, weight: "bold")[#it.body]
    v(0.5em)
    line(length: 100%, stroke: 2pt + blue)
    v(0.5em)
  }

  show heading.where(level: 2): it => {
    v(0.3em)
    text(20pt, weight: "bold")[#it.body]
    v(0.3em)
  }

  // --- 数式フォント ---
  show math.equation: set text(
    font: ("New Computer Modern Math", "New Computer Modern", "Harano Aji Gothic"),
    size: 18pt,
  )

  // --- 図表設定 ---
  set figure(supplement: [図])
  show figure.where(kind: table): set figure(supplement: [表])

  // --- タイトルページ ---
  if title != "" {
    align(center + horizon)[
      #text(28pt, weight: "bold")[#title]
      #v(2em)
      #if author != "" [ #text(16pt)[#author] ]
    ]
  }

  // --- 本文 ---
  body
}

// === テンプレートの利用 ===
#show: my-slide.with(
  title: "自作スライドの例",
  author: "Typst 太郎",
)

= スライドの基本

スライドではページサイズを 16:9 に設定します。

- ゴシック体で読みやすく
- 大きめのフォントサイズ
- 見出しでページ区切り

= 数式

数式もスライドで使えます。

$ E = m c^2 $

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

= Starter の slide() について

実際の利用では Starter の `slide()` を使ってください。

Starter の `slide()` は：
- *Touying フレームワーク* を利用
- アニメーション対応
- テーマ（university）付き
- フッター・ロゴ対応

など、より高機能です。

= まとめ

以上で学習は完了です！

- 01〜06: Typst の基本設定を学んだ
- 07: レポートテンプレートの作り方を学んだ
- 08: スライドテンプレートの基礎を学んだ

これらの設定は Starter Package に組み込まれているため、
実際の利用では `report()` や `slide()` を使うだけで OK です。
