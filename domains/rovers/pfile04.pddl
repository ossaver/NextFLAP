(define (problem roverprob0) (:domain Rover)
(:objects
	general - Lander
	colour high_res low_res - Mode
	rover0 - Rover
	rover0store - Store
	waypoint0 waypoint1 waypoint2 - Waypoint
	camera0 camera1 - Camera
	objective0 objective1 - Objective
	)
(:init
	(visible waypoint0 waypoint2)
	(visible waypoint2 waypoint0)
	(visible waypoint1 waypoint0)
	(visible waypoint0 waypoint1)
	(visible waypoint2 waypoint1)
	(visible waypoint1 waypoint2)
	(at_rock_sample waypoint0)
	(= (power_loss_rate waypoint0) 1.01)
	(= (power_at_station waypoint0) 17)
	(= (power_capacity waypoint0) 180)
	(at_soil_sample waypoint1)
	(at_rock_sample waypoint1)
	(= (power_loss_rate waypoint1) 1.41)
	(= (power_at_station waypoint1) 10)
	(= (power_capacity waypoint1) 192)
	(= (power_loss_rate waypoint2) 1.4)
	(= (power_at_station waypoint2) 55)
	(= (power_capacity waypoint2) 117)
	(at_lander general waypoint1)
	(channel_free general)
	(= (energy rover0) 41)
	(= (energy_capacity rover0) 94)
	(at rover0 waypoint0)
	(available rover0)
	(store_of rover0store rover0)
	(empty rover0store)
	(equipped_for_rock_analysis rover0)
	(equipped_for_imaging rover0)
	(can_traverse rover0 waypoint0 waypoint1)
	(can_traverse rover0 waypoint1 waypoint0)
	(on_board camera0 rover0)
	(calibration_target camera0 objective1)
	(supports camera0 colour)
	(supports camera0 low_res)
	(on_board camera1 rover0)
	(calibration_target camera1 objective0)
	(supports camera1 colour)
	(supports camera1 high_res)
	(visible_from objective0 waypoint0)
	(visible_from objective1 waypoint0)
	(visible_from objective1 waypoint1)
	(visible_from objective1 waypoint2)
)

(:goal (and
(communicated_rock_data waypoint1)
(communicated_image_data objective1 high_res)
(communicated_image_data objective1 colour)
	)
)

(:metric minimize (total-time))
)
