
// #import "@preview/great-theorems:0.1.1": *
#import "../lib.typ": *
#import "@preview/rich-counters:0.2.1": *

#set heading(numbering: "1.1")
#show: great-theorems-init

#show link: text.with(fill: blue)

#let mathcounter = rich-counter(
  identifier: "mathblocks",
  inherited_levels: 1,
)

#let theorem = mathblock(
  blocktitle: "Theorem",
  supplement: "Thm.",
  counter: mathcounter,
  introspectable: true,
)

#let lemma = mathblock(
  blocktitle: "Lemma",
  counter: mathcounter,
  introspectable: true,
)

#let remark = mathblock(
  blocktitle: "Remark",
  prefix: [_Remark._],
  inset: 5pt,
  fill: lime,
  radius: 5pt,
)

#let proof = proofblock(
  introspectable: true
)

= Some Heading

#theorem[
  This is some theorem.
] <firstthm>

#theorem(number: "A")[
  This is a theorem with a custom number.
] <mythm>

#lemma[
  This is a lemma. Maybe it's used to prove @mythm.
]

#proof[
  This is a proof.
]

= Another Heading

#theorem(title: "some title")[
  This is a theorem with a title. It is similar to @firstthm
] <thm2>

#proof(of: <thm2>)[
  This is a proof of the theorem which has a title.
]

#remark[
  This is a remark.
  The remark block has some custom styling applied.
]
