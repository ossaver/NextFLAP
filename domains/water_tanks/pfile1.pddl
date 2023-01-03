(define (problem waterTanks1)
(:domain waterTanks)
(:objects
	A - location
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
	(= (battery-level r1) 5)
	
	(tap A)
	(not-using-tap A)
	
	(tank-open A)
	(= (tank-level A) 0)
	(= (tank-goal A) 30)
)
	
(:goal (and
	(tank-ready A)
))

(:metric minimize (total-time))

)
