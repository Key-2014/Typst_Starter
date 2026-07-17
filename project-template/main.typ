// main.typ
// Typst Starter - Project Template
//
// このファイルをコピーしてレポートを書き始めてください。
// 詳しい使い方は README.md を参照してください。

#import "@local/starter:1.0.0": *

#show: report.with(
  title: "レポートタイトル",
  author: "氏名",
  student-id: "学生番号",
  date: datetime.today().display(),
  heading-numbering: "1.1",
)

= はじめに

ここに本文を書いてください。

= 方法

// 画像の挿入例:
// #figure(
//   image("images/sample.png", width: 80%),
//   caption: [サンプル画像],
// )

= 結果

// 表の挿入例:
// #figure(
//   table(
//     columns: 3,
//     [項目], [値], [単位],
//     [長さ], [1.0], [m],
//   ),
//   caption: [測定結果],
// )

= 考察

= まとめ

// 参考文献を使用する場合はコメントを外してください:
// #bibliography("refs.bib")
