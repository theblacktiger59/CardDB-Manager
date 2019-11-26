extends HBoxContainer

const ARGHOLDER = preload("res://Widget/ArgWidgets/ArgHolder.tscn")

var _category_key: String # "triggers", "conditions", "t_effects", "f_effects"


func setup(key: String) -> void:
	_category_key = key


func add_arg_holder() -> ArgHolder:
	var new_arg_holder = ARGHOLDER.instance()
	add_child(new_arg_holder)
	new_arg_holder.setup(ModuleList.abi_patterns[_category_key])
	new_arg_holder.connect("module_picked", self, "add_arg_holder")
	new_arg_holder.connect("module_removed", self, "del_arg_holder")
	_reorder_arg_holder()
	_update_names()
	return new_arg_holder


func del_arg_holder() -> void:
	var _last = get_children().back()
	remove_child(_last)
	_reorder_arg_holder()
	_update_names()


func _update_names() -> void:
	for i in range(get_child_count()):
		get_child(i).set_arg_name("[" + String(i) + "]")


func _reorder_arg_holder() -> void:
	for a_h in get_children():
		if a_h._pick_module != null:
			move_child(a_h, get_child_count() - 1)


func set_array(args_list: Array) -> void:
	if args_list.size() == 0:
		add_arg_holder()
	else:
		for arg in args_list:
			set_arg_holder(arg)


func get_array() -> Array:
	var new_args_list: = []
	for a_h in get_children():
		var resolved_arg = a_h.resolve_arg()
		if resolved_arg != null:
			new_args_list.append(a_h.resolve_arg())
	return new_args_list


func set_arg_holder(arg_holder_dict: Dictionary) -> void:
	var arg_holder_to_set: ArgHolder
	if get_child_count() > 0:
		if get_children().back().is_pick():
			arg_holder_to_set = get_children().back()
	else:
		arg_holder_to_set = add_arg_holder()
	
	arg_holder_to_set.set_arg(arg_holder_dict)