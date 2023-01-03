(define (problem waterTanks6)
(:domain waterTanks)
(:objects
	A B C - location
	r1 r2 - robot
	jar1 jar2 - jar
)
(:init
	(at-robot r1 A)
	(empty r1)
	(not-attached-to-station r1)
	(= (battery-level r1) 50)

	(at-robot r2 B)
	(empty r2)
	(not-attached-to-station r2)
	(= (battery-level r2) 50)
	
	(not-using-jar)
    
    (at-jar jar1 A)
	(= (level jar1) 20)
	(= (max-level jar1) 20)
	
	(at-jar jar2 B)
	(= (level jar2) 0)
	(= (max-level jar2) 40)
	
	(station A)
	
	(tap A)
	(at 100 (not-using-tap A))
	(tap B)
	(at 200 (not-using-tap B))
	
	(tank-open A)
	(= (tank-level A) 0)
	(= (tank-goal A) 10)

	(tank-open B)
	(= (tank-level B) 0)
	(= (tank-goal B) 20)

	(tank-open C)
	(= (tank-level C) 10)
	(= (tank-goal C) 20)
)
	
(:goal (and
	(tank-ready A)
	(tank-ready B)
	(tank-ready C)
))

(:metric minimize (total-time))

)
