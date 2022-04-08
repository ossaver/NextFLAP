
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


(:durative-action glide_forward0
  :parameters ()
  :duration (and (>= ?duration (/ 0 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 0 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 0 ))
              (at start (increase (x) 0))
              (at end (free))))

(:durative-action glide_backward0
:parameters ()
:duration (and  
        (>= ?duration (/ 0 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 0 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 0 ))
  (at start (decrease (x) 0 ) )
  (at end (free))))
            
(:durative-action glide_forward10
  :parameters ()
  :duration (and (>= ?duration (/ 10 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 20 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 20 ))
              (at start (increase (x) 10))
              (at end (free))))

(:durative-action glide_backward10
:parameters ()
:duration (and  
        (>= ?duration (/ 10 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 20 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 20 ))
  (at start (decrease (x) 10 ) )
  (at end (free))))
            
(:durative-action glide_forward20
  :parameters ()
  :duration (and (>= ?duration (/ 20 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 40 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 40 ))
              (at start (increase (x) 20))
              (at end (free))))

(:durative-action glide_backward20
:parameters ()
:duration (and  
        (>= ?duration (/ 20 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 40 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 40 ))
  (at start (decrease (x) 20 ) )
  (at end (free))))
            
(:durative-action glide_forward30
  :parameters ()
  :duration (and (>= ?duration (/ 30 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 60 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 60 ))
              (at start (increase (x) 30))
              (at end (free))))

(:durative-action glide_backward30
:parameters ()
:duration (and  
        (>= ?duration (/ 30 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 60 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 60 ))
  (at start (decrease (x) 30 ) )
  (at end (free))))
            
(:durative-action glide_forward40
  :parameters ()
  :duration (and (>= ?duration (/ 40 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 80 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 80 ))
              (at start (increase (x) 40))
              (at end (free))))

(:durative-action glide_backward40
:parameters ()
:duration (and  
        (>= ?duration (/ 40 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 80 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 80 ))
  (at start (decrease (x) 40 ) )
  (at end (free))))
            
(:durative-action glide_forward50
  :parameters ()
  :duration (and (>= ?duration (/ 50 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 100 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 100 ))
              (at start (increase (x) 50))
              (at end (free))))

(:durative-action glide_backward50
:parameters ()
:duration (and  
        (>= ?duration (/ 50 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 100 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 100 ))
  (at start (decrease (x) 50 ) )
  (at end (free))))
            
(:durative-action glide_forward60
  :parameters ()
  :duration (and (>= ?duration (/ 60 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 120 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 120 ))
              (at start (increase (x) 60))
              (at end (free))))

(:durative-action glide_backward60
:parameters ()
:duration (and  
        (>= ?duration (/ 60 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 120 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 120 ))
  (at start (decrease (x) 60 ) )
  (at end (free))))
            
(:durative-action glide_forward70
  :parameters ()
  :duration (and (>= ?duration (/ 70 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 140 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 140 ))
              (at start (increase (x) 70))
              (at end (free))))

(:durative-action glide_backward70
:parameters ()
:duration (and  
        (>= ?duration (/ 70 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 140 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 140 ))
  (at start (decrease (x) 70 ) )
  (at end (free))))
            
(:durative-action glide_forward80
  :parameters ()
  :duration (and (>= ?duration (/ 80 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 160 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 160 ))
              (at start (increase (x) 80))
              (at end (free))))

(:durative-action glide_backward80
:parameters ()
:duration (and  
        (>= ?duration (/ 80 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 160 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 160 ))
  (at start (decrease (x) 80 ) )
  (at end (free))))
            
(:durative-action glide_forward90
  :parameters ()
  :duration (and (>= ?duration (/ 90 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 180 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 180 ))
              (at start (increase (x) 90))
              (at end (free))))

(:durative-action glide_backward90
:parameters ()
:duration (and  
        (>= ?duration (/ 90 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 180 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 180 ))
  (at start (decrease (x) 90 ) )
  (at end (free))))
            
