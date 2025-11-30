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

#let create_validators(validators_num) = {
  let validators = ()
  for i in range(0, validators_num) {
    validators.push(node((10, i), "Validator " + str(i + 1), layer: 1))
  }
  return validators
}

#let create_rounds(validators_num, rounds_num) = {
  let rounds = ()
  rounds.push(node((10,validators_num), "Round"))
  for i in range(1, rounds_num+1) {
    rounds.push(node((10 + i * 10,validators_num), str(i)))
  }
  return rounds
}


#let create_timelines(validators_num, rounds) = {
  let timelines = ()
  for i in range(0, validators_num) {
    timelines.push(edge((10,i), ((rounds +2) *10,i), "->"))
  }
  return timelines
}

#let create_nodes_for_each_round(nodes_per_rounds) = {
  let nodes = ()
  for (i, nodes_per_round) in nodes_per_rounds.enumerate() {
    for j in range(0, nodes_per_round){
      nodes.push(node((20 + i * 10,j), "v", stroke: blue, fill: blue.lighten(70%), shape: rect))
    }
  }
  return nodes
}

#let create_uniform_edges(num_vertex_from, edges_per_origin_vertes, map_to_vertex_num, from_x, to_x) = {
  let e = ()
  for i in range(0,num_vertex_from){
    for j in range(0,edges_per_origin_vertes){
      e.push(edge((from_x,i), (to_x,calc.rem((i+j),map_to_vertex_num)), "->", stroke: red))
    }
  }
  return e
}


#let v1 = ()
#for i in range(0,2){
  v1.push(node((20 + i * 10,0), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect))
}

#let v234 = ()
#for i in range(1,4){
  for j in range(0,4){
    let n = node((20 + j * 10,i), $v$, stroke: blue, fill: blue.lighten(70%), shape: rect)
    v234.push(n)
  }
}

#align(center)[#diagram(
  spacing: (4pt, 30pt),
  ..create_validators(4),
  ..create_timelines(4,4),
  ..create_nodes_for_each_round((4,4,3,3)),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
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
  ..create_validators(4),
  ..create_rounds(4,8),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,4,4,3,3,3,3)),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(4,3,4,40,30),
  ..create_uniform_edges(4,3,4,50,40),
  ..create_uniform_edges(3,3,4,60,50),
  ..create_uniform_edges(3,3,3,70,60),
  ..create_uniform_edges(3,3,3,80,70),
  ..create_uniform_edges(3,3,3,90,80),
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
