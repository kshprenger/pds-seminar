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
#set text(size: 26pt)


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

  #align(horizon)[
  - Cryptographic currencies
  - Avoiding centralized authorities
  - Trade-off between latency and confidence
  - Double spending problem
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

  #progress
]


#slide[
  == Byzantine Consensus

  - Predefined set of servers
  - Denial of service attack
  - All to All communication
    - Bad Scalabillity

  #progress
]

#slide[
  == Example: PBFT

 #image("image/pbft.png", width: 95%)

 #progress
]

#slide[
  == Algorand

  - New cryptocurrency
  - Confirmation in order of minute
  - Scallable (No all to all communication)

  #progress
]


#slide[
  == Algorand: Network structure

  - Dynamic size network
  - Scallable (No all to all communication)
  - No predefined set of committee

  #progress
]


#slide[
  == Algorand: BA\*

  - Proof of Stake
    - Fraction of the money held by honest users is at least a constant greater than 2/3.
  - Confirmation in order of minute
  - No predefined set of committee

#progress
]



#slide[
  == Algorand: Key components
  1. Gossip Network
  2. Cryptographic sortition (for choosing small committee)
  3. BA\*
  #progress
]

#slide[
  == Algorand: Gossip
  #align(center)[
  #image("image/gossip.png", width: 70%)
  ]
  #progress
]

#slide[
  == Algorand: Block Proposal
  #align(center)[

  #image("image/sort.png", width: 70%)]
  #progress
]

#slide[
  == Algorand: Sortition
  #align(center)[

  #image("image/sort_scary.png", width: 100%)]
  #progress
]

#slide[
  == Algorand: Sortition Verification
  #align(center)[

  #image("image/sort_verify_scary.png", width: 100%)]
  #progress
]

#slide[
  == Algorand: BA\*
  #align(center)[

  #image("image/ba*.png", width: 90%)]
  #progress
]

#slide[
#align(center)[

  #image("image/latency.png", width: 75%)]
  #progress
]

#slide[
#align(center)[

  #image("image/block.png", width: 75%)]
  #progress
]

#slide[
#align(center)[

  #image("image/mali.png", width: 80%)]
  #progress
]
