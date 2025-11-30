#import "@preview/diatypst:0.8.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#set text(font: "Terminus (TTF)",size: 16pt)
#show: slides.with(
  title: "Shoal: Improving DAG-BFT Latency and Robustness",
  subtitle: "FC'24",
  authors: ("Alexander Spiegelman, Rati Gelashvili, Balaji Arun, Zekun Li. Aptos"),
  theme: "full",
  ratio: 16/9,
  layout: "medium",
  title-color: orange.darken(20%),
  toc: true,
)

= Context: DAG-based BFT Consensus

== BFT Consensus
- N >= 3f+1 validators in total
- At most f validators are faulty


Global agreement on an infinitely growing sequence of some values.

== DAG application
/ *Idea*: Separate the network communication layer from the consensus logic.

- Each message contains a set of transactions, and a set of references to previous messages.
- Together, all the messages form a DAG that keeps growing – a message is a vertex and its references are edges.

== DAG Example
#align(center)[#diagram(
  spacing: (4pt, 30pt),

  node((10,0), "Validator 1", layer: 1),
  node((20,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((30,0), $v$, stroke: blue, fill: blue.lighten(70%),shape: rect),

  node((10,1), "Validator 2"),
  node((20,1), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((30,1), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((40,1), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((50,1), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),

  node((10,2), "Validator 3"),
  node((20,2), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((30,2), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((40,2), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((50,2), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),


  node((10,3), "Validator 4"),
  node((20,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((30,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((40,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((50,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),

 	edge((10,0), (60,0), "->"),
 	edge((10,1), (60,1), "->"),
 	edge((10,2), (60,2), "->"),
 	edge((10,3), (60,3), "->"),

  // Round 2 -> 1
 	edge((30,0), (20,0), "->", stroke: red),
 	edge((30,0), (20,1), "->", stroke: red),
 	edge((30,0), (20,2), "->", stroke: red),

 	edge((30,1), (20,0), "->", stroke: red),
 	edge((30,1), (20,1), "->", stroke: red),
 	edge((30,1), (20,2), "->", stroke: red),

  edge((30,2), (20,0), "->", stroke: red),
 	edge((30,2), (20,2), "->", stroke: red),
 	edge((30,2), (20,3), "->", stroke: red),

  edge((30,3), (20,1), "->", stroke: red),
 	edge((30,3), (20,2), "->", stroke: red),
 	edge((30,3), (20,3), "->", stroke: red),

  // Round 3 -> 2
  edge((40,1), (30,0), "->", stroke: red),
 	edge((40,1), (30,1), "->", stroke: red),
 	edge((40,1), (30,2), "->", stroke: red),

  edge((40,2), (30,0), "->", stroke: red),
 	edge((40,2), (30,2), "->", stroke: red),
 	edge((40,2), (30,3), "->", stroke: red),

  edge((40,3), (30,1), "->", stroke: red),
 	edge((40,3), (30,2), "->", stroke: red),
 	edge((40,3), (30,3), "->", stroke: red),

  // Round 4 -> 3
  edge((50,1), (40,1), "->", stroke: red),
 	edge((50,1), (40,2), "->", stroke: red),
 	edge((50,1), (40,3), "->", stroke: red),

  edge((50,2), (40,1), "->", stroke: red),
 	edge((50,2), (40,2), "->", stroke: red),
 	edge((50,2), (40,3), "->", stroke: red),

  edge((50,3), (40,1), "->", stroke: red),
 	edge((50,3), (40,2), "->", stroke: red),
 	edge((50,3), (40,3), "->", stroke: red),
)
]


== Vertices dissemination

/ *Unifies abstraction*: Reliable BFT broadcast (Not all protocols)

Result:
- All honest validators eventually deliver the same vertices and all vertices by honest validators are eventually delivered.
- Causal history of any vertex in both local views is exactly the same.

== Consensus Mechanism
- Solving locally!!
- No need of any extra communication.

== Consensus Structure
- Consensus divided into rounds
- Rounds groups waves
- Each wave contains a leader

== DAG Waves example
#align(center)[#diagram(
  spacing: (2pt, 20pt),

  node((10,0), "Validator 1", layer: 1),
  node((20,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((30,0), $v$, stroke: blue, fill: blue.lighten(70%),shape: rect),
  node((40,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((50,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((60,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((70,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((80,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((90,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),


  node((10,1), "Validator 2"),
  node((20,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((30,1), $v$, stroke: blue, fill: blue.lighten(70%),shape: rect),
  node((40,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((50,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((60,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((70,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((80,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((90,1), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),

  node((10,2), "Validator 3"),
  node((20,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((30,2), $v$, stroke: blue, fill: blue.lighten(70%),shape: rect),
  node((40,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((50,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((60,2), $v$, stroke: red, fill: red.lighten(70%), shape: rect),
  node((70,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((80,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),
  node((90,2), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect),


  node((10,3), "Validator 4"),
  node((20,3), $v$, stroke: red,fill: red.lighten(70%), shape: rect),
  node((30,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((40,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),
  node((50,3), $v$, stroke: blue,fill: blue.lighten(70%), shape: rect),

  // Time lines
 	edge((10,0), (100,0), "->"),
 	edge((10,1), (100,1), "->"),
 	edge((10,2), (100,2), "->"),
 	edge((10,3), (100,3), "->"),

  node((10,4), "Round"),
  node((20,4), "1"),
  node((30,4), "2"),
  node((40,4), "3"),
  node((50,4), "4"),
  node((60,4), "5"),
  node((70,4), "6"),
  node((80,4), "7"),
  node((90,4), "8"),




  // Round 2 -> 1
 	edge((30,0), (20,0), "->", stroke: red),
 	edge((30,0), (20,1), "->", stroke: red),
 	edge((30,0), (20,2), "->", stroke: red),

 	edge((30,1), (20,0), "->", stroke: red),
 	edge((30,1), (20,1), "->", stroke: red),
 	edge((30,1), (20,2), "->", stroke: red),

  edge((30,2), (20,0), "->", stroke: red),
 	edge((30,2), (20,2), "->", stroke: red),
 	edge((30,2), (20,3), "->", stroke: red),

  edge((30,3), (20,1), "->", stroke: red),
 	edge((30,3), (20,2), "->", stroke: red),
 	edge((30,3), (20,3), "->", stroke: red),

  // Round 3 -> 2
  edge((40,0), (30,0), "->", stroke: red),
 	edge((40,0), (30,1), "->", stroke: red),
 	edge((40,0), (30,2), "->", stroke: red),

 	edge((40,1), (30,0), "->", stroke: red),
 	edge((40,1), (30,1), "->", stroke: red),
 	edge((40,1), (30,2), "->", stroke: red),

  edge((40,2), (30,0), "->", stroke: red),
 	edge((40,2), (30,2), "->", stroke: red),
 	edge((40,2), (30,3), "->", stroke: red),

  edge((40,3), (30,1), "->", stroke: red),
 	edge((40,3), (30,2), "->", stroke: red),
 	edge((40,3), (30,3), "->", stroke: red),

  // Round 4 -> 3
  edge((50,0), (40,0), "->", stroke: red),
 	edge((50,0), (40,1), "->", stroke: red),
 	edge((50,0), (40,2), "->", stroke: red),

 	edge((50,1), (40,0), "->", stroke: red),
 	edge((50,1), (40,1), "->", stroke: red),
 	edge((50,1), (40,2), "->", stroke: red),

  edge((50,2), (40,0), "->", stroke: red),
 	edge((50,2), (40,2), "->", stroke: red),
 	edge((50,2), (40,3), "->", stroke: red),

  edge((50,3), (40,1), "->", stroke: red),
 	edge((50,3), (40,2), "->", stroke: red),
 	edge((50,3), (40,3), "->", stroke: red),


  // Round 5 -> 4
  edge((60,0), (50,0), "->", stroke: red),
 	edge((60,0), (50,1), "->", stroke: red),
 	edge((60,0), (50,2), "->", stroke: red),

 	edge((60,1), (50,0), "->", stroke: red),
 	edge((60,1), (50,1), "->", stroke: red),
 	edge((60,1), (50,2), "->", stroke: red),

  edge((60,2), (50,0), "->", stroke: red),
 	edge((60,2), (50,1), "->", stroke: red),
 	edge((60,2), (50,3), "->", stroke: red),


  // Round 6 -> 5
  edge((70,0), (60,0), "->", stroke: red),
 	edge((70,0), (60,1), "->", stroke: red),
 	edge((70,0), (60,2), "->", stroke: red),

 	edge((70,1), (60,0), "->", stroke: red),
 	edge((70,1), (60,1), "->", stroke: red),
 	edge((70,1), (60,2), "->", stroke: red),

  edge((70,2), (60,0), "->", stroke: red),
 	edge((70,2), (60,1), "->", stroke: red),
 	edge((70,2), (60,2), "->", stroke: red),

  // Round 7 -> 6
  edge((80,0), (70,0), "->", stroke: red),
 	edge((80,0), (70,1), "->", stroke: red),
 	edge((80,0), (70,2), "->", stroke: red),
 	edge((80,1), (70,0), "->", stroke: red),
 	edge((80,1), (70,1), "->", stroke: red),
 	edge((80,1), (70,2), "->", stroke: red),
  edge((80,2), (70,0), "->", stroke: red),
 	edge((80,2), (70,1), "->", stroke: red),
 	edge((80,2), (70,2), "->", stroke: red),

  // Round 8 -> 7
  edge((90,0), (80,0), "->", stroke: red),
 	edge((90,0), (80,1), "->", stroke: red),
 	edge((90,0), (80,2), "->", stroke: red),
 	edge((90,1), (80,0), "->", stroke: red),
 	edge((90,1), (80,1), "->", stroke: red),
 	edge((90,1), (80,2), "->", stroke: red),
  edge((90,2), (80,0), "->", stroke: red),
 	edge((90,2), (80,1), "->", stroke: red),
 	edge((90,2), (80,2), "->", stroke: red),

  // Waves
  edge((20,4), (50,4), label: "wave 1", bend: -30deg ),
  edge((60,4), (90,4), label: "wave 2", bend: -30deg ),


)
]

= Problem

== First Slide

= Solution: Pipelining

== First Slide

= Evaluation

== First Slide
