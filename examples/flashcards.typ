#set page(margin: 1cm)

#{
  let file = include "example_for_flashcards.typ"
  hide(block(height: 0pt, clip: true, file))
}

#context grid(
  columns: (1fr, 1fr),
  stroke: (dash: "dashed"),
  inset: 5mm,
  ..query(<great-theorems::Theorem>).map(x => (x.value.fmt-all)(x.location()))
)
