extends TypeAttributes


func set_type_attributes(type_att: Dictionary) -> void:
	find_node("PickableCheckBox").pressed = type_att["pickable"]
	find_node("TurnlimitSpinBox").value = type_att["turnlimit"]
	find_node("TriggerlimitSpinBox").value = type_att["triggerlimit"]


func get_type_attributes() -> Dictionary:
	var type_att: = {}
	type_att["pickable"] = find_node("PickableCheckBox").pressed
	type_att["turnlimit"] = find_node("TurnlimitSpinBox").value
	type_att["triggerlimit"] = find_node("TriggerlimitSpinBox").value
	return type_att