(define (problem Jars-problem-1) (:domain Jars)
    
	(:init 
		(= (capacity A) 8) 
		(= (level A) 8)
		(= (capacity B) 5) 
		(= (level B) 0)
		(= (capacity C) 3) 
		(= (level C) 0)
		(= (capacity D) 2) 
		(= (level D) 0)
    )

	(:goal
		(and (goal_achieved)))

	(:metric minimize (total-time) )
)