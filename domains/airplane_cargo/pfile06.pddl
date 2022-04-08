(define (problem airplane-cargo0) (:domain airplane)
(:objects
	tanker0  - tanker
	plane0 plane1  - plane
	airport0 airport1 airport2  - airport
	refinery0 refinery1 refinery2  - refinery
	cargo0 cargo1 cargo2 cargo3 cargo4  - cargo
)

(:init
	(can_fly plane0)
	(can_fly plane1)

	(tanker_at tanker0 refinery2)

	(plane_at plane0 airport1)
	(plane_at plane1 airport1)

	(cargo_at cargo0 airport2)
	(cargo_at cargo1 airport1)
	(cargo_at cargo2 airport2)
	(cargo_at cargo3 airport1)
	(cargo_at cargo4 airport0)

	(route airport0 airport1)
	(route airport0 airport2)
	(route airport1 airport0)
	(route airport1 airport2)
	(route airport2 airport0)
	(route airport2 airport1)

	(conn airport0 airport1)
	(conn airport0 airport2)
	(conn airport1 airport0)
	(conn airport1 airport2)
	(conn airport2 airport0)
	(conn airport2 airport1)

	(conn airport0 refinery0)
	(conn refinery0 airport0)
	(conn airport0 refinery1)
	(conn refinery1 airport0)
	(conn airport0 refinery2)
	(conn refinery2 airport0)
	(conn airport1 refinery0)
	(conn refinery0 airport1)
	(conn airport1 refinery1)
	(conn refinery1 airport1)
	(conn airport1 refinery2)
	(conn refinery2 airport1)
	(conn airport2 refinery0)
	(conn refinery0 airport2)
	(conn airport2 refinery1)
	(conn refinery1 airport2)
	(conn airport2 refinery2)
	(conn refinery2 airport2)

	(idle tanker0)
	(= (refinery_tank_level refinery0) 200000)
	(= (refinery_tank_level refinery1) 200000)
	(= (refinery_tank_level refinery2) 200000)

	(= (plane_tank_capacity plane0) 50000)
	(= (plane_tank_capacity plane1) 50000)

	(= (plane_tank_level plane0) 136)
	(= (plane_tank_level plane1) 75)

	(= (tanker_capacity tanker0) 25000)

	(= (tanker_level tanker0) 17)

	(= (flying_distance airport0 airport1) 154)
	(= (flying_distance airport0 airport2) 101)
	(= (flying_distance airport1 airport0) 208)
	(= (flying_distance airport1 airport2) 216)
	(= (flying_distance airport2 airport0) 116)
	(= (flying_distance airport2 airport1) 231)
)

(:goal	(and

	(cargo_at cargo4 airport2)
	(cargo_at cargo2 airport2)
	(cargo_at cargo1 airport0)
	(cargo_at cargo0 airport2)
	(cargo_at cargo3 airport1)
		)
	)
)