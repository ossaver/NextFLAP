(define (problem waterTanks3)
(:domain waterTanks)
(:objects
	A B - location
	r1 - robot
	jar1 - jar
)
(:init
	(at-robot r1 A)
	(has r1 jar1)
	(not-attached-to-station r1)
	
	(= (level jar1) 20)
	(= (max-level jar1) 20)
	(not-using-jar)
	
	(station A)
	(= (battery-level r1) 50)
	
	(at 100 (tap B))
	(not-using-tap B)
	
	(tank-open A)
	(= (tank-level A) 0)
	(= (tank-goal A) 10)

	(tank-open B)
	(= (tank-level B) 0)
	(= (tank-goal B) 40)
)
	
(:goal (and
	(tank-ready A)
	(tank-ready B)
))

(:metric minimize (total-time))

)
