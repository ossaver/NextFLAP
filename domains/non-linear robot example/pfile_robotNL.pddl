(define (problem p1robotNL)
	(:domain robotNL)
	(:objects
	A B C - location
	r - robot
	)
	(:init
	(robot-at r A)
	(station-at B)
	(path A B)
	(path B C)
	(= (battery-level r) 15)
	(= (distance A B) 20)
	(= (distance B C) 50)
	)
	(:goal (and
	(robot-at r C)
	(>= (battery-level r) 50)
	))

(:metric minimize (total-time))

)
