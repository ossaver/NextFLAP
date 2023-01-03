(define (domain waterTanks)
    (:requirements :typing :durative-actions :fluents :duration-inequalities :timed-initial-literals)  
    (:types
		location robot jar - object)
    (:predicates
        (at-robot ?r - robot ?l - location)
		(at-jar ?j - jar ?l - location)
		(tap ?l - location)
		(empty ?r - robot)
		(has ?r - robot ?j - jar)
		(not-using-jar)
		(not-using-tap ?l - location)
		(tank-ready ?l - location)
		(tank-open ?l - location)
		(station ?loc - location)
		(attached-to-station ?r - robot)
		(not-attached-to-station ?r - robot)
	)

	(:functions
	  (level ?j - jar)
	  (max-level ?j - jar)
	  (tank-level ?l - location)
	  (tank-goal ?l - location)
	  (battery-level ?r - robot)
	)

	(:durative-action move
		:parameters (?r - robot ?loc-from - location ?loc-to - location)
		:duration (= ?duration 10) 
		:condition (and
			(at start (>= (battery-level ?r) 10))
			(at start (at-robot ?r ?loc-from)))
		:effect (and 
			(at start (not (at-robot ?r ?loc-from)))
			(at end (decrease (battery-level ?r) 10))
			(at end (at-robot ?r ?loc-to))))

	(:durative-action take-jar
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 1) 
		:condition (and
			(at start (>= (battery-level ?r) 1))
			(over all (at-robot ?r ?loc))
			(at start (at-jar ?j ?loc))
			(at start (empty ?r)))
		:effect (and 
			(at start (not (empty ?r)))
			(at start (not (at-jar ?j ?loc)))
			(at end (decrease (battery-level ?r) 1))
			(at end (has ?r ?j))))
			
	(:durative-action drop-jar
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 1) 
		:condition (and
			(at start (>= (battery-level ?r) 1))
			(over all (at-robot ?r ?loc))
			(at start (has ?r ?j)))
		:effect (and 
			(at start (not (has ?r ?j)))
			(at end (decrease (battery-level ?r) 1))
			(at end (at-jar ?j ?loc))
			(at end (empty ?r))))
	
	(:durative-action empty-jar
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 5) 
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(over all (at-robot ?r ?loc))
			(at start (<= (+ (level ?j) (tank-level ?loc)) 100))
			(over all (tank-open ?loc))
			(over all (has ?r ?j)))
		:effect (and
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-jar))
			(at end (increase (tank-level ?loc) (level ?j)))
			(at end (assign (level ?j) 0))))

	(:durative-action fill-jar
		:parameters (?r - robot ?j - jar ?loc - location)
		:control (?amount - number)
		:duration (= ?duration ?amount)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (>= ?amount 1))
			(at start (<= ?amount (- (max-level ?j) (level ?j))))
			(at start (tap ?loc))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))
		:effect (and 
			(at start (not (not-using-jar)))
			(at start (not (not-using-tap ?loc)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-jar))
			(at end (not-using-tap ?loc))
			(at end (increase (level ?j) ?amount))))	

	(:durative-action close-tank
		:parameters (?loc - location)
		:duration (= ?duration 1)
		:condition (and
			(at start (tank-open ?loc))
			(at start (= (tank-level ?loc) (tank-goal ?loc)))
			)
		:effect (and 
			(at start (not (tank-open ?loc)))
			(at end (tank-ready ?loc))))
		
	(:durative-action attach
		:parameters (?r - robot ?loc - location)
		:duration (and (>= ?duration 1) (<= ?duration 100)) 
		:condition (and 
				(at start (not (attached-to-station ?r)))
				(at start (station ?loc))
				(over all (at-robot ?r ?loc)))
		:effect (and
				(at start (attached-to-station ?r))
				(at end (not (attached-to-station ?r)))))

    (:durative-action charge
          :parameters (?r - robot ?loc - location)
		  :control (?percentage - number)
		  :duration (= ?duration (+ ?percentage (/ (* (battery-level ?r) (* (battery-level ?r) ?percentage)) 5000)))
          :condition (and 
				(over all (at-robot ?r ?loc))
				(over all (attached-to-station ?r))
				(at start (< (battery-level ?r) 100))
				(at start (<= ?percentage (- 100 (battery-level ?r))))
				(at start (> ?percentage 0)))
          :effect (at end (increase (battery-level ?r) ?percentage)))
)
