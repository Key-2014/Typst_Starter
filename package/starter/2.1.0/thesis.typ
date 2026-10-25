// thesis.typ
// Dedicated Academic Thesis Template (Bachelor / Master / Ph.D.)
// Fully compatible with Typst 0.15.1 (pure context & here based)

#import "common.typ": *
#import "utils.typ": *

// --- Internal States ---
#let in-appendix = state("thesis-in-appendix", false)
#let show-running-header = state("thesis-show-running-header", false)

// --- Switch to Appendix Mode ---
// Call this function before appendix chapters to switch numbering to Appendix A, A.1, Eq. (A.1), Fig. A.1, etc.
#let start-appendix() = {
  in-appendix.update(true)
  counter(heading).update(0)
  counter(math.equation).update(0)
  counter(figure.where(kind: image)).update(0)
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: raw)).update(0)
}

// --- Main Thesis Setup Rule ---
#let thesis(
  title: "",
  author: "",
  lang: "ja",
  supplement-lang: "ja",
  paper: "a4",
  // Binding mode: "digital" (electronic submission), "oneside" (single-sided print), or "twoside" (double-sided print)
  binding: "digital",
  // Explicit margin override (set to auto to automatically resolve margins from binding mode)
  margin: auto,
  body,
) = {
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)

  // Resolve page margins based on the binding mode
  let resolved-margin = if margin != auto {
    margin
  } else if binding == "digital" {
    // Digital mode: Symmetric 25mm margins optimized for screen reading (160mm text width)
    (top: 30mm, bottom: 25mm, left: 25mm, right: 25mm)
  } else if binding == "oneside" {
    // One-sided print mode: Extra gutter (+5mm) on the left side for binding
    (top: 30mm, bottom: 25mm, left: 30mm, right: 25mm)
  } else if binding == "twoside" {
    // Two-sided print mode: Inner binding gutter (inside: 30mm, outside: 25mm)
    (top: 30mm, bottom: 25mm, inside: 30mm, outside: 25mm)
  } else {
    // Fallback: Default symmetric margins
    (top: 30mm, bottom: 25mm, left: 25mm, right: 25mm)
  }

  // --- Page & Document Settings ---
  set page(
    paper: paper,
    margin: resolved-margin,
    numbering: "1",
    header: context {
      if not show-running-header.get() {
        return none
      }
      let current-physical-page = here().page()
      let current-page = counter(page).display()
      // Query heading of the current section
      let h1-list = query(heading.where(level: 1))
      let active-h1 = none
      for h in h1-list {
        if h.location().page() <= current-physical-page {
          active-h1 = h
        }
      }

      let header-title = if active-h1 != none {
        let h-num = counter(heading).at(active-h1.location())
        let app = in-appendix.at(active-h1.location())
        let prefix = if active-h1.numbering == none {
          ""
        } else if app {
          labels.appendix + " " + numbering("A", h-num.at(0)) + " "
        } else if h-num.len() > 0 and h-num.at(0) > 0 {
          if lang == "ja" {
            "第" + str(h-num.at(0)) + "章 "
          } else {
            "Chapter " + str(h-num.at(0)) + " "
          }
        } else {
          ""
        }
        prefix + active-h1.body
      } else {
        title
      }

      set text(size: 9pt, fill: luma(90))

      // Alternate running header positions on even/odd pages for two-sided printing
      if binding == "twoside" and calc.even(current-physical-page) {
        // Even page (verso / left): Page number on the left, chapter title on the right
        grid(
          columns: (auto, 1fr),
          align(left)[#current-page], align(right)[#header-title],
        )
      } else {
        // Odd page (recto / right) or single-sided / digital: Chapter title on the left, page number on the right
        grid(
          columns: (1fr, auto),
          align(left)[#header-title], align(right)[#current-page],
        )
      }

      v(0.3em)
      line(length: 100%, stroke: 0.5pt + luma(180))
    },
    footer: context {
      // Show page number only when running header is disabled (e.g., front matter)
      if not show-running-header.get() {
        align(center)[#counter(page).display()]
      }
    },
  )

  // --- Paragraph & Typography Settings ---
  set par(
    justify: true,
    first-line-indent: (amount: 1em, all: true),
    leading: 0.85em,
  )

  let font-family = if lang == "ja" {
    ("New Computer Modern", "Harano Aji Mincho", "New Computer Modern Math")
  } else {
    ("New Computer Modern", "New Computer Modern Math")
  }

  let math-font-family = if lang == "ja" {
    ("New Computer Modern Math", "New Computer Modern", "Harano Aji Mincho")
  } else {
    ("New Computer Modern Math", "New Computer Modern")
  }

  set text(
    font: font-family,
    size: 11pt,
    lang: lang,
  )

  // --- Bibliography Settings ---
  set bibliography(
    title: labels.citation,
    style: "ieee",
  )

  // --- Math Styling ---
  show math.equation: set text(font: math-font-family)
  show math.equation.where(block: false): set math.frac(style: "horizontal")
  show math.equation.where(block: true): set block(breakable: true)

  // --- Chapter-Linked Equation Numbering: (1.1) or (A.1) ---
  set math.equation(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if app { numbering("A", ch) } else { str(ch) }
      "(" + ch-str + "." + numbering("1", ..nums) + ")"
    },
    supplement: labels.eq,
  )

  // --- Chapter-Linked Figure & Table Numbering: Fig. 1.1, Table 1.1 ---
  set figure(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let h = counter(heading).get()
      let ch = if h.len() > 0 and h.at(0) > 0 { h.at(0) } else { 1 }
      let ch-str = if app { numbering("A", ch) } else { str(ch) }
      ch-str + "." + numbering("1", ..nums)
    },
    supplement: labels.fig,
  )
  show figure.where(kind: table): set figure(supplement: labels.tab)
  show figure.where(kind: table): set figure.caption(position: top)

  // --- Heading Numbering & Chapter Break ---
  set heading(
    numbering: (..nums) => {
      let app = in-appendix.get()
      let n = nums.pos()
      if app {
        if n.len() == 1 {
          labels.appendix + " " + numbering("A", n.at(0))
        } else {
          numbering("A", n.at(0)) + "." + n.slice(1).map(str).join(".")
        }
      } else {
        if n.len() == 1 {
          if lang == "ja" {
            "第" + str(n.at(0)) + "章"
          } else {
            "Chapter " + str(n.at(0))
          }
        } else {
          n.map(str).join(".")
        }
      }
    },
  )

  show heading.where(level: 1): set heading(supplement: none)

  // Reset equation and figure counters at each level-1 heading (Chapter)
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(figure.where(kind: raw)).update(0)

    pagebreak(weak: true)
    v(2em)
    {
      show math.equation: math.bold
      text(18pt, weight: "bold")[#it]
    }
    v(1.5em)
  }

  show heading.where(level: 2): it => {
    v(1.2em)
    {
      show math.equation: math.bold
      text(14pt, weight: "bold")[#it]
    }
    v(0.8em)
  }

  show heading.where(level: 3): it => {
    v(1em)
    {
      show math.equation: math.bold
      text(12pt, weight: "bold")[#it]
    }
    v(0.6em)
  }

  body
}

// --- Layout Component: Thesis Cover Page ---
#let thesis-cover(
  academic-year: "",
  thesis-type: auto,
  title: "",
  subtitle: "",
  affiliation: "",
  student-id: "",
  author: "",
  supervisor: "",
  date: "",
  lang: "ja",
) = {
  let resolved-thesis-type = if thesis-type == auto {
    if lang == "ja" { "卒業論文" } else { "Bachelor's Thesis" }
  } else {
    thesis-type
  }

  set page(
    margin: (top: 35mm, bottom: 35mm, left: 30mm, right: 30mm),
    header: none,
    footer: none,
  )

  set par(first-line-indent: 0pt, leading: 1em)

  align(center)[
    #if academic-year != "" or resolved-thesis-type != "" [
      #text(14pt, weight: "regular")[
        #if academic-year != "" [#academic-year #if lang == "ja" [年度] else [Academic Year]]
        #h(0.8em)
        #resolved-thesis-type
      ]
    ]

    #v(1fr)

    #block(width: 90%)[
      #set par(leading: 0.7em)
      #text(20pt, weight: "bold")[#title]
      #if subtitle != "" [
        #v(0.8em)
        #text(14pt, weight: "regular")[--- #subtitle ---]
      ]
    ]

    #v(1.8fr)

    #if affiliation != "" [
      #text(13pt)[#affiliation]
      #v(2.5em)
    ]

    #text(13pt)[
      #grid(
        columns: (auto, auto),
        column-gutter: 1.5em,
        row-gutter: 1.2em,
        align: (right + horizon, left + horizon),
        ..if student-id != "" {
          (
            if lang == "ja" [学生番号] else [Student ID],
            [#student-id],
          )
        } else { () },
        if lang == "ja" [氏  名] else [Author],
        [#author],
        ..if supervisor != "" {
          (
            if lang == "ja" [指導教員] else [Supervisor],
            [#supervisor],
          )
        } else { () },
      )
    ]

    #v(3em)

    #if date != "" [
      #text(12pt)[#date]
    ]
  ]
  pagebreak()
  counter(page).update(1)
}

