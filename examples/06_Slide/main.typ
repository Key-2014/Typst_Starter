// 06_Slide - スライドの作成
//
// Starter Package を使ったスライドの作成例です。
// Touying フレームワークの university テーマを利用します。

#import "@local/starter:1.0.0": *

// スライドテンプレートを適用
#show: slide.with(
  title: [Typst Starter スライド例],
  subtitle: [スライド作成の基本],
  author: [Typst 太郎],
  date: datetime.today().display(),
  institution: [○○大学 △△研究室],
)

// タイトルスライド
#title-slide()

// 目次スライド
== Outline <touying:hidden>

#components.adaptive-columns(outline(title: none, indent: 1em))

// --- 本文スライド ---

== はじめに

Typst Starter を使えば、スライドも簡単に作成できます。

- レポートと同じパッケージから利用可能
- 日本語ゴシック体が自動設定
- 16:9 のアスペクト比

== 箇条書き

スライドでは箇条書きが効果的です。

- 第一の項目
  - サブ項目 A
  - サブ項目 B
- 第二の項目
- 第三の項目

== 数式

数式もレポートと同様に記述できます。

$ E = m c^2 $

$ integral_0^(2 pi) sin(x) dif x = 0 $

== まとめ

- Starter で統一されたスライドを作成
- レポートと同じ API で利用可能
- 詳しくは Touying のドキュメントを参照
