extends ScrollContainer

const ARGARRAY = preload("res://Widget/ArgArray.tscn")

var _trigger_list: = {} #dict of "trigger_name" and CheckBox instance

onready var trigger_w = get_node("VBoxContainer/TriggerRow/PanelContainer/GridContainer")
onready var condition_array = ARGARRAY.instance()
onready var t_effect_array = ARGARRAY.instance()
onready var f_effect_array = ARGARRAY.instance()

onready var condition_row = get_node("VBoxContainer/ConditionRow/PanelContainer")
onready var t_effect_row = get_node("VBoxContainer/TrueEffectRow/PanelContainer")
onready var f_effect_row = get_node("VBoxContainer/FalseEffectRow/PanelContainer")


func _ready() -> void:
	_spawn_trigger_list()
	_spawn_modules_lists()


func _spawn_trigger_list() -> void:
	for trigger in ModuleList.abi_patterns["triggers"]:
		var check_w = CheckBox.new()
		check_w.text = trigger
		check_w.set("rect_min_size", Vector2(140, 0))
		trigger_w.add_child(check_w)
		_trigger_list[trigger] = check_w


func _spawn_modules_lists() -> void:
	condition_row.add_child(condition_array)
	condition_array.setup("conditions")
	
	t_effect_row.add_child(t_effect_array)
	t_effect_array.setup("effects")
	
	f_effect_row.add_child(f_effect_array)
	f_effect_array.setup("effects")


func set_ability(abi: Dictionary) -> void: #load selected card ability to widget
	if abi["triggers"] != []:
		for t in abi["triggers"]:
			(_trigger_list[t] as CheckBox).pressed = true
	
	condition_array.set_array(abi["conditions"])
	t_effect_array.set_array(abi["t_effects"])
	f_effect_array.set_array(abi["f_effects"])

	
func get_ability() -> Dictionary: #save selected card ability to database
	var ability: = {}

	var triggers: = []
	for t in _trigger_list:
		if _trigger_list[t].pressed == true:
			triggers.append(t)
	ability["triggers"] = triggers

	ability["conditions"] = condition_array.get_array()
	ability["t_effects"] = t_effect_array.get_array()
	ability["f_effects"] = f_effect_array.get_array()

	return ability
