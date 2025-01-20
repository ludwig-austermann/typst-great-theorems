#let mathblock(
  blocktitle: none,
  counter: none,
  numbering: "1.1",
  prefix: auto,
  titlix: title => [(#title)],
  suffix: none,
  supplement: auto,
  bodyfmt: body => body,
  introspectable: false,
  ..global-block-args,
) = {
  // check if blocktitle was provided
  if blocktitle == none {
    panic("You have created a `mathblock` without a `blocktitle`. Please provide a `blocktitle` like \"Theorem\" or \"Lemma\" or \"Proof\".")
  }

  // set the default prefix
  if prefix == auto {
    if counter == none {
      prefix = [*#blocktitle.*]
    } else {
      prefix = counter => [*#blocktitle #counter.*]
    }
  }

  // set the default supplement
  if supplement == auto {
    supplement = blocktitle
  }

  // check consistency of `counter` and `prefix`
  if counter == none and type(prefix) == function {
    panic("You have created a `mathblock` without a `counter` but with a `prefix` that accepts a counter. This is inconsistent. If you want a counter, then provide it with the `counter` argument (see documentation). If you don't want a counter, then you need to set a `prefix` that doesn't depend on a counter (see documentation).")
  } else if counter != none and type(prefix) != function {
    panic("You have created a `mathblock` with a `counter` but with a `prefix` that doesn't depend on a counter. This is inconsistent. If you don't want a counter, then remove the `counter` argument. If you want a counter, then set a prefix that depends on a counter (see documentation).")
  }

  // wrap native counter
  if counter != none and type(counter) != dictionary {
    counter = (
      step: (..args) => { counter.step(..args) },
      get: (..args) => { counter.get(..args) },
      at: (..args) => { counter.at(..args) },
      display: (..args) => { counter.display(..args) },
    )
  }

  // return the environment for the user
  if counter != none {
    return (
      title: none,
      numbering: numbering,
      prefix: prefix,
      titlix: titlix,
      suffix: suffix,
      bodyfmt: bodyfmt,
      number: auto,
      ..local-block-args,
      body,
    ) => figure(
      kind: "great-theorem-counted",
      supplement: supplement,
      outlined: false,
      // caption: context (counter.display)(numbering), // one could misuse the field to put the counter display value here
      {
        /// takes the original location of the theorem block and returns the correct number
        let number-func(loc) = number
        if number == auto {
          // step and counter
          (counter.step)()
          number = context (counter.display)(numbering)
          number-func = loc => std.numbering(numbering, ..(counter.at)(loc))
        }
        
        let fmt-header(loc) = prefix(number-func(loc)) + if title != none { titlix(title) }
        let res(loc) = block(
          width: 100%,
          ..global-block-args.named(),
          ..local-block-args.named(),
          {
            [ #metadata(number-func) <great-theorems:numberfunc> ]
            // show content,
            fmt-header(loc)
            bodyfmt(body)
            suffix
          }
        )
        
        context res(here())
        // store all information in a outside referencable object, i.e. for flashcards generation
        if introspectable [
          #metadata((
            thmkind: blocktitle,
            number-fct: number-func,
            body: body,
            prefix: prefix,
            suffix: suffix,
            fmt-header: fmt-header,
            fmt-body: bodyfmt(body),
            fmt-all: res,
          ))
          #label("great-theorems::" + blocktitle)
        ]
      }
    )
  } else {
    return (
      title: none,
      numbering: numbering,
      prefix: prefix,
      titlix: titlix,
      suffix: suffix,
      bodyfmt: bodyfmt,
      ..local-block-args,
      body,
    ) => figure(
      kind: "great-theorem-uncounted",
      supplement: supplement,
      outlined: false,
      {
        let fmt-header = prefix + if title != none { titlix(title) }
        let res = block(
          width: 100%,
          ..global-block-args.named(),
          ..local-block-args.named(),
          {
            // show content
            fmt-header
            bodyfmt(body)
            suffix
          },
        )

        res
        // store all information in a outside referencable object, i.e. for flashcards generation
        if introspectable [
          #metadata((
            thmkind: blocktitle,
            body: body,
            prefix: prefix,
            suffix: suffix,
            fmt-header: fmt-header,
            fmt-body: bodyfmt(body),
            fmt-all: res,
          ))
          #label("great-theorems::" + blocktitle)
        ]
      }
    )
  }
}

#let proofblock(
  blocktitle: "Proof",
  prefix: text(style: "oblique", [Proof.]),
  prefix-with-of: of => text(style: "oblique", [Proof of #of.]),
  suffix: [#h(1fr) $square$],
  bodyfmt: body => body,
  introspectable: false,
  ..global-block-args,
) = {
  // return the environment for the user
  return (
    of: none,
    prefix: prefix,
    prefix-with-of: prefix-with-of,
    suffix: suffix,
    bodyfmt: bodyfmt,
    ..local-block-args,
    body,
  ) => {
    if type(of) == label {
      of = ref(of)
    }

    figure(
      kind: "great-theorem-uncounted",
      supplement: blocktitle,
      outlined: false,
      {
        let fmt-header = if of != none { prefix-with-of(of) } else { prefix }
        let res = block(
          width: 100%,
          ..global-block-args.named(),
          ..local-block-args.named(),
          {
            // show content
            fmt-header
            bodyfmt(body)
            suffix
          },
        )

        res
        // store all information in a outside referencable object, i.e. for flashcards generation
        if introspectable [
          #metadata((
            proofkind: blocktitle,
            body: body,
            prefix: prefix,
            prefix-with-of: prefix-with-of,
            of: of,
            suffix: suffix,
            fmt-header: fmt-header,
            fmt-body: bodyfmt(body),
            fmt-all: res,
          ))
          #label("great-theorems::" + blocktitle)
        ]
      }
    )
  }
}

#let great-theorems-init(body) = {
  show figure.where(kind: "great-theorem-counted").or(figure.where(kind: "great-theorem-uncounted")): fig => {
    set align(start)
    set block(breakable: true)
    fig.body
  }

  show ref: it => {
    if it.element != none and it.element.func() == figure {
      if it.element.kind == "great-theorem-counted" {
        let supplement = if it.citation.supplement != none { it.citation.supplement } else { it.element.supplement }
        let data = query(selector(<great-theorems:numberfunc>).after(it.target)).first()
        let numberfunc = data.value
        link(it.target, [#supplement #numberfunc(data.location())])
      } else if it.element.kind == "great-theorem-uncounted" {
        let supplement = if it.citation.supplement != none { it.citation.supplement } else { it.element.supplement }
        link(it.target, [#supplement])
      } else {
        it
      }
    } else {
      it
    }
  }

  body
}
