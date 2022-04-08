(define (problem airplane-cargo0) (:domain airplane)
(:objects
	tanker0  - tanker
	plane0 plane1  - plane
	airport0 airport1  - airport
	refinery0 refinery1  - refinery
	cargo0 cargo1  - cargo
)

(:init
	(can_fly plane0)
	(can_fly plane1)

	(tanker_at tanker0 refinery1)

	(plane_at plane0 airport1)
	(plane_at plane1 airport0)

	(cargo_at cargo0 airport1)
	(cargo_at cargo1 airport0)

	(route airport0 airport1)
	(route airport1 airport0)

	(conn airport0 airport1)
	(conn airport1 airport0)

	(conn airport0 refinery0)
	(conn refinery0 airport0)
	(conn airport0 refinery1)
	(conn refinery1 airport0)
	(conn airport1 refinery0)
	(conn refinery0 airport1)
	(conn airport1 refinery1)
	(conn refinery1 airport1)

	(idle tanker0)
	(= (refinery_tank_level refinery0) 200000)
	(= (refinery_tank_level refinery1) 200000)

	(= (plane_tank_capacity plane0) 50000)
	(= (plane_tank_capacity plane1) 50000)

	(= (plane_tank_level plane0) 11)
	(= (plane_tank_level plane1) 114)

	(= (tanker_capacity tanker0) 25000)

	(= (tanker_level tanker0) 118)

	(= (flying_distance airport0 airport1) 174)
	(= (flying_distance airport1 airport0) 127)
)

(:goal	(and

	(cargo_at cargo1 airport0)
	(cargo_at cargo0 airport0)
		)
	)
)