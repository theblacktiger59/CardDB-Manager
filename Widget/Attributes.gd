extends VBoxContainer

onready var _name_w = find_node("NameEdit")
onready var _description_w = find_node("DescriptionEdit")
onready var _type_w = find_node("TypeOptionButton")
onready var _playable_w = find_node("PlayableCheckButton")
onready var _color_w = find_node("ColorPickerButton")
onready var _cost_w = find_node("CostSpinBox")
onready var _image_w = find_node("ImageEdit")

var _card_attributes: = {}
var _type_attributes_w: Control

const TILE_TYPE = preload("res://Widget/TypeAttributes/TileTypeAtt.tscn")
const EFFECT_TYPE = preload("res://Widget/TypeAttributes/EffectTypeAtt.tscn")
const MODIFIER_TYPE = preload("res://Widget/TypeAttributes/ModifierTypeAtt.tscn")


func _ready() -> void:
	_type_w.connect("item_selected", self, "_change_type_attribute")
	_change_type_attribute(0)
	

func set_attributes(att: Dictionary) -> void:
	_card_attributes = att.duplicate(true)
	_name_w.text = _card_attributes["name"]
	_description_w.text = _card_attributes["description"]
	_type_w.select(_type_to_index(_card_attributes["type"]))
	_change_type_attribute(_type_to_index(_card_attributes["type"]))
	_playable_w.pressed = _card_attributes["playable"]
	_color_w.color = _card_attributes["color"]
	_cost_w.value = _card_attributes["cost"]
	_image_w.text = _card_attributes["image"]
	_type_attributes_w.set_type_attributes(_card_attributes["type_attributes"])


func get_attributes() -> Dictionary:
	_card_attributes["name"] = _name_w.text
	_card_attributes["description"] = _description_w.text
	_card_attributes["type"] = _type_w.get_item_text(_type_w.get_selected_id())
	_card_attributes["playable"] = _playable_w.pressed
	_card_attributes["color"] = _color_w.color.to_html(false)
	_card_attributes["cost"] = _cost_w.value
	_card_attributes["image"] = _image_w.text
	_card_attributes["type_attributes"] = _type_attributes_w.get_type_attributes()
	return _card_attributes


func _change_type_attribute(idx: int) -> void:
	if _type_attributes_w != null:
		_type_attributes_w.queue_free()
		_type_attributes_w = null
	match idx:
		0: _type_attributes_w = TILE_TYPE.instance()
		1: _type_attributes_w = EFFECT_TYPE.instance()
		2: _type_attributes_w = MODIFIER_TYPE.instance()
	find_node("TypeAttContainer").add_child(_type_attributes_w)


func _type_to_index(type: String) -> int:
	for i in range(_type_w.get_item_count()):
		if _type_w.get_item_text(i) == type:
			return i
	return -1