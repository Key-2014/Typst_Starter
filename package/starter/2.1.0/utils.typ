// utils.typ

// --- Packages ---
#import "@preview/unify:0.8.1": qty

// --- Utils ---
#let bk = h(1em)
#let qed = h(1fr) + $qed$
#let rhs = [(右辺)]
#let lhs = [(左辺)]

// --- Math Notations ---
#let combination(n, r) = math.attach(math.upright("C"), bl: n, br: r)
#let permutation(n, r) = math.attach(math.upright("P"), bl: n, br: r)
#let hcombination(n, r) = math.attach(math.upright("H"), bl: n, br: r)

// --- Boxes ---
// Centered rectangle
#let crect(body) = align(center, block(
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body)
))

// Full-width rectangle
#let frect(body) = block(
  width: 100%,
  stroke: 1pt,
  inset: 10pt,
  radius: 4pt,
  above: 1.2em,
  below: 1.2em,
  align(left, body)
)

// Answer box
#let ans(body) = box(
  stroke: 1pt,
  inset: (x: 5pt, y: 5pt),
  outset: (y: 3pt),
  radius: 2pt,
  baseline: 20%,
  if type(body) == str { body } else { $#body$ }
)

// Unit formatter
#let u(unit-str, b: false) = {
  // Normalize '*' to space so expressions like "kg*m/s^2" are parsed by unify
  let normalized = unit-str.replace("*", " ").trim()
  let m = normalized.match(regex("^([+-]?\\d+(?:\\.\\d+)?(?:[eE][+-]?\\d+)?)\\s+(.+)$"))

  if m != none and not b {
    // When both a numerical value and a unit are provided (e.g., "9.81 m/s^2")
    let num-part = m.captures.at(0)
    let unit-part = m.captures.at(1)
    qty(num-part, unit-part)
  } else {
    // Parse and format complex units using qty from the unify package
    // Leave the first argument (amount) empty to extract only the unit part
    let body = qty("", normalized)

    // 2. Handle brackets [ ]
    let content = if b { $[#body]$ } else { body }

    // 3. Output with a thin space (1/6 em)
    $#h(0.16667em) #content$
  }
}

// Manually tag a specific equation without affecting the global equation counter
#let eqtag(content, tag) = {
  math.equation(content, block: true, numbering: _ => "(" + tag + ")")
}
