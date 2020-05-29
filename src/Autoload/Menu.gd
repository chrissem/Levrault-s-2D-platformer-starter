extends Node

var history := []


func navigate_to(to: String, transition: String = "fade") -> void:
	Events.emit_signal("menu_route_changed", to)
	Events.emit_signal("transition_started", transition)
