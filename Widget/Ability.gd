extends ScrollContainer

const ARGARRAY = preload("res://Widget/ArgArray.tscn")

var _trigger_list: = {} #dict of "trigger_name" and CheckBox instance

onready var trigger_array = ARGARRAY.instance()
onready var condition_array = ARGARRAY.instance()
onready var t_effect_array = ARGARRAY.instance()
onready var f_effect_array = ARGARRAY.instance()

onready var trigger_row = get_node("VBoxContainer/TriggerRow/PanelContainer/")
onready var condition_row = get_node("VBoxContainer/ConditionRow/PanelContainer")
onready var t_effect_row = get_node("VBoxContainer/TrueEffectRow/PanelContainer")
onready var f_effect_row = get_node("VBoxContainer/FalseEffectRow/PanelContainer")


func _ready() -> void:
	_spawn_modules_lists()


func _spawn_modules_lists() -> void:
	trigger_row.add_child(trigger_array)
	trigger_array.setup("triggers")
	
	condition_row.add_child(condition_array)
	condition_array.setup("conditions")
	
	t_effect_row.add_child(t_effect_array)
	t_effect_array.setup("effects")
	
	f_effect_row.add_child(f_effect_array)
	f_effect_array.setup("effects")


func set_ability(abi: Dictionary) -> void: #load selected card ability to widget
	trigger_array.set_array(abi["triggers"])
	condition_array.set_array(abi["conditions"])
	t_effect_array.set_array(abi["t_effects"])
	f_effect_array.set_array(abi["f_effects"])

	
func get_ability() -> Dictionary: #save selected card ability to database
	var ability: = {}
	ability["triggers"] = trigger_array.get_array()
	ability["conditions"] = condition_array.get_array()
	ability["t_effects"] = t_effect_array.get_array()
	ability["f_effects"] = f_effect_array.get_array()

	return ability
