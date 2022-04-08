(define (problem roverprob0) (:domain Rover)
(:objects
	general - Lander
	colour high_res low_res - Mode
	rover0 - Rover
	rover0store - Store
	waypoint0 waypoint1 waypoint2 - Waypoint
	camera0 - Camera
	objective0 objective1 - Objective
	)
(:init
	(visible waypoint0 waypoint1)
	(visible waypoint1 waypoint0)
	(visible waypoint0 waypoint2)
	(visible waypoint2 waypoint0)
	(visible waypoint1 waypoint2)
	(visible waypoint2 waypoint1)
	(= (power_loss_rate waypoint0) 1.17)
	(= (power_at_station waypoint0) 53)
	(= (power_capacity waypoint0) 198)
	(at_soil_sample waypoint1)
	(= (power_loss_rate waypoint1) 1.48)
	(= (power_at_station waypoint1) 56)
	(= (power_capacity waypoint1) 125)
	(= (power_loss_rate waypoint2) 1.31)
	(= (power_at_station waypoint2) 35)
	(= (power_capacity waypoint2) 144)
	(at_lander general waypoint2)
	(channel_free general)
	(= (energy rover0) 47)
	(= (energy_capacity rover0) 93)
	(at rover0 waypoint1)
	(available rover0)
	(store_of rover0store rover0)
	(empty rover0store)
	(equipped_for_imaging rover0)
	(can_traverse rover0 waypoint1 waypoint0)
	(can_traverse rover0 waypoint0 waypoint1)
	(can_traverse rover0 waypoint1 waypoint2)
	(can_traverse rover0 waypoint2 waypoint1)
	(on_board camera0 rover0)
	(calibration_target camera0 objective1)
	(supports camera0 colour)
	(supports camera0 low_res)
	(visible_from objective0 waypoint0)
	(visible_from objective0 waypoint1)
	(visible_from objective1 waypoint0)
)

(:goal (and
(communicated_image_data objective0 colour)
	)
)

(:metric minimize (total-time))
)
