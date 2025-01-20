#set page(margin: 1cm)

#{
  let file = include "example_for_flashcards.typ"
  hide(block(height: 0pt, clip: true, file))
}

= Flashcards
== Testing only the contents of the theorems
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Theorem>).map(x => x.value.body)
)

== Testing only the numbering of the theorems
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Theorem>).map(x => (x.value.number-fct)(x.location()))
)

== Testing similarly only the headers of the theorems
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Theorem>).map(x => (x.value.fmt-header)(x.location()))
)

== Testing with the complete blocks of the theorems
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Theorem>).map(x => (x.value.fmt-all)(x.location()))
)

#import "../lib.typ": *
#show: great-theorems-init

== Testing with proof
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Proof>).map(x => x.value.fmt-all)
)

== Testing with proof combined with its theorem
#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Proof>).map(x => {
    if x.value.of == none {
      (query(selector(<great-theorems::Theorem>).or(<great-theorems::Lemma>).before(x.location())).last().value.fmt-all)(x.location())
    } else {
      query(x.value.of.target).first()
    }
    line(length: 100%)
    x.value.fmt-body
  })
)