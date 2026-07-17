// 05_Bibliography - 参考文献
//
// 参考文献の引用方法を示します。
// BibTeX 形式の .bib ファイルを使って文献管理を行います。

#import "@local/starter:1.0.0": *

#show: report.with(
  title: "参考文献の使い方",
  author: "Typst 太郎",
  student-id: "12345678",
  date: datetime.today().display(),
  heading-numbering: "1.",
)

= はじめに

レポートや論文では参考文献の引用が重要です。
Typst では BibTeX 形式の `.bib` ファイルを使って文献管理ができます。

= 引用の方法

文献を引用するには `@key` と記述します。

アインシュタインの特殊相対性理論 @einstein1905 は物理学の基礎である。
また、ファインマン物理学 @feynman は優れた教科書として知られている。

== 引用スタイル

Starter テンプレートでは IEEE スタイルが標準設定されています。
引用は自動的に番号付きで表示されます。

= .bib ファイルの書き方

`refs.bib` ファイルに以下のような形式で文献情報を記述します：

```bib
@article{einstein1905,
  author  = "Albert Einstein",
  title   = "On the electrodynamics of moving bodies",
  journal = "Annalen der Physik",
  year    = "1905",
}
```

`@article` は論文、`@book` は書籍、`@inproceedings` は学会発表に使用します。

// 参考文献リスト（ここで refs.bib を読み込む）
#bibliography("refs.bib")
