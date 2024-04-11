#import "@preview/fletcher:0.3.0" as fletcher: node, edge

#let main(
  title: none,
  class: none,
  subtitle: none,
  doc,
) = {
  set page(
    header: align(center, class),
    fill: luma(30),
    paper: "us-letter",
    numbering: "1",
  )

  set text(
    font: "Roboto",
    size: 14pt,
    fill: luma(180),
  )

  show raw: set text(font: "JetBrains Mono")

  set heading(numbering: "1.")

  set table(stroke: luma(230))

  set rect(
    width: 100%,
    height: 20pt,
    stroke: white,
  )

  set circle(
    stroke: white,
  )

  set box(
    inset: 5pt
  )

  let edge = edge.with(
    paint: white,
    label-side: left,
    crossing-fill: luma(30),
  )

  outline()
  pagebreak()

  set align(center)
  text(24pt, strong(title))
  parbreak()
  text(18pt, emph(subtitle))
  set align(left)

  doc
}

#let timing_setup(elements, height) = {

  let edge = edge.with(
    paint: white,
    label-side: left,
    crossing-fill: luma(30),
  )

  let nodes = ()
  let edges = ()
  let i = 0
  for element in elements {
    nodes.push(node((i, 0), element))
    edges.push(edge((i, 0), (i, height)))
    i += 1
  }
  return (..nodes, ..edges)
}

#let timing_route(
    start_y, start_x, len, sep: 0.5, height: 0.5, label: [], paint: white
  ) = {

  let edge = edge.with(
    paint: white,
    label-side: left,
    crossing-fill: luma(30),
  )

  let line = ()
  for j in range(int(height * 10)) {
    for i in range(len) {
      let l = []
      if (j == height * 10 - 1) {
        l = label
      }
      line.push(edge(
        (i + start_x, start_y + i * sep + j * 0.1),
        (i + 1 + start_x, start_y + i * sep + sep + j * 0.1),
        l, paint: paint))
    }
  }
  return line
}
