#import "@preview/diatypst:0.8.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/zebraw:0.6.1": *

#set text(font: "Terminus (TTF)")
#show: zebraw


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
    timelines.push(edge((10,i), ((rounds +2) *10,i), "-"))
  }
  return timelines
}

#let create_nodes_for_each_round(nodes_per_rounds, leaders: ()) = {
  let nodes = ()
  for (i, nodes_per_round) in nodes_per_rounds.enumerate() {
    for j in range(0, nodes_per_round){
      let coord = (20 + i * 10, j)
      let is_special = leaders.any(special => special == coord)
      if is_special {
        nodes.push(node(coord, "v", stroke: red, fill: red.lighten(70%), shape: rect))
      } else {
        nodes.push(node(coord, "v", stroke: blue, fill: blue.lighten(70%), shape: rect))
      }
    }
  }
  return nodes
}

#let create_uniform_edges(num_vertex_from, edges_per_origin_vertes, map_to_vertex_num, from_x, to_x) = {
  let e = ()
  for i in range(0,num_vertex_from){
    for j in range(0,edges_per_origin_vertes){
      e.push(edge((from_x,i), (to_x,calc.rem((i+j),map_to_vertex_num)), "->", stroke: black))
    }
  }
  return e
}

#show: slides.with(
  title: "Shoal: Improving DAG-BFT Latency and Robustness",
  subtitle: "FC'24",
  authors: ("Alexander Spiegelman, Rati Gelashvili, Balaji Arun, Zekun Li. Aptos"),
  theme: "full",
  ratio: 16/9,
  layout: "medium",
  title-color: blue.darken(50%),
  toc: false,
  count: "number",
  footer: false,
)
#set text(size: 15pt)


#outline(depth: 1)

= Context: DAG-based BFT Consensus

== BFT Consensus
#align(horizon)[
- N = 3f+1 validators in total
- At most f validators are faulty
/ *Goal*: Global agreement on an infinitely growing sequence of some values.
]

== New way to form consensus
#align(horizon)[
  - Historically we have a bunch of protocols which were optimized in the way of reducing communication compexity.
    - Hotstuff - 3500 TPS
  - Now we have new generation of protocols
    - [160kTPS - 600kTPS]
]

== DAG purpose
#align(horizon)[

/ *Idea*: Separate the network communication layer from the consensus logic.

- Each message contains a set of transactions, and a set of references to previous messages.
- Together, all the messages form a DAG that keeps growing – a message is a vertex and its references are edges.
]
== DAG Example
#align(horizon)[

#align(center)[#diagram(
  spacing: (4pt, 30pt),
  ..create_validators(4),
  ..create_timelines(4,4),
  ..create_nodes_for_each_round((4,4,3,3)),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
)
]]


== Vertices dissemination
#align(horizon)[
/ *Common abstraction*: Reliable BFT broadcast (Narwhal based protocols)

Result:
- All honest validators eventually deliver the same vertices and all vertices by honest validators are eventually delivered.
- Causal history of any vertex in both local views is exactly the same.
- All validators eventually see the same DAG
]

== Consensus Structure
#align(horizon)[

- Interpreting DAG structure as the consensus logic
  - Outcome - local solving
  - No need of any extra communication.
- Consensus divided into rounds
- Rounds groups waves
- Each wave contains a leader
]

== DAG Waves example [DAG-Rider]
#align(horizon)[
#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,8),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,4,4,3,3,3,3), leaders: ((20,3),(60,2))),
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
]]

== Casual history
#align(horizon)[
#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,5),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,4,3,1), leaders: ((20,3),(60,0))),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(4,3,4,40,30),
  ..create_uniform_edges(3,3,4,50,40),
  ..create_uniform_edges(1,3,3,60,50),
  // Waves
  edge((20,4), (50,4), label: "wave 1", bend: -30deg ),
)
]]

== Ordering
#align(horizon)[
- Ordering happens between constructing of each wave; between leaders rounds
- Larger waves -> larger latency
]

== Bullshark
#align(horizon)[
#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,6),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,3,3,3,3), leaders: ((30,1),(50,0),(70,2))),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
  ..create_uniform_edges(3,3,3,60,50),
  ..create_uniform_edges(3,3,3,70,60),
  // Waves
  edge((20,4), (30,4), label: "wave 1", bend: -30deg ),
  edge((40,4), (50,4), label: "wave 2", bend: -30deg ),
  edge((60,4), (70,4), label: "wave 3", bend: -30deg ),

)
]]

= Problem

== Consensus committing speed
#align(horizon)[

/ *Problem*: Commit(ordering) speed is not faster than a wave constructing latency

#align(center)[
#table(
  columns: 3,
  [*Protocol*], [*Common case round latency*], [*Async round latency*],
  [DAG-Rider], [4], [E(6)],
  [Tusk], [3], [E(7)],
  [Bullshark], [2], [E(6)],
)]

- Ideally we want to commit something each round.
]
= Solution

== Common protocol structure
#align(horizon)[

1. Pre-determined leaders each k rounds
2. Order leaders. Same local ordering on honest validators
3. Order casual histories.

/ *Abstract property*: Given a Narwhal-based protocol $PP$, if all honest validators agree on the mapping from rounds to leaders before the beginning of instance $PP$, then they will agree on the first leader each of them orders during execution of $PP$.
]
== Introducing "Shoal"
#align(horizon)[

