(define (problem waterTanks9)
(:domain waterTanks)
(:objects
	A B C D E - location
	r1 r2 r3 - robot
	jar1 jar2 jar3 - jar
)
(:init
	(at-robot r1 A)
	(empty r1)
	(not-attached-to-station r1)
	(at-robot r2 B)
	(empty r2)
	(not-attached-to-station r2)
	(at-robot r3 C)
	(empty r3)
	(not-attached-to-station r3)
	
	(station A)
	(= (battery-level r1) 20)
	(= (battery-level r2) 20)
	(= (battery-level r3) 100)
	
	(tap A)
	(at 100 (not-using-tap A))
	(tap B)
	(at 200 (not-using-tap B))
	
	(at-jar jar1 E)
	(= (level jar1) 10)
	(= (max-level jar1) 20)	
	(at-jar jar2 E)
	(= (level jar2) 40)
	(= (max-level jar2) 50)
	(at-jar jar3 E)
	(= (level jar3) 0)
	(= (max-level jar3) 25)

	(= (tank-level A) 0)
	(= (tank-level B) 0)
	(= (tank-level C) 0)
	(= (tank-level D) 0)
	(= (tank-level E) 0)
	(tank-open A)
	(tank-open B)
	(tank-open C)
	(tank-open D)
	(tank-open E)
	(not-using-jar)
	
	(= (tank-goal A) 20)
	(= (tank-goal B) 50)
	(= (tank-goal C) 10)
	(= (tank-goal D) 20)
	(= (tank-goal E) 40)
)
	
(:goal (and
	(tank-ready A)
	(tank-ready B)
	(tank-ready C)
	(tank-ready D)
	(tank-ready E)
))

(:metric minimize (total-time))

)
