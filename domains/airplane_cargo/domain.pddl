(define (domain oil-transport-domain)
   (:requirements :typing :fluents :durative-actions :duration-inequalities )
  
   (:types 	tanker 
   			refinery airport - location 
            plane 
            cargo
            )
  
   (:predicates
   	(tanker_at ?tker - tanker ?loc - location)
      (plane_at ?plane - plane ?a - airport) 
      (cargo_at ?o - cargo ?a - airport)
      (cargo_in ?o - cargo ?p - plane)
      (conn ?loc1 ?loc2 - location)
      (route ?l1 ?l2 - airport)
      (idle ?tker - tanker)
      (can_fly ?p - plane)
   )

   (:functions
      (refinery_tank_level ?loc - refinery)

      (plane_tank_capacity ?p - plane)
      (plane_tank_level ?p - plane)

   	(tanker_level ?tker - tanker)
   	(tanker_capacity ?tker - tanker)

      (flying_distance ?a ?b - airport)
   )

   (:durative-action drive_tanker
      :parameters (?tker - tanker ?loc1 ?loc2 - location)
      :duration (= ?duration 50) 
      :condition (and
                  (at start (tanker_at ?tker ?loc1)) 
                  (at start (conn ?loc1 ?loc2) )  
                  (at start (idle ?tker))
               )
      :effect (and 
                  (at start (not (idle ?tker)))
                  (at start (not (tanker_at ?tker ?loc1)))
                  (at end (tanker_at ?tker ?loc2))
                  (at end  (idle ?tker) )
         )
   )

   (:durative-action fill_tanker
   	:parameters (?tker - tanker ?loc - refinery)
   	:control (?amount - number)
   	:duration (and (>= ?duration (/ ?amount 1000 ) ) (<= ?duration 200) )
   	:condition (and 
                  (at start (idle ?tker))
   					(at start (>= ?amount 10))
   					(at start (<= ?amount 25000))
                  (at start (tanker_at ?tker ?loc))
                  (over all (tanker_at ?tker ?loc))
                  (at end (tanker_at ?tker ?loc))


   					(at start (>= (refinery_tank_level ?loc) ?amount) )
   					(at start (<= (tanker_level ?tker) (- (tanker_capacity ?tker) ?amount)))
   					(at end (>= (refinery_tank_level ?loc) 0))
                  (at end (<= (tanker_level ?tker) (tanker_capacity ?tker)) )
   			)
   	:effect (and
                  (at start (not (idle ?tker))) 
                  (at start (decrease (refinery_tank_level ?loc) ?amount) )
   					(at end (increase (tanker_level ?tker) ?amount))
                  (at end  (idle ?tker) ) 
   		)
   )
	
   (:durative-action fill_airplane_tank
      :parameters (?p - plane ?tker - tanker ?airport - airport)
      :control (?amount - number) 
      :duration (= ?duration 10)
      :condition (and 
                  (at start (>= ?amount 10))
                  (at start (<= ?amount 25000))
                  (at start (idle ?tker))
                  (at start (can_fly ?p))
                  
                  (at start (tanker_at ?tker ?airport))
                  (over all (tanker_at ?tker ?airport))
                  (at end (tanker_at ?tker ?airport))

                  (at start (plane_at ?p ?airport))
                  (over all (plane_at ?p ?airport))
                  (at end (plane_at ?p ?airport))

                  (at start (>= (tanker_level ?tker) ?amount ))
                  (at start (<= (plane_tank_level ?p) (- (plane_tank_capacity ?p) ?amount)))
                  (at end (>= (tanker_level ?tker) 0))
                  (at end (<= (plane_tank_level ?p) (plane_tank_capacity ?p) ) )
                  )
      :effect (and 
                  (at start (not (idle ?tker)))
                  (at start (not (can_fly ?p)))
                  (at start (decrease (tanker_level ?tker) ?amount) )
                  (at end (increase (plane_tank_level ?p) ?amount))
                  (at end  (idle ?tker) )
                  (at end  (can_fly ?p) )
                 
         )
   )

   (:durative-action load_airplane
      :parameters (?o - cargo ?p - plane ?loc - airport)
      :duration (= ?duration 10)
      :condition (and (at start (can_fly ?p))

                        (at start (plane_at ?p ?loc))
                        (over all (plane_at ?p ?loc)) 
                        (at end (plane_at ?p ?loc))

                        (at start (cargo_at ?o ?loc)) 
                  )
      :effect (and   
                     (at start (not (can_fly ?p)))
                     (at start (not (cargo_at ?o ?loc) ) )
                     (at end (cargo_in ?o ?p) ) 
                     (at end  (can_fly ?p) )
               )
      )

   (:durative-action unload_airplane
      :parameters (?o - cargo ?p - plane ?loc - airport)
      :duration (= ?duration 10)
      :condition (and 
                   (at start (can_fly ?p))
                  (at start (plane_at ?p ?loc)) 
                  (over all (plane_at ?p ?loc)) 
                  (at end (plane_at ?p ?loc))

                  (at start (cargo_in ?o ?p))
                  )
      :effect (and 
                  (at start (not (can_fly ?p)))
                  (at start (not (cargo_in ?o ?p) ) )
                  (at end (cargo_at ?o ?loc) )
                  (at end  (can_fly ?p) )
              
               )
   )

      (:durative-action fly_airplane
      :parameters (?p - plane ?loc1 ?loc2 - airport)
      :duration (and  (>= ?duration (* (flying_distance ?loc1 ?loc2) 10 ) ) (<= ?duration 20000) 
                    ; (= ?duration 100)
         )
      :condition (and 
                     (at start (can_fly ?p))
                     (at start (route ?loc1 ?loc2))
                     (at start (plane_at ?p ?loc1)) 

                     (at start (>= (plane_tank_level ?p) (* (flying_distance ?loc1 ?loc2) 5) ) ) 
                     (over all (>= (plane_tank_level ?p) 0 ) ) 
                     (at end (>= (plane_tank_level ?p) 0) )

                     )
      :effect (and                        
                     (at start (not (can_fly ?p)))
                     (at start (not (plane_at ?p ?loc1) ) )
                     (at start (decrease (plane_tank_level ?p) (* (flying_distance ?loc1 ?loc2) 5) ) )
                     (at end (plane_at ?p ?loc2))
                     (at end  (can_fly ?p) )

                     )
   )

         (:durative-action fly_airplane_fast
      :parameters (?p - plane ?loc1 ?loc2 - airport)
      :duration (and  (>= ?duration (* (flying_distance ?loc1 ?loc2) 5 ) ) (<= ?duration 20000) 
                  ;(= ?duration 50)
         )
      :condition (and 
                     (at start (can_fly ?p))
                     (at start (route ?loc1 ?loc2))
                     (at start (plane_at ?p ?loc1)) 

                     (at start (>= (plane_tank_level ?p) (* (flying_distance ?loc1 ?loc2) 10) ) ) 
                     (over all (>= (plane_tank_level ?p) 0 ) ) 
                     (at end (>= (plane_tank_level ?p) 0) )

                     )
      :effect (and                        
                     (at start (not (can_fly ?p)))
                     (at start (not (plane_at ?p ?loc1) ) )
                     (at start (decrease (plane_tank_level ?p) (* (flying_distance ?loc1 ?loc2) 10) ) )
                     (at end (plane_at ?p ?loc2))
                     (at end  (can_fly ?p) )

                     )
   )

)
