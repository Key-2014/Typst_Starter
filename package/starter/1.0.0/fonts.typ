// fonts.typ
// フォント設定モジュール
//
// Harano Aji フォントを優先し、
// インストールされていない場合は標準日本語フォントにフォールバックする。

// --- レポート用フォントファミリー ---
// 明朝体ベース（本文向き）

/// レポート用本文フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _report-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern", "Harano Aji Mincho", "IPAex明朝", "MS Mincho", "New Computer Modern Math")
  } else {
    ("New Computer Modern", "New Computer Modern Math")
  }
}

/// レポート用数式フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _report-math-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho", "IPAex明朝")
  } else {
    ("New Computer Modern Math", "New Computer Modern")
  }
}

// --- スライド用フォントファミリー ---
// ゴシック体ベース（プレゼン向き）

/// スライド用本文フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _slide-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern", "Harano Aji Gothic", "IPAexゴシック", "MS Gothic", "New Computer Modern Math")
  } else {
    ("New Computer Modern", "New Computer Modern Math")
  }
}

/// スライド用数式フォントファミリーを返す
/// - lang: 言語コード ("ja" or "en")
#let _slide-math-font-family(lang) = {
  if lang == "ja" {
    ("New Computer Modern Math", "New Computer Modern", "Harano Aji Gothic", "IPAexゴシック")
  } else {
    ("New Computer Modern Math", "New Computer Modern")
  }
}
