// fonts.typ
// フォント設定モジュール
//
// Harano Aji フォントを優先し、
// インストールされていない場合は Typst 標準の日本語フォールバック機構を利用する。

// --- レポート・論文用フォントファミリー（明朝体ベース） ---

/// レポート・論文用本文フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _report-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math")
  } else {
    ("New Computer Modern", "New Computer Modern Math")
  }
}

/// レポート・論文用数式フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _report-math-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho")
  } else {
    ("New Computer Modern Math", "New Computer Modern")
  }
}

// --- スライド用フォントファミリー（ゴシック体ベース） ---

/// スライド用本文フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _slide-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern", "Harano Aji Gothic", "New Computer Modern Math")
  } else {
    ("New Computer Modern", "New Computer Modern Math")
  }
}

/// スライド用数式フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _slide-math-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern Math", "New Computer Modern", "Harano Aji Gothic")
  } else {
    ("New Computer Modern Math", "New Computer Modern")
  }
}