- Protocol agnostic framework
- Suitable for all Narwhal-based protocols
/ *Idea*: Combine batch of protocols instance in black-box manner.
]
== Recall Bullshark
#align(horizon)[
#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,6),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,3,3,3,3), leaders: ((30,1),(50,0),(70,2))),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
  ..create_uniform_edges(3,3,3,60,50),
  ..create_uniform_edges(3,3,3,70,60),
  // Waves
  edge((20,4), (30,4), label: "wave 1", bend: -30deg ),
  edge((40,4), (50,4), label: "wave 2", bend: -30deg ),
  edge((60,4), (70,4), label: "wave 3", bend: -30deg ),

)
]]

== Pipelining algorithm
#align(horizon)[

1: current_round $<-$ 0\
2: F: $RR -> LL$\ // deterministic rounds to leader mapping
3: while true do\
4: #h(1cm)Execute $PP$, select leaders by F, starting from \
   #h(1.9cm)current_round until the first ordered (not skipped)\
   #h(1.9cm)leader is determined.\
5: #h(1cm)let L be the first ordered leader in round r\
6: #h(1cm)order L's casual history according to $PP$\
7: #h(1cm)current_round $<-$ r+1
]
== Shoal of Bullsharks
#align(horizon)[
#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,6),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,3,3,3,3), leaders: ((20,0),(30,1),(40,0),(50,0),(60,1),(70,2))),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
  ..create_uniform_edges(3,3,3,60,50),
  ..create_uniform_edges(3,3,3,70,60),
)
]]

== Leader reputation
#align(horizon)[
- Byzantine systems are design to tolerate worst-case guarantees.
- However most common problem is slow leaders.
]

== Example of missing leader
#align(horizon)[

#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,6),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((4,4,3,3,3,3), leaders: ((30,1),(70,2))),
  node((50,3), "v", stroke: red, fill: red.lighten(90%), shape: rect),
  ..create_uniform_edges(4,3,4,30,20),
  ..create_uniform_edges(3,3,4,40,30),
  ..create_uniform_edges(3,3,3,50,40),
  ..create_uniform_edges(3,3,3,60,50),
  ..create_uniform_edges(3,3,3,70,60),
  // Waves
  edge((20,4), (30,4), label: "wave 1", bend: -30deg ),
  edge((40,4), (50,4), label: "wave 2", bend: -30deg ),
  edge((60,4), (70,4), label: "wave 3", bend: -30deg ),
)
]]

== Reputation integration
#align(horizon)[

1: current_round $<-$ 0\
2: F: $RR -> LL$\ // deterministic rounds to leader mapping
3: while true do\
4: #h(1cm)Execute $PP$, select leaders by F, starting from \
   #h(1.9cm)current_round until the first ordered (not skipped)\
   #h(1.9cm)leader is determined.\
5: #h(1cm)let L be the first ordered leader in round r\
6: #h(1cm)order L's casual history according to $PP$\
7: #h(1cm)current_round $<-$ r+1\
8: #h(1cm)#text("Update F according to L's causal story", fill: red)
]
== Leader change in action
#align(horizon)[

#align(center)[#diagram(
  spacing: (2pt, 20pt),
  ..create_validators(4),
  ..create_rounds(4,6),
  ..create_timelines(4,8),
  ..create_nodes_for_each_round((3,3,3,3,3,3), leaders: ((30,1),(50,0),(70,1))),
  node((50,3), "v", stroke: red, fill: red.lighten(90%), shape: rect),
  node((70,2), "v", stroke: red, fill: red.lighten(90%), shape: rect),
  ..create_uniform_edges(3,3,3,30,20),
  ..create_uniform_edges(3,3,3,40,30),
  ..create_uniform_edges(3,3,3,50,40),
  ..create_uniform_edges(3,3,3,60,50),
  ..create_uniform_edges(3,3,3,70,60),
  // Waves
  edge((20,4), (30,4), label: "wave 1", bend: -30deg ),
  edge((40,4), (50,4), label: "wave 2", bend: -30deg ),
  edge((60,4), (70,4), label: "wave 3", bend: -30deg ),
)
]]

= Evaluation

== Machine Setup
- Machines:
  - t2d-standard-32 type virtual machine
  - 32 vCPUs, 128GB of memory, up to 10Gbps of network bandwidth.
- Cluster:
  - Google Cloud
  - Machines spread equally across regions: us-west1, europe-west4, asia-east1.
  - Latencies: us-west1 <-> asia-east1 [118ms]; europe-west4 <-> asia-east1 [251ms]; us-west1 <-> europe-west4 [133ms]
  - Cluster size (N): 10 (f <= 3); 20 (f <= 6); 50 (f <= 16)
- Data:
  - Transactions \~270B in size
  - Maximum batch size of 5000 transactions

== Latency definition
#align(horizon)[
/ *Latency*: Time elapsed from when a vertex is created from a batch of client transactions to when it is ordered by a validator
]
== Results: No failures
#align(center)[
#image("eval_no_failures.png")
]
== Results: With failures
#align(center)[
  #image("eval_failures.png")]

== Results: Skipping leaders
#align(center)[
  #image("eval_skip.png")]
