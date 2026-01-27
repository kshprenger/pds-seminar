#import "@preview/polylux:0.4.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let progress = {
  place(
    bottom + right,
    dx: -0.01em,
    dy: -0.01em,
    [#toolbox.slide-number / #toolbox.last-slide-number]
  )
}

#set page(paper: "presentation-16-9")
#set text(size: 25pt)


// Use #slide to create a slide and style it using your favourite Typst functions
#slide[
  #set align(horizon)
  = Algorand: Scaling Byzantine Agreements for Cryptocurrencies

  Yossi Gilad, Rotem Hemo, Silvio Micali, Georgios Vlachos, Nickolai Zeldovich
  MIT CSAIL

  SOSP'17
]

#slide[
  == Context Introduction

  - Cryptographic currencies
  - Avoiding centralized authorities
  - Trade-off between latency and confidence

  #progress
]

#slide[
  == Nakamoto consensus & Proof of Work

  #align(center + horizon)[
    #diagram(
      node((0,0), [$ B_0 $], shape: rect, width: 3em, height: 2em),
      edge("->"),
      node((1,0), [$ B_1 $], shape: rect, width: 3em, height: 2em),
      edge("->"),
      node((2,0), [$ B_2 $], shape: rect, width: 3em, height: 2em),

      edge((2,0), (3,0), "->"),
      node((3,0), [$ B_3 $], shape: rect, width: 3em, height: 2em),
      edge((3,0), (4,0), "->"),
      node((4,0), [$ B_4 $], shape: rect, width: 3em, height: 2em),


      edge((2,0), (3,1), "->"),
      node((3,1), [$ B'_3 $], shape: rect, width: 3em, height: 2em),
      edge((3,1), (4,1), "->"),
      node((4,1), [$ B'_4 $], shape: rect, width: 3em, height: 2em),
    )
  ]
  #progress
]

#slide[
  == Nakamoto consensus & Proof of Work

  #align(center + horizon)[
    #diagram(
      node((0,0), [$ B_0 $], shape: rect, width: 3em, height: 2em),
      edge("->"),
      node((1,0), [$ B_1 $], shape: rect, width: 3em, height: 2em),
      edge("->"),
      node((2,0), [$ B_2 $], shape: rect, width: 3em, height: 2em),

      edge((2,0), (3,0), "->"),
      node((3,0), [$ B_3 $], shape: rect, width: 3em, height: 2em),
      edge((3,0), (4,0), "->"),
      node((4,0), [$ B_4 $], shape: rect, width: 3em, height: 2em),





      edge((2,0), (3,1), "->"),
      node((3,1), [$ B'_3 $], shape: rect, width: 3em, height: 2em),
      edge((3,1), (4,1), "->"),
      node((4,1), [$ B'_4 $], shape: rect, width: 3em, height: 2em),
      edge((4,1), (5,1), "->"),
      node((5,1), [$ B'_5 $], shape: rect, width: 3em, height: 2em),
    )
  ]
  #progress
]

#slide[
  == Nakamoto consensus & Proof of Work

  - No confident commit
  - Possible forks
  - Latency problem
  - Scalabillity
]


#slide[
  == BFT Consensus

  - Predefined set of servers
  - Denial of service attack
  - All to All communication
  - Scalabillity
]

#slide[
  == Algorand

  - New cryptocurrency
  - Confiramttion in order of minute
  - Scallable (No all to all communication)
]


#slide[
  == Algorand: Network structure

  - Dynamic size
  - Confiramttion in order of minute
  - Scallable (No all to all communication)
]


#slide[
  == Algorand: Key components

]

#slide[
  == Algorand: Sortition

]

#slide[
  == Algorand: BA\*

]

#slide[
  == Algorand: Evaluation

]
