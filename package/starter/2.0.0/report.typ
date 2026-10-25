// report.typ
// Standard document and report template

#import "common.typ": *
#import "utils.typ": *

// --- Main Template Setup (General Purpose & Reports) ---
// Configures global document rules such as margins, fonts, paragraphs, and heading spacing.
#let report(
  lang: "ja",
  supplement-lang: "ja",
  heading-numbering: none,
  equation-numbering: none,
  indent: false,
  title: "",
  author: "",
  student-id: "",
  date: none,
  body,
) = {
  // Select labels dynamically based on the language
  let labels = supplement-labels.at(supplement-lang, default: supplement-labels.ja)

  // --- Page & Document Properties ---
  set page(
    paper: "a4",
    margin: (x: 25mm, y: 30mm),
    numbering: "1",
  )

  set par(
    justify: true,
    first-line-indent: (
      amount: if indent { 1em } else { 0em },
      all: indent,
    ),
    leading: 0.8em,
  )

  // Configure fallback fonts depending on the language
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

  // --- Bibliography Configuration ---
  set bibliography(
    title: labels.citation,
    style: "ieee",
  )

  // --- Typography Rules for Math ---
  show math.equation: set text(
    font: math-font-family,
  )

  // Use horizontal style for inline fractions
  show math.equation.where(block: false): set math.frac(style: "horizontal")

  // Allow block equations to break across pages
  show math.equation.where(block: true): set block(breakable: true)

  // --- Heading Configuration ---
  set heading(
    numbering: heading-numbering,
  )

  // Add vertical spacing and bold math in headings
  show heading: it => {
    show math.equation: math.bold
    v(0.5em)
    it
    v(0.5em)
  }

  // --- Equation Numbering Logic ---
  // Reset equation counter at level-1 headings if equation-numbering is "1.1"
  show heading.where(level: 1): it => {
    if equation-numbering == "1.1" and heading-numbering != none {
      counter(math.equation).update(0)
    }
    it
  }

  // Format equation numbers (e.g., "(1)" or "(1.1)")
  let target-numbering = if equation-numbering == "1" {
    "(1)"
  } else if equation-numbering == "1.1" {
    (..nums) => {
      let h = counter(heading).at(here())
      if h.len() > 0 and h.at(0) != 0 and heading-numbering != none {
        "(" + str(h.at(0)) + "." + numbering("1", ..nums) + ")"
      } else {
        "(" + numbering("1", ..nums) + ")"
      }
    }
  } else {
    equation-numbering
  }

  set math.equation(
    numbering: target-numbering,
    supplement: labels.eq,
  )

  // --- Tables & Figures ---
  set figure(supplement: labels.fig)
  show figure.where(kind: table): set figure(supplement: labels.tab)
  show figure.where(kind: table): set figure.caption(position: top)

  // --- Layout Component: Report Header ---
  if title != "" or author != "" or student-id != "" or date != none {
    if title != "" [
      #align(center)[
        #text(17pt, weight: "bold")[#title]
        #v(1em)
      ]
    ]
    if student-id != "" or author != "" or date != none [
      #align(center)[
        #if student-id != "" [ #student-id ]
        #if student-id != "" and author != "" [ #h(2em) ]
        #if author != "" [ #author ]
        #if (student-id != "" or author != "") and date != none [ \ ]
        #if date != none [#date]
      ]
    ]
    v(2em)
  }

  // --- Main Content ---
  body
}
