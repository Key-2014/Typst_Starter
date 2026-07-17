// 04_Equation - 数式の記述
//
// レポートに数式を挿入する方法を示します。
// インライン数式、ブロック数式、ナンバリング、
// 参照の方法を解説します。

#import "@local/starter:1.0.0": *

#show: report.with(
  title: "数式の記述例",
  author: "Typst 太郎",
  student-id: "12345678",
  date: datetime.today().display(),
  heading-numbering: "1.",
  equation-numbering: "1.1",  // セクションごとの数式番号
)

= インライン数式

本文中に数式を埋め込むには `$...$` で囲みます。

例えば、アインシュタインの式 $E = m c^2$ や、
二次方程式の解 $x = (-b plus.minus sqrt(b^2 - 4a c)) / (2a)$ のように記述できます。

= ブロック数式

独立した行に数式を表示するには、`$` の前後にスペースを入れます。

運動方程式：

$ F = m a $

マクスウェル方程式（ガウスの法則）：

$ nabla dot.op bold(E) = rho / epsilon_0 $ <eq-gauss>

@eq-gauss はガウスの法則を表す。

== ナンバリングについて

このサンプルでは `equation-numbering: "1.1"` を設定しているため、
数式番号はセクション番号に連動します（例：(1.1), (1.2), (2.1) ...）。

$ integral_0^infinity e^(-x^2) dif x = sqrt(pi) / 2 $

= 便利な記法

== physica パッケージ

Starter には physica パッケージが含まれています。
微分記号などが簡潔に書けます。

$ dv(f, x) = lim_(h -> 0) (f(x + h) - f(x)) / h $

$ pdv(u, t) = alpha pdv(u, x, 2) $

== 単位の表記

`u()` 関数で単位を綺麗にフォーマットできます。

速度 $v = #u("3.0 m/s")$、
加速度 $a = #u("9.8 m/s^2")$ のように使います。

== 解答ボックス

`ans()` で解答を囲むことができます。

$ x = #ans($2 sqrt(3)$) $

== 手動タグ

`eqtag()` でカウンターに影響しない手動タグを付けられます。

#eqtag($E = m c^2$, "*")
