// common.typ
// 外部パッケージ管理および多言語ラベル定義モジュール

// --- 外部パッケージ ---
// physica: 物理学の記号・表記（微分、ブラケット記法など）
#import "@preview/physica:0.9.8": *

// unify: 数値・単位の統一フォーマット
#import "@preview/unify:0.8.1": num, qty, unit

// cetz: CeTZ ベクター図形描画ライブラリ
#import "@preview/cetz:0.5.3": canvas, draw, matrix, vector

// showybox: カスタマイズ可能なボックス
#import "@preview/showybox:2.0.4": showybox

// whalogen: 化学式表記
#import "@preview/whalogen:0.3.0": ce

// --- 言語・キャプションラベル定義 ---
// 図・表・数式・参考文献・目次・付録などのローカライズラベル
#let supplement-labels = (
  ja: (
    fig: "図",
    tab: "表",
    eq: "式",
    citation: "参考文献",
    toc: "目次",
    lof: "図目次",
    lot: "表目次",
    abstract: "概要",
    appendix: "付録",
  ),
  en: (
    fig: "Fig.",
    tab: "Table",
    eq: "Eq.",
    citation: "References",
    toc: "Table of Contents",
    lof: "List of Figures",
    lot: "List of Tables",
    abstract: "Abstract",
    appendix: "Appendix",
  ),
  en-full: (
    fig: "Figure",
    tab: "Table",
    eq: "Equation",
    citation: "References",
    toc: "Table of Contents",
    lof: "List of Figures",
    lot: "List of Tables",
    abstract: "Abstract",
    appendix: "Appendix",
  ),
)
