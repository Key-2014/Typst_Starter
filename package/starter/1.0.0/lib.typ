// lib.typ
// Typst Starter 公開API
//
// このファイルはパッケージのエントリーポイントである。
// 利用者は以下のように import する:
//
//   #import "@local/starter:1.0.0": *
//
// 公開されるのは report() と slide() のみ。
// 内部モジュール（utils, components, theme 等）は公開しない。

// --- 公開マクロ ---

/// レポートテンプレート
///
/// 使用例:
///   #show: report.with(
///     title: "レポートタイトル",
///     author: "著者名",
///     student-id: "12345678",
///     date: datetime.today().display(),
///   )
#import "report.typ": report

/// スライドテンプレート
///
/// 使用例:
///   #show: slide.with(
///     title: [スライドタイトル],
///     author: [著者名],
///   )
#import "slide.typ": slide

// --- ユーティリティ（公開） ---
// レポート・スライドの両方で使えるユーティリティ関数
#import "utils.typ": bk, qed, rhs, lhs, combination, permutation, hcombination, crect, frect, ans, u, eqtag

// --- 外部パッケージ（re-export） ---
// 利用者が個別に import しなくても使えるようにする
#import "packages.typ": *