(:durative-action glide_forward100
  :parameters ()
  :duration (and (>= ?duration (/ 100 (maxV))) 
                 (<= ?duration 200))
  :condition (and  
             (at start (free))
             (at start (>= (x) 0))
             (over all (>= (x) 0))
             (at end (>= (x) 0))
             (at start (<= (x) 100))
             (over all (<= (x) 100))
             (at end (<= (x) 100))
             (at start (>= (fuel-cell-battery) 200 ))   
             (at end (>= (fuel-cell-battery) 0)))
  :effect (and      
              (at start (not (free)))
              (at start (decrease (fuel-cell-battery) 200 ))
              (at start (increase (x) 100))
              (at end (free))))

(:durative-action glide_backward100
:parameters ()
:duration (and  
        (>= ?duration (/ 100 (maxV))) 
        (<= ?duration 200))
:condition (and  
 (at start (free))
 (at start (>= (x) 0))
 (over all (>= (x) 0))
 (at end (>= (x) 0))
 (at start (<= (x) 100))
 (over all (<= (x) 100))
 (at end (<= (x) 100))
 (at start (>= (fuel-cell-battery) 200 ))   
 (at end (>= (fuel-cell-battery) 0)))
:effect (and      
  (at start (not (free)))
  (at start (decrease (fuel-cell-battery) 200 ))
  (at start (decrease (x) 100 ) )
  (at end (free))))
            
(:durative-action recharge1
:parameters ()
:duration (and  (>= ?duration (/ 1 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 2 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 2 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 2 ) )
	(at start (decrease (fuel) 2 ) )
    (at start (increase (fuel-cell-battery) 1))
    (at end (free))))
    
(:durative-action turn_solar_panels_on1
:parameters ()
:duration (and (>= ?duration (/ 1 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 1))
    (at end (free))))
    
(:durative-action refuel_tank1
:parameters ()
:duration 	(and  (>= ?duration (/ 1 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 1)) 
    (at end (free))))
    
(:durative-action recharge20
:parameters ()
:duration (and  (>= ?duration (/ 20 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 40 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 40 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 40 ) )
	(at start (decrease (fuel) 40 ) )
    (at start (increase (fuel-cell-battery) 20))
    (at end (free))))
    
(:durative-action turn_solar_panels_on20
:parameters ()
:duration (and (>= ?duration (/ 20 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 20))
    (at end (free))))
    
(:durative-action refuel_tank20
:parameters ()
:duration 	(and  (>= ?duration (/ 20 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 20)) 
    (at end (free))))
    
(:durative-action recharge40
:parameters ()
:duration (and  (>= ?duration (/ 40 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 80 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 80 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 80 ) )
	(at start (decrease (fuel) 80 ) )
    (at start (increase (fuel-cell-battery) 40))
    (at end (free))))
    
(:durative-action turn_solar_panels_on40
:parameters ()
:duration (and (>= ?duration (/ 40 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 40))
    (at end (free))))
    
(:durative-action refuel_tank40
:parameters ()
:duration 	(and  (>= ?duration (/ 40 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 40)) 
    (at end (free))))
    
(:durative-action recharge60
:parameters ()
:duration (and  (>= ?duration (/ 60 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 120 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 120 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 120 ) )
	(at start (decrease (fuel) 120 ) )
    (at start (increase (fuel-cell-battery) 60))
    (at end (free))))
    
(:durative-action turn_solar_panels_on60
:parameters ()
:duration (and (>= ?duration (/ 60 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 60))
    (at end (free))))
    
(:durative-action refuel_tank60
:parameters ()
:duration 	(and  (>= ?duration (/ 60 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 60)) 
    (at end (free))))
    
(:durative-action recharge80
:parameters ()
:duration (and  (>= ?duration (/ 80 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 160 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 160 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 160 ) )
	(at start (decrease (fuel) 160 ) )
    (at start (increase (fuel-cell-battery) 80))
    (at end (free))))
    
(:durative-action turn_solar_panels_on80
:parameters ()
:duration (and (>= ?duration (/ 80 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 80))
    (at end (free))))
    
(:durative-action refuel_tank80
:parameters ()
:duration 	(and  (>= ?duration (/ 80 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 80)) 
    (at end (free))))
    
(:durative-action recharge100
:parameters ()
:duration (and  (>= ?duration (/ 100 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 200 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 200 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 200 ) )
	(at start (decrease (fuel) 200 ) )
    (at start (increase (fuel-cell-battery) 100))
    (at end (free))))
    
