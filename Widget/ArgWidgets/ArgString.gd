extends OptionButton
class_name ArgString

var _option_list: Dictionary


func setup(options: Array) -> void:
	var i: = 0
	for o in options:
		add_item(o, i)
		_option_list[o] = i
		i += 1


func set_arg(option: String) -> void:
	var id = _option_list[option]
	select(id)


func resolve() -> String:
	return get_item_text(get_selected())