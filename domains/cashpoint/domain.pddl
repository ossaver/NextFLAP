;; no points. no exchange in bank..
;; no buy_with_card..
;; cash only transactions..

(define (domain nightout)
(:requirements :typing :fluents :durative-actions
                 :duration-inequalities)
(:types shop bank changeOffice - location
        currency
        item)

(:predicates    (at ?a - location)
                (canwithdraw ?b - location)
                (canexchange ?b - changeOffice)
                (canbuy ?a - shop ?i - item)
                (bought ?i - item)
                (available)
                (have_enough ?z - currency)
                (link ?a ?b - location)
                (different-currencies ?c1 ?c2 - currency)
                (currencyOf ?i - item ?c - currency)
        )
(:functions     (inpocket ?z - currency)
                (balance ?z - currency)
                (exchangeRate ?z1 ?z2 - currency)
                (points ?z - currency)
                (currency_goal ?z1 - currency)
                (price ?i - item)
                (bank-reserve ?b - bank ?c - currency)
)

(:durative-action buy_with_cash
:parameters (?i - item ?a - shop ?z - currency)
:duration (= ?duration 1)
:condition (and     (at start (at ?a))
                    (at start (canbuy ?a ?i) )
                    (at start (available))
                    (at start (>= (inpocket ?z) (price ?i) ))
                    (at start (currencyOf ?i ?z))
                    (over all (at ?a))
                    (at end (>= (inpocket ?z) 0))
                     )
:effect (and    (at start (decrease (inpocket ?z) (price ?i) )) 
                (at start (not (available)))
                (at end (bought ?i) )
                (at end (available))
        ))

(:durative-action withdraw
:parameters (?b - bank ?z1 - currency)
:control (?cash - number)
:duration (= ?duration 2)
:condition (and (over all (at ?b)) 
                (at start (>= ?cash 20))
                (at start (<= ?cash 250))
                (at start (>= (balance ?z1) ?cash))
                (at start (>= (balance ?z1) 0))
                (at end (>= (balance ?z1) 0))

                (at start (>= (bank-reserve ?b ?z1) ?cash))
                (at start (>= (bank-reserve ?b ?z1) 0))
                (at end (>= (bank-reserve ?b ?z1) 0))

                (at end (>= (inpocket ?z1) 0))
                (at start (available))
                (at start (canwithdraw ?b))
                )
:effect (and    
                (at start (not (available)))
                (at end (increase (inpocket ?z1) ?cash))
                (at start (decrease (balance ?z1) ?cash))
                (at start (decrease (bank-reserve ?b ?z1) ?cash))
                (at end (available))
        ))

(:durative-action exchange_in_changeOffice
:parameters (?b - changeOffice ?z1 ?z2 - currency)
:control (?cash - number)
:duration (= ?duration 2)
:condition (and (over all (at ?b)) 
                (at start (canexchange ?b))
                (at start (different-currencies ?z1 ?z2))
                (at start (>= ?cash 20))
                (at start (<= ?cash 500))
                (at start (>= (inpocket ?z1) ?cash))
                (at start (>= (inpocket ?z2) 0))
                (at end (>= (inpocket ?z2) 0))
                (at end (>= (inpocket ?z1) 0))
                (at start (available))
                )
:effect (and    
                (at start (not (available)))
                (at end (increase (inpocket ?z2) (* ?cash (exchangeRate ?z1 ?z2) ) ) )
                (at start (decrease (inpocket ?z1) ?cash) )
                (at end (available))
        ))

(:durative-action goto
:parameters (?a ?b - location)
:duration (= ?duration 5)
:condition (and (at start (at ?a)) (at start (available)) (at start (link ?a ?b)) )
:effect (and       (at start (not (at ?a))) (at start (not (available)))
                   (at end (at ?b))(at end (available))
        ))

(:action save_for_later
:parameters (?z - currency)
:precondition (and  (>= (inpocket ?z) (currency_goal ?z) ) )
:effect (and        (have_enough ?z)
                    (decrease (inpocket ?z) (currency_goal ?z) )
)
)
)