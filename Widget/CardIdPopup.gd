extends WindowDialog


onready var set = find_node("Set")
onready var set_list_button = find_node("SetListButton")
onready var id = find_node("Id")
onready var id_next_button = find_node("IdNextButton")
onready var valid = find_node("ValidButton")
onready var cancel = find_node("CancelButton")


var _set_list: = {}

signal card_id_picked()


func _ready() -> void:
	set_list_button.connect("item_selected", self, "_set_name_selected")
	id_next_button.connect("button_up", self, "_set_next_id")
	valid.connect("button_up", self, "_on_valid")
	cancel.connect("button_up", self, "_on_cancel")


func setup(set_list: Dictionary) -> void:
	_set_list = set_list
	set_list_button.clear()
	for set_name in _set_list:
		set_list_button.add_item(set_name)
	_set_name_selected(0)


func _set_name_selected(id: int) -> void:
	set.text = set_list_button.get_item_text(id)


func _set_next_id() -> void:
	id.text = _find_next_valid_id()


func _on_valid() -> void:
	if id.text == "":
		_set_next_id()
	var picked_id: String = set.text + "_" + id.text
	emit_signal("card_id_picked", picked_id)
	hide()


func _on_cancel() -> void:
	emit_signal("card_id_picked", "cancel")
	hide()


func _find_next_valid_id() -> String:
	var next_id: = "000"
	if _set_list.has(set.text):
		var last_id = _set_list[set.text].back().to_int()
		next_id = String(last_id + 1)
		while next_id.length() < 3:
			next_id = "0" + next_id
	return next_id