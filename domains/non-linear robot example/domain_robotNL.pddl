(define (domain robotNL)
    (:requirements :typing :durative-actions :fluents) 
    (:types
		location robot - object)
    (:predicates
        (robot-at ?r - robot ?loc - location)
		(station-at ?loc - location)
		(path ?x ?y - location)
		(attached-to-station ?r - robot)
	 )

	(:functions
	  (distance ?x ?y - location)
      (battery-level ?r - robot)
	)
	
	(:durative-action attach
		:parameters (?r - robot ?loc - location)
		:duration (and (>= ?duration 1) (<= ?duration 100)) 
		:condition (and 
				(at start (not (attached-to-station ?r)))
				(at start (station-at ?loc))
				(over all (robot-at ?r ?loc)))
		:effect (and
				(at start (attached-to-station ?r))
				(at end (not (attached-to-station ?r)))))
          
    (:durative-action charge
          :parameters (?r - robot ?loc - location)
		  :control (?percentage - number)
		  :duration (= ?duration (+ ?percentage (/ (* (battery-level ?r) (* (battery-level ?r) ?percentage)) 5000)))
          :condition (and 
				(over all (robot-at ?r ?loc))
				(over all (attached-to-station ?r))
				(at start (< (battery-level ?r) 100))
				(at start (<= ?percentage (- 100 (battery-level ?r))))
				(at start (> ?percentage 0)))
          :effect (at end (increase (battery-level ?r) ?percentage)))

	(:durative-action move
		:parameters (?r - robot ?loc-from - location ?loc-to - location)
		:duration (= ?duration (/ (distance ?loc-from ?loc-to) 0.1)) 
		:condition (and
			(at start (robot-at ?r ?loc-from))
			(at start (path ?loc-from ?loc-to))
			(at start (>= (battery-level ?r) (/ (distance ?loc-from ?loc-to) 2))))
		:effect (and 
			(at start (not (robot-at ?r ?loc-from)))
			(at end (decrease (battery-level ?r) (/ (distance ?loc-from ?loc-to) 2)))
			(at end (robot-at ?r ?loc-to))))
)
