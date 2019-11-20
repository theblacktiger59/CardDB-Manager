extends OptionButton
class_name PickModule

var _item_list: Dictionary


func setup(modules: Array) -> void:
	var i: = 0
	for m in modules:
		add_item(m["type"], i)
		_item_list[m["type"]] = i
		i += 1
	text = "ADD"


func pick_option(type: String) -> void:
	var id = _item_list[type] + 1
	emit_signal("item_selected", id)
	