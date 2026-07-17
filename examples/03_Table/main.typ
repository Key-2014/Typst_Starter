// 03_Table - 表の作成
//
// レポートに表を挿入する方法を示します。
// table と figure を使って、キャプション付きの表を作成します。

#import "@local/starter:1.0.0": *

#show: report.with(
  title: "表の作成例",
  author: "Typst 太郎",
  student-id: "12345678",
  date: datetime.today().display(),
  heading-numbering: "1.",
)

= 基本的な表

Typst では `table()` 関数で表を作成します。
`figure()` で囲むことでキャプションと番号が付きます。

Starter テンプレートでは、表のキャプションは自動的に表の上に配置されます。

#figure(
  table(
    columns: 3,
    align: (center, center, center),
    table.header(
      [*試行*], [*周期 $T$ / s*], [*振幅 / mm*],
    ),
    [1], [1.793], [50],
    [2], [1.795], [48],
    [3], [1.794], [49],
    [4], [1.792], [51],
    [5], [1.796], [47],
  ),
  caption: [単振り子の周期測定結果],
) <tab-pendulum>

@tab-pendulum に測定結果を示す。
周期の平均値は $T = #u("1.794 s")$ であった。

= 表のスタイル

== 罫線のカスタマイズ

`table.hline()` や `table.vline()` で罫線を追加できます。

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    table.header(
      [*物質*], [*密度 / kg m⁻³*], [*融点 / °C*], [*沸点 / °C*],
    ),
    table.hline(),
    [水],     [1000],  [0],    [100],
    [エタノール], [789],   [-114], [78],
    [鉄],     [7874],  [1538], [2862],
  ),
  caption: [物質の物性値],
)
