(define (domain auv-2D-1)
(:requirements :typing :durative-actions :fluents :duration-inequalities)

(:types location)

(:predicates
    (sample-taken ?loc - location)
    (free)
)
(:functions 
    (x)
	
	(fuel-cell-battery)
    (solar-power)
    (fuel)

	(max-recharge-rate)
	(max-solar-rate)
	(max-fuel-rate)
    (maxV)
    
    (min_limit ?loc - location)
    (max_limit ?loc - location)
)

(:durative-action glide_forward
:parameters ()
:control (?dx - number)
:duration (and  
        (>= ?duration (/ ?dx (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= ?dx 0))
 (at start (<= ?dx 100))

 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))

 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 
 (at start (>= (fuel-cell-battery) (* ?dx 2) ))   
(at end (>= (fuel-cell-battery) 0))
)
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) (* ?dx 2) ))
  (at start (increase (x) ?dx))
  (at end (free))
 ))

(:durative-action glide_backward
:parameters ()
:control (?dx - number)
:duration (and  
        (>= ?duration (/ ?dx (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= ?dx 0))
 (at start (<= ?dx 100)) 

 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))

 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))

(at start (>= (fuel-cell-battery) (* ?dx 2) ))   
(at end (>= (fuel-cell-battery) 0))
)
:effect (and      
  (at start (not (free)))
 (at start (decrease (fuel-cell-battery) (* ?dx 2) ))
 (at start (decrease (x) ?dx ) )
  (at end (free))
 ))

(:durative-action recharge
:parameters ()
:control (?deltaRecharge - number)
:duration (and  (>= ?duration (/ ?deltaRecharge (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (>= ?deltaRecharge 1)) 
 (at start (<= ?deltaRecharge 200))
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))

 (at start (>= (solar-power) (* ?deltaRecharge 2) ) )
 (at end (>= (solar-power) 0 ))

 (at start (>= (fuel) (* ?deltaRecharge 2) ) )
 (at end (>= (fuel) 0))

 )
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) (* ?deltaRecharge 2) ) )
	(at start (decrease (fuel) (* ?deltaRecharge 2) ) )
    (at start (increase (fuel-cell-battery) ?deltaRecharge))
            (at end (free))
    ))

(:durative-action turn_solar_panels_on
:parameters ()
:control (?solar - number)
:duration (and (>= ?duration (/ ?solar (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (>= ?solar 1)) 
 (at start (<= ?solar 200))
 (at start (free))

 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000))

 )
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) ?solar))
            (at end (free))
    ))

(:durative-action refuel_tank
:parameters ()
:control (?fuelAmount - number)
:duration 	(and  (>= ?duration (/ ?fuelAmount (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (>= ?fuelAmount 1)) 
 (at start (<= ?fuelAmount 200))
 (at start (free))

 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000))

 )
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) ?fuelAmount)) 
    (at end (free))
    ))

(:durative-action take-sample
 :parameters ( ?loc - location)
:duration (and  
			(>= ?duration 2 ) 
        	(<= ?duration 8))
 :condition (and  
  (at start (free))
  (at start (>= (x) (min_limit ?loc) ))
  (at end (>= (x) (min_limit ?loc) ))

  (at start (<= (x) (max_limit ?loc) ))
  (at end (<= (x) (max_limit ?loc) ))
)
:effect (and      (at start (not (free)))
            (at start (sample-taken ?loc))
            (at end (free))
            ))

)