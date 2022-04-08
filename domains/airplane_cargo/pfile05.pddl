(define (problem airplane-cargo0) (:domain airplane)
(:objects
	tanker0  - tanker
	plane0  - plane
	airport0 airport1 airport2  - airport
	refinery0 refinery1 refinery2  - refinery
	cargo0 cargo1 cargo2 cargo3  - cargo
)

(:init
	(can_fly plane0)

	(tanker_at tanker0 refinery1)

	(plane_at plane0 airport0)

	(cargo_at cargo0 airport2)
	(cargo_at cargo1 airport0)
	(cargo_at cargo2 airport2)
	(cargo_at cargo3 airport1)

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

	(= (plane_tank_level plane0) 139)

	(= (tanker_capacity tanker0) 25000)

	(= (tanker_level tanker0) 61)

	(= (flying_distance airport0 airport1) 162)
	(= (flying_distance airport0 airport2) 131)
	(= (flying_distance airport1 airport0) 109)
	(= (flying_distance airport1 airport2) 150)
	(= (flying_distance airport2 airport0) 241)
	(= (flying_distance airport2 airport1) 182)
)

(:goal	(and

	(cargo_at cargo3 airport2)
	(cargo_at cargo2 airport1)
	(cargo_at cargo0 airport0)
	(cargo_at cargo1 airport0)
		)
	)
)