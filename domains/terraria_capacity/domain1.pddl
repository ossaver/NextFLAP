;; this domain is based on a 2D-advanture video game, called Terraria. The objective of this domain is to 
;; find a plan to collect raw materials and produce intermediate products to produce a final product. In this 
;; domain, the final product is 10 beds. the complexity of this problem increased by increasing final product types 
;; and quantity. In addition, some of the problem instances include capacity constraints, which limits number of raw materials collected 
;; regardless of types. For more information about the processes in Terraria, visit Terraria Wiki website. 
;; i.e: http://terraria.gamepedia.com/Bed (process of making a bed is described in this website).

(define (domain terraria)
(:requirements :typing :durative-actions :fluents :duration-inequalities)

(:types     resources products - items
                cobweb iron_bar chain - resources
                silk bed wood - products
)

    (:predicates (available)
                (finished)
                (ready_loom)
                (ready_sawmill)
                (ready_workbench)
          )

      (:functions   (stock ?e - items)
                    
            )
(:durative-action cut_a_tree
:parameters(?a - wood)
:control (?w - number)
:duration (= ?duration 2)
:condition (and (at start (available))
                (at start (>= ?w 5))
                (at start (<= ?w 100)) ;; you can get up to 100 woods from a tree
                (at end (>= (stock ?a) 0))
                (at start (>= (stock ?a) 0))
                )
:effect (and    (at start (not (available)))
                (at start (increase (stock ?a) ?w))
                (at end (available))
))

(:durative-action find_resources
:parameters(?c - cobweb ?i - iron_bar ?ch - chain)
:control (?cob ?iron ?chain_found - number)
:duration (= ?duration 2)
:condition (and (at start (available))
                (at start (>= ?chain_found 1))
                (at start (<= ?chain_found 10))
                (at start (>= ?iron 5))
                (at start (<= ?iron 60))
                (at start (>= ?cob 10)) ;; cobweb is quite common. there is no way not finding it.
                (at start (<= ?cob 60))
                (at end (>= (stock ?c) 0))
                (at end (>= (stock ?i) 0))
                (at end (>= (stock ?ch) 0))
                )
:effect (and    (at start (not (available)))
                (at start (increase (stock ?c) ?cob))
                (at start (increase (stock ?i) ?iron))
                (at start (increase (stock ?ch) ?chain_found))
                (at end (available))
))

(:durative-action make_silk
:parameters(?s1 - silk ?cob - cobweb)
:control (?silkmade - number)
:duration (= ?duration 5)
:condition (and (at start (available))
                (at start (ready_loom))
                (at start (>= ?silkmade 5))
                (at start (<= ?silkmade 100))
                (at start (>= (stock ?cob) (* ?silkmade 7)) )
                (at end (>= (stock ?s1) 0) )
                (at end (>= (stock ?cob) 0) )
                )
:effect (and    (at start (not (available)))
                (at start (increase (stock ?s1) ?silkmade))
                (at start (decrease (stock ?cob) (* ?silkmade 7) ))
                (at end (available))
))

(:durative-action assemble_a_loom
:parameters(?w1 - wood)
:duration (= ?duration 5)
:condition (and (at start (available))
                (at start (ready_sawmill))
                (at start (>= (stock ?w1) 12) )
				(at end (>= (stock ?w1) 0) )
                )
:effect (and    (at start (not (available)))
                (at end (decrease (stock ?w1) 12))
                (at end (available))
                (at end (ready_loom))
))

(:durative-action assemble_a_sawmill
:parameters(?w1 - wood ?iron - iron_bar ?ch - chain)
:duration (= ?duration 5)
:condition (and (at start (available))
                (at start (ready_workbench))
                (at start (>= (stock ?w1) 10) ) 
                (at start (>= (stock ?iron) 2) )
                (at start (>= (stock ?ch) 1) )
                (at end (>= (stock ?w1) 0) )
                (at end (>= (stock ?iron) 0) )
                (at end (>= (stock ?ch) 0) )
                )
:effect (and    (at start (not (available)))
                (at end (decrease (stock ?w1) 10))
                (at end (decrease (stock ?iron) 2) )
                (at end (decrease (stock ?ch) 1) )
                (at end (available))
                (at end (ready_sawmill))
))

(:durative-action assemble_beds
:parameters(?w1 - wood ?s1 - silk ?b - bed)
:control (?beds - number)
:duration (= ?duration 5)
:condition (and (at start (available))
                (at end (ready_sawmill)) ; made on sawmill
                (at start (>= ?beds 3))
                (at start (<= ?beds 30))
                (at start (>= (stock ?w1) (* ?beds 15) ) ) 
                (at start (>= (stock ?s1) (* ?beds 5) ) )
                (at end (>= (stock ?w1) 0 ) ) 
                (at end (>= (stock ?s1) 0 ) )
                (at start (>= (stock ?w1) 0 ) ) 
                (at start (>= (stock ?s1) 0 ) )
				(at start (>= (stock ?b) 0 ) )
                )
:effect (and    (at start (not (available)))
                (at start (increase (stock ?b) ?beds) )
                (at start (decrease (stock ?w1) (* ?beds 15) ) )
                (at start (decrease (stock ?s1) (* ?beds 5) ) )
                (at end (available))
))

(:durative-action place_beds
:parameters (?b - bed)
:duration (<= ?duration 0.5)
:condition (and     (at start (>= (stock ?b) 5) )
                    (at start (available))
                    (at end (>= (stock ?b) 0) )  )
:effect (and        
                    (at start (not (available)))
                    (at end (finished)) 
                    (at start (decrease (stock ?b) 5))
                    (at end (available)) ) )

)