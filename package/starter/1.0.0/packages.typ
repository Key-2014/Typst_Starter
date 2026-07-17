// packages.typ
// 外部パッケージ管理モジュール
//
// Starter 内部で利用する Typst Universe のパッケージを一元管理する。
// 利用者はこのファイルを直接 import しない。

// --- レポート・ドキュメント用パッケージ ---

// physica: 物理学の記号・表記（微分、ブラケット記法など）
#import "@preview/physica:0.9.8": *

// unify: 数値・単位の統一フォーマット
#import "@preview/unify:0.8.1": num, qty

// cetz: CeTZ 図形描画ライブラリ
#import "@preview/cetz:0.5.2": canvas, draw, matrix, vector

// showybox: カスタマイズ可能なボックス
#import "@preview/showybox:2.0.4": showybox

// whalogen: 化学式表記
#import "@preview/whalogen:0.3.0": ce

// --- スライド用パッケージ ---

// touying: スライド作成フレームワーク
#import "@preview/touying:0.7.4": *

// touying テーマ
#import themes.university: *

// fletcher: フローチャート・ダイアグラム
#import "@preview/fletcher:0.5.8" as fletcher
#import fletcher: edge, node

// numbly: 柔軟なナンバリング
#import "@preview/numbly:0.1.0": numbly

// theorion: 定理環境
#import "@preview/theorion:0.6.0": *
