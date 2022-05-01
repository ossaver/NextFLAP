(define (problem p1robotNL)
	(:domain robotNL)
	(:objects
	A B C - location
	r - robot
	)
	(:init
	(at-robot r A)
	(base-at B)
	(path A B)
	(path B C)
	(= (battery-level r) 15)
	(= (distance A B) 20)
	(= (distance B C) 50)
	)
	(:goal (and
	(at-robot r C)
	(>= (battery-level r) 50)
	))

(:metric minimize (total-time))

)
