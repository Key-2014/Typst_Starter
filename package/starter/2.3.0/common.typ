// common.typ
// Shared packages and internationalization labels

// --- External Packages ---
#import "@preview/physica:0.9.8": *
#import "@preview/unify:0.8.1": num, qty, unit
#import "@preview/cetz:0.5.3": canvas, draw, matrix, vector
#import "@preview/showybox:2.0.4": showybox
#import "@preview/whalogen:0.3.0": ce

// --- Language & Caption Mappings ---
// Defines localized labels for figures, tables, equations, and bibliography titles.
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
