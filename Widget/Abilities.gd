extends Control

onready var _tabs = get_node("MarginContainer/TabContainer")
onready var _popup = get_node("WindowDialog")
onready var _confirm = get_node("ConfirmationDialog")

const ABILITY_W = preload("res://Widget/Ability.tscn")
const EMPTY_ABI = {"conditions":[], "f_effects":[], "t_effects":[], "triggers":[]}


func _ready() -> void:
	_tabs.connect("tab_selected", self, "_on_tab_selected")
	_tabs.set_popup(_popup)
	_popup.get_node("MarginContainer/VBoxContainer/ButtonAdd").connect("button_up", self, "_add_ability")
	_popup.get_node("MarginContainer/VBoxContainer/ButtonDelete").connect("button_up", self, "_delete_confirmation")
	_confirm.connect("confirmed", self, "_delete_ability")


func set_abilities(abilities: Array) -> void:
	for abi in _tabs.get_children():
		_tabs.remove_child(abi)
		abi.queue_free()
	for abi in abilities:
		var ability_w = _create_ability()
		ability_w.set_ability(abi)


func get_abilities() -> Array:
	var abilities: = []
	for abi in _tabs.get_children():
		abilities.append(abi.get_ability())
	return abilities


func _add_ability() -> void:
	_popup.hide()
	var ability_w = _create_ability()
	ability_w.set_ability(EMPTY_ABI)


func _create_ability() -> Node:
	var ability_w = ABILITY_W.instance()
	var abi_name = "[" + String(_tabs.get_child_count()) + "]"
	ability_w.name = abi_name
	_tabs.add_child(ability_w)
	return ability_w


func _delete_ability() -> void:
	_tabs.remove_child(_tabs.get_current_tab_control())


func _delete_confirmation() -> void:
	_popup.hide()
	_confirm.popup()


func _on_tab_selected(tab: int) -> void:
	pass
