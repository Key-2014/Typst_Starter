// lib.typ
// Typst Starter 2.1.0 公開 API エントリーポイント
//
// 利用者は以下のように import する:
//   #import "@local/starter:2.1.0": *
//
// 提供されるテンプレート:
// - report() / project() + report-header(): 一般レポート・実験レポート
// - thesis() + thesis-cover() / thesis-abstract() / thesis-toc() / start-appendix(): 学術論文・学位論文
// - slide() / slides(): プレゼンテーションスライド (Touying university theme)

// --- 外部パッケージ & 多言語ラベル ---
#import "common.typ": *

// --- ユーティリティ関数 ---
#import "utils.typ": bk, qed, rhs, lhs, combination, permutation, hcombination, crect, frect, ans, u, eqtag

// --- レポートテンプレート ---
#import "report.typ": report, project, report-header

// --- 論文テンプレート ---
#import "thesis.typ": thesis, thesis-cover, thesis-abstract, thesis-toc, start-appendix

// --- スライドテンプレート (Touying & Theorion 含む) ---
#import "slide.typ": *
