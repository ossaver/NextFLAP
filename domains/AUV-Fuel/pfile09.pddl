(define (problem auv-3D-problem-1) (:domain auv-2D-1)
    (:objects 
        A B C D E F G H I - location
    ;B C D E F G H I J K L
    )

	(:init 
        (= (x) 0)
        (= (maxV) 2)
        (= (max-recharge-rate) 20)
        (= (max-solar-rate) 20)
        (= (max-fuel-rate) 20)

        (= (fuel-cell-battery) 20)
        (= (solar-power) 20)
        (= (fuel) 20)
        
        (free)
        (= (min_limit A) 12) (= (max_limit A) 17)
        (= (min_limit B) 42) (= (max_limit B) 47)
        (= (min_limit C) 72) (= (max_limit C) 77)
        (= (min_limit D) 92) (= (max_limit D) 97)
        (= (min_limit E) 18) (= (max_limit E) 21)
        (= (min_limit F) 48) (= (max_limit F) 51)
        (= (min_limit G) 82) (= (max_limit G) 87)
        (= (min_limit H) 5) (= (max_limit H) 10)
        (= (min_limit I) 7) (= (max_limit I) 12)
      ;  (= (min_limit J) 88) (= (max_limit J) 92)
      ;  (= (min_limit K) 22) (= (max_limit K) 27)
      ;  (= (min_limit L) 32) (= (max_limit L) 37)

        )

	(:goal
		(and
      (sample-taken A) (sample-taken B)  
      (sample-taken C) (sample-taken D)
      (sample-taken E) (sample-taken F)  
      (sample-taken G) (sample-taken H)
      (sample-taken I) ;(sample-taken J)  
      ;(sample-taken K) ;(sample-taken L)           
            ))
(:metric minimize (total-time) )
    )