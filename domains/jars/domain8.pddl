(define (domain Jars)
(:requirements :typing :durative-actions :fluents)
(:types jar)

(:constants A B C D E - jar)

(:predicates 
	(goal_achieved) 
)
(:functions 
    (capacity ?j - jar) 
    (level ?j - jar)
)

(:durative-action fill
:parameters (?x - jar)
:duration (= ?duration (- (capacity ?x) (level ?x)))
:condition (and 
            (at start (<= (level ?x) (capacity ?x)))
            )
:effect (and (at end (assign (level ?x) (capacity ?x) )))
)

(:durative-action empty
:parameters (?x - jar)
:duration (= ?duration (level ?x))
:condition (and 
            (at start (> (level ?x) 0))
            )
:effect (and (at end (assign (level ?x) 0 )))
)

(:durative-action transfer-all
:parameters (?x - jar ?y - jar)
:duration (= ?duration (level ?x))
:condition (and (at start (not (= ?x ?y))) (at start (<= (level ?x) (- (capacity ?y) (level ?y)))))
:effect (and (at end (increase (level ?y) (level ?x)))
			 (at end (assign (level ?x) 0))))

(:durative-action transfer-fill
:parameters (?x - jar ?y - jar)
:duration (= ?duration (- (capacity ?y) (level ?y)))
:condition (and (at start (not (= ?x ?y))) (at start (>= (level ?x) (- (capacity ?y) (level ?y)))))
:effect (and (at end (decrease (level ?x) (- (capacity ?y) (level ?y))))
			 (at end (assign (level ?y) (capacity ?y)))))

(:durative-action reach-goal
:parameters ()
:duration (= ?duration 1)
:condition (and 
	(at start (= (level A) 4))
	(at start (= (level E) 11))
)
:effect (and (at end (goal_achieved))))

)