(:durative-action turn_solar_panels_on100
:parameters ()
:duration (and (>= ?duration (/ 100 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 100))
    (at end (free))))
    
(:durative-action refuel_tank100
:parameters ()
:duration 	(and  (>= ?duration (/ 100 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 100)) 
    (at end (free))))
    
(:durative-action recharge120
:parameters ()
:duration (and  (>= ?duration (/ 120 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 240 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 240 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 240 ) )
	(at start (decrease (fuel) 240 ) )
    (at start (increase (fuel-cell-battery) 120))
    (at end (free))))
    
(:durative-action turn_solar_panels_on120
:parameters ()
:duration (and (>= ?duration (/ 120 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 120))
    (at end (free))))
    
(:durative-action refuel_tank120
:parameters ()
:duration 	(and  (>= ?duration (/ 120 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 120)) 
    (at end (free))))
    
(:durative-action recharge140
:parameters ()
:duration (and  (>= ?duration (/ 140 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 280 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 280 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 280 ) )
	(at start (decrease (fuel) 280 ) )
    (at start (increase (fuel-cell-battery) 140))
    (at end (free))))
    
(:durative-action turn_solar_panels_on140
:parameters ()
:duration (and (>= ?duration (/ 140 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 140))
    (at end (free))))
    
(:durative-action refuel_tank140
:parameters ()
:duration 	(and  (>= ?duration (/ 140 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 140)) 
    (at end (free))))
    
(:durative-action recharge160
:parameters ()
:duration (and  (>= ?duration (/ 160 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 320 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 320 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 320 ) )
	(at start (decrease (fuel) 320 ) )
    (at start (increase (fuel-cell-battery) 160))
    (at end (free))))
    
(:durative-action turn_solar_panels_on160
:parameters ()
:duration (and (>= ?duration (/ 160 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 160))
    (at end (free))))
    
(:durative-action refuel_tank160
:parameters ()
:duration 	(and  (>= ?duration (/ 160 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 160)) 
    (at end (free))))
    
(:durative-action recharge180
:parameters ()
:duration (and  (>= ?duration (/ 180 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 360 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 360 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 360 ) )
	(at start (decrease (fuel) 360 ) )
    (at start (increase (fuel-cell-battery) 180))
    (at end (free))))
    
(:durative-action turn_solar_panels_on180
:parameters ()
:duration (and (>= ?duration (/ 180 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 180))
    (at end (free))))
    
(:durative-action refuel_tank180
:parameters ()
:duration 	(and  (>= ?duration (/ 180 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 180)) 
    (at end (free))))
    
(:durative-action recharge200
:parameters ()
:duration (and  (>= ?duration (/ 200 (max-recharge-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel-cell-battery) 0))
 (at end (>= (fuel-cell-battery) 0))
 (at start (<= (fuel-cell-battery) 200))
 (at end (<= (fuel-cell-battery) 200))
 (at start (>= (solar-power) 400 ) )
 (at end (>= (solar-power) 0 ))
 (at start (>= (fuel) 400 ) )
 (at end (>= (fuel) 0)))
:effect (and       (at start (not (free)))
	(at start (decrease (solar-power) 400 ) )
	(at start (decrease (fuel) 400 ) )
    (at start (increase (fuel-cell-battery) 200))
    (at end (free))))
    
(:durative-action turn_solar_panels_on200
:parameters ()
:duration (and (>= ?duration (/ 200 (max-solar-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (solar-power) 0))
 (at end (>= (solar-power) 0))
 (at start (<= (solar-power) 20000))
 (at end (<= (solar-power) 20000)))
:effect (and       (at start (not (free)))
    (at start (increase (solar-power) 200))
    (at end (free))))
    
(:durative-action refuel_tank200
:parameters ()
:duration 	(and  (>= ?duration (/ 200 (max-fuel-rate) ) ) 
        	(<= ?duration 10))
:condition (and 
 (at start (free))
 (at start (>= (fuel) 0))
 (at end (>= (fuel) 0))
 (at start (<= (fuel) 20000))
 (at end (<= (fuel) 20000)))
:effect (and       
	(at start (not (free)))
    (at start (increase (fuel) 200)) 
    (at end (free))))
    )