// --- Layout Component: Abstract ---
#let thesis-abstract(
  lang: "ja",
  body,
) = {
  let labels = supplement-labels.at(lang, default: supplement-labels.ja)
  set page(numbering: "i")

  align(center)[
    #text(16pt, weight: "bold")[#labels.abstract]
    #v(1.5em)
  ]

  block(width: 92%, align(left)[
    #set par(first-line-indent: (amount: 1em, all: true))
    #body
  ])
  pagebreak()
}

// --- Layout Component: Table of Contents & Start of Body ---
#let thesis-toc(
  lang: "ja",
  depth: 3,
  include-figures: false,
  include-tables: false,
) = {
  let labels = supplement-labels.at(lang, default: supplement-labels.ja)

  // Front matter uses Roman numerals
  set page(numbering: "i")

  align(center)[#text(16pt, weight: "bold")[#labels.toc]]
  v(1.2em)
  outline(title: none, indent: auto, depth: depth)

  if include-figures {
    pagebreak()
    align(center)[#text(16pt, weight: "bold")[#labels.lof]]
    v(1.2em)
    outline(
      title: none,
      target: figure.where(kind: image),
    )
  }

  if include-tables {
    pagebreak()
    align(center)[#text(16pt, weight: "bold")[#labels.lot]]
    v(1.2em)
    outline(
      title: none,
      target: figure.where(kind: table),
    )
  }

  pagebreak()
  // Switch to body pages: Arabic numerals and running headers enabled
  show-running-header.update(true)
  counter(page).update(1)
}
