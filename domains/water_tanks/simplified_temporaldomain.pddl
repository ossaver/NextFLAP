(define (domain waterTanks)
    (:requirements :typing :durative-actions :fluents :duration-inequalities) 
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
			(over all (at-robot ?r ?loc))
			(at start (>= (battery-level ?r) 1))
			(at start (at-jar ?j ?loc))
			(at start (empty ?r)))
		:effect (and 
			(at start (not (empty ?r)))
			(at end (decrease (battery-level ?r) 1))
			(at start (not (at-jar ?j ?loc)))
			(at end (has ?r ?j))))
	(:durative-action drop-jar
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 1) 
		:condition (and
			(at start (>= (battery-level ?r) 1))
			(over all (at-robot ?r ?loc))
			(at start (has ?r ?j)))
		:effect (and 
			(at end (decrease (battery-level ?r) 1))
			(at start (not (has ?r ?j)))
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
    (:durative-action fill-jar1
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 1)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 1 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 1))))
        (:durative-action fill-jar2
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 2)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 2 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 2))))
        (:durative-action fill-jar5
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 5)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 5 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 5))))
        (:durative-action fill-jar10
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 10)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 10 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 10))))
        (:durative-action fill-jar15
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 15)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 15 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 15))))
        (:durative-action fill-jar20
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 20)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 20 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 20))))
        (:durative-action fill-jar25
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 25)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 25 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 25))))
        (:durative-action fill-jar30
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 30)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 30 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 30))))
        (:durative-action fill-jar35
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 35)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 35 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 35))))
        (:durative-action fill-jar40
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 40)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 40 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 40))))
        (:durative-action fill-jar45
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 45)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 45 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 45))))
        (:durative-action fill-jar50
		:parameters (?r - robot ?j - jar ?loc - location)
		:duration (= ?duration 50)
		:condition (and
			(at start (>= (battery-level ?r) 5))
			(at start (not-using-jar))
			(at start (not-using-tap ?loc))
			(at start (<= (+ 50 (level ?j)) (max-level ?j)))
 			(at start (>= (battery-level ?r) 5))
			(at start (tap ?loc))
			(over all (at-robot ?r ?loc))
			(over all (has ?r ?j)))		
		:effect (and
			(at start (not (not-using-tap ?loc)))
			(at start (not (not-using-jar)))
			(at end (decrease (battery-level ?r) 5))
			(at end (not-using-tap ?loc))
			(at end (not-using-jar))
			(at end (increase (level ?j) 50))))
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
				(at start (not-attached-to-station ?r))
				(at start (station ?loc))
				(over all (at-robot ?r ?loc)))
		:effect (and
				(at start (attached-to-station ?r))
				(at start (not (not-attached-to-station ?r)))
                (at end (not-attached-to-station ?r))
				(at end (not (attached-to-station ?r)))))
    (:durative-action charge10from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 10)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 10)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 11)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 12)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 13)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from50
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 15)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 50)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from60
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 17)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 60)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from70
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 20)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 70)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from80
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 23)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 80)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge10from90
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 26)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 90)))
              :effect (at end (increase (battery-level ?r) 10)))
    (:durative-action charge20from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 20)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 20)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 22)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 24)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 26)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from50
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 30)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 50)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from60
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 34)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 60)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from70
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 40)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 70)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge20from80
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 46)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 80)))
              :effect (at end (increase (battery-level ?r) 20)))
    (:durative-action charge30from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 30)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 31)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 32)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 35)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 40)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from50
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 45)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 50)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from60
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 52)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 60)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge30from70
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 59)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 70)))
              :effect (at end (increase (battery-level ?r) 30)))
    (:durative-action charge40from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 40)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 41)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 43)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 47)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 53)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from50
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 60)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 50)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge40from60
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 69)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 60)))
              :effect (at end (increase (battery-level ?r) 40)))
    (:durative-action charge50from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 50)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge50from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 51)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge50from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 54)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge50from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 59)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge50from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 66)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge50from50
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 75)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 50)))
              :effect (at end (increase (battery-level ?r) 50)))
    (:durative-action charge60from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 60)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 60)))
    (:durative-action charge60from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 61)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 60)))
    (:durative-action charge60from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 65)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 60)))
    (:durative-action charge60from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 71)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 60)))
    (:durative-action charge60from40
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 79)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 40)))
              :effect (at end (increase (battery-level ?r) 60)))
    (:durative-action charge70from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 70)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 70)))
    (:durative-action charge70from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 71)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 70)))
    (:durative-action charge70from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 76)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 70)))
    (:durative-action charge70from30
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 83)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 30)))
              :effect (at end (increase (battery-level ?r) 70)))
    (:durative-action charge80from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 80)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 80)))
    (:durative-action charge80from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 82)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 80)))
    (:durative-action charge80from20
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 86)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 20)))
              :effect (at end (increase (battery-level ?r) 80)))
    (:durative-action charge90from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 90)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 90)))
    (:durative-action charge90from10
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 92)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 10)))
              :effect (at end (increase (battery-level ?r) 90)))
    (:durative-action charge100from0
              :parameters (?r - robot ?loc - location)
    		  :duration (= ?duration 100)
              :condition (and 
    				(over all (at-robot ?r ?loc))
    				(over all (attached-to-station ?r))
    				(at start (<= (battery-level ?r) 0)))
              :effect (at end (increase (battery-level ?r) 100)))
)