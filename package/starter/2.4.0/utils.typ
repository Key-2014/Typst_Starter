// utils.typ

// --- Packages ---
#import "@preview/unify:0.8.1": num, qty, unit

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

// Normalize common unit aliases (e.g., degC, °C, ℃ -> dC, degF -> dF)
#let normalize-unit(s) = {
  s.replace("℃", "dC")
   .replace("°C", "dC")
   .replace("℉", "dF")
   .replace("°F", "dF")
   .replace(regex("(?i)\bdeg(?:ree)?\s*c\b"), "dC")
   .replace(regex("(?i)\bdeg(?:ree)?\s*f\b"), "dF")
}

// Format unit with support for dot notation (e.g., "MeV dot s", "kg*m/s", "N·m")
#let format-unit(unit-str) = {
  let parts = unit-str.split(regex("\s*(?:\bdot\b|[·⋅*])\s*")).filter(p => p.trim() != "")
  if parts.len() > 1 {
    let formatted-parts = parts.map(p => unit(p.trim()))
    $ #formatted-parts.intersperse(math.dot).join() $
  } else if parts.len() == 1 {
    unit(parts.at(0).trim())
  } else {
    math.dot
  }
}

// Unit formatter
#let u(unit-str, b: false) = {
  let trimmed = unit-str.trim()
  let has-brackets = b
  let clean-str = trimmed
  if clean-str.starts-with("[") and clean-str.ends-with("]") {
    has-brackets = true
    clean-str = clean-str.slice(1, -1).trim()
  }

  clean-str = normalize-unit(clean-str)

  let m = clean-str.match(regex("^([+-]?\\d+(?:\\.\\d+)?(?:[eE][+-]?\\d+)?)\\s+(.+)$"))
  let has-dot = clean-str.match(regex("\bdot\b|[·⋅*]")) != none

  if m != none {
    // When both a numerical value and a unit are provided (e.g., "9.81 m/s^2", "100 MeV dot s")
    let num-part = m.captures.at(0)
    let unit-part = m.captures.at(1)
    let content = if has-dot {
      let u-body = format-unit(unit-part)
      $ #num(num-part) #h(0.16667em) #u-body $
    } else {
      qty(num-part, unit-part)
    }
    if has-brackets {
      $[#content]$
    } else {
      content
    }
  } else {
    // Parse and format complex units using unit from the unify package and support dot notation
    let body = format-unit(clean-str)
    if has-brackets {
      $[#body]$
    } else {
      body
    }
  }
}

// Manually tag a specific equation without affecting the global equation counter
#let eqtag(content, tag) = {
  math.equation(content, block: true, numbering: _ => "(" + tag + ")")
}

// Suppress first-line indentation for the current paragraph
#let noindent = context {
  let indent = par.first-line-indent
  if type(indent) == dictionary {
    if indent.at("amount", default: 0pt) != 0pt {
      h(-indent.amount)
    }
  } else if type(indent) == length and indent != 0pt {
    h(-indent)
  }
}

// --- Internal Helpers for Block Equation Continuation Indentation ---
#let _seq-func = [].func()
#let _styled-func = [#set text(fill: black)].func()
#let _counter-update-func = counter(heading).update(0).func()
#let _state-update-func = state("_noop", none).update(none).func()

#let _transparent-funcs = (
  metadata,
  _counter-update-func,
  _state-update-func,
)

#let _block-or-break-funcs = (
  parbreak,
  linebreak,
  pagebreak,
  colbreak,
  heading,
  figure,
  block,
  rect,
  square,
  ellipse,
  circle,
  polygon,
  curve,
  line,
  path,
  table,
  grid,
  stack,
  columns,
  list,
  list.item,
  enum,
  enum.item,
  terms,
  terms.item,
  v,
  align,
  pad,
  place,
  move,
  scale,
  rotate,
  skew,
  hide,
  bibliography,
  outline,
  par,
)

#let _eq-continuation-noindent = context {
  let indent = par.first-line-indent
  if type(indent) == dictionary and indent.at("all", default: false) and indent.at("amount", default: 0pt) != 0pt {
    h(-indent.amount)
  }
}

#let _walk-eq-indent(node, after-eq: false) = {
  let f = node.func()
  if f == _seq-func {
    let result = ()
    let state-after = after-eq
    for child in node.children {
      let (new-child, next-after) = _walk-eq-indent(child, after-eq: state-after)
      result.push(new-child)
      state-after = next-after
    }
    (result.join(), state-after)
  } else if f == _styled-func {
    let (new-child, next-after) = _walk-eq-indent(node.child, after-eq: after-eq)
    (_styled-func(new-child, node.styles), next-after)
  } else if f == math.equation and node.block {
    (node, true)
  } else if after-eq {
    if node == [ ] or f in _transparent-funcs {
      (node, true)
    } else if f in _block-or-break-funcs or (f == raw and node.block) {
      (node, false)
    } else {
      (_eq-continuation-noindent + node, false)
    }
  } else {
    (node, false)
  }
}

// Automatically suppress first-line indentation on lines immediately following a block equation
// when no blank line (parbreak) separates the equation and the continuation text.
#let suppress-eq-indent(body) = {
  let (transformed, _) = _walk-eq-indent(body, after-eq: false)
  transformed
}

