extends TypeAttributes


func set_type_attributes(type_att: Dictionary) -> void:
	find_node("InvisibleCheckBox").pressed = type_att["invisible"]
	find_node("SecretCheckBox").pressed = type_att["secret"]
	
	var subtype_idx: int
	match type_att["subtype"]:
		"tile": subtype_idx = 0
		"player": subtype_idx = 1
	
	find_node("SubtypeOptionButton").select(subtype_idx)
	find_node("TurnlimitSpinBox").value = type_att["turnlimit"]
	find_node("TriggerlimitSpinBox").value = type_att["triggerlimit"]


func get_type_attributes() -> Dictionary:
	var type_att: = {}
	type_att["invisible"] = find_node("InvisibleCheckBox").pressed
	type_att["secret"] = find_node("SecretCheckBox").pressed
	
	var subtype_id = find_node("SubtypeOptionButton").get_selected_id()
	
	type_att["subtype"] = find_node("SubtypeOptionButton").get_item_text(subtype_id)
	type_att["turnlimit"] = find_node("TurnlimitSpinBox").value
	type_att["triggerlimit"] = find_node("TriggerlimitSpinBox").value
	return type_att