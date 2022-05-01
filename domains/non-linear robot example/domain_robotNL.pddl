(define (domain robotNL)
    (:requirements :typing :durative-actions :fluents) 
    (:types
		location robot - object)
    (:predicates
        (at-robot ?r - robot ?loc - location)
		(base-at ?loc - location)
		(path ?x ?y - location)
	 )

	(:functions
	  (distance ?x ?y - location)
      (battery-level ?r - robot)
	)
		  
    (:durative-action CHARGE
          :parameters (?r - robot ?loc - location)
		  :control (?percentage - number)
		  :duration (= ?duration (+ ?percentage (/ (* (battery-level ?r) (* (battery-level ?r) ?percentage)) 5000)))
          :condition (and 
				(over all (at-robot ?r ?loc))
				(at start (base-at ?loc))
				(at start (< (battery-level ?r) 100))
				(at start (<= ?percentage (- 100 (battery-level ?r))))
				(at start (> ?percentage 0)))
          :effect (at end (increase (battery-level ?r) ?percentage)))

	(:durative-action MOVE
		:parameters (?r - robot ?loc-from - location ?loc-to - location)
		:duration (= ?duration (/ (distance ?loc-from ?loc-to) 0.1)) 
		:condition (and
			(at start (at-robot ?r ?loc-from))
			(at start (path ?loc-from ?loc-to))
			(at start (>= (battery-level ?r) (/ (distance ?loc-from ?loc-to) 2))))
		:effect (and 
			(at start (not (at-robot ?r ?loc-from)))
			(at end (decrease (battery-level ?r) (/ (distance ?loc-from ?loc-to) 2)))
			(at end (at-robot ?r ?loc-to))))
)
