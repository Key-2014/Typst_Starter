// theme.typ
// テーマ設定モジュール
//
// ページ設定、余白、Heading、Figure、Caption など
// ドキュメントのテーマ全体を管理する。

// --- ローカライズされたラベル ---
// 図・表・式・参考文献のキャプションラベル
#let _supplement-labels = (
  ja: (
    fig: "図",
    tab: "表",
    eq: "式",
    citation: "参考文献",
  ),
  en: (
    fig: "Fig.",
    tab: "Table",
    eq: "Eq.",
    citation: "References",
  ),
  en-full: (
    fig: "Figure",
    tab: "Table",
    eq: "Equation",
    citation: "References",
  ),
)

/// ラベル辞書を取得する
/// - supplement-lang: ラベルの言語コード
#let _get-labels(supplement-lang) = {
  _supplement-labels.at(supplement-lang, default: _supplement-labels.ja)
}
