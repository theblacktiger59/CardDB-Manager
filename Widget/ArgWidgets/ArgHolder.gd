extends HBoxContainer
class_name ArgHolder

const PICKMODULE = preload("res://Widget/ArgWidgets/PickModule.tscn")
const ARGMODULE = preload("res://Widget/ArgWidgets/ArgModule.tscn")
const ARGSTRING = preload("res://Widget/ArgWidgets/ArgString.tscn")
const ARGNUMBER = preload("res://Widget/ArgWidgets/ArgNumber.tscn")

var _arg_widget: Control
var _pick_module: PickModule

var _arg_signature #Can be an Array of Dict, Array of String, a String, or a Int

signal module_picked()
signal module_removed()


func setup(arg_signature) -> void:
	_arg_signature = arg_signature
	match typeof(_arg_signature):
		TYPE_ARRAY:
			var sub_t = typeof(_arg_signature[0])
			if sub_t == TYPE_DICTIONARY: #Its a list of module
				create_pick_module()
			if sub_t == TYPE_STRING: #Its a list of string
				create_arg_string()

		TYPE_STRING: #Its a keyword : AMOUNT, TRIGGER, etc
			var key = _arg_signature.to_lower()
			setup(ModuleList.abi_patterns[key])

		TYPE_INT, TYPE_REAL: #Its a number
			create_arg_number()


func set_arg_name(arg_n: String) -> void:
	get_node("ArgName").text = arg_n


func get_arg_name() -> String:
	return get_node("ArgName").text


func is_pick() -> bool:
	return _pick_module != null


func create_pick_module() -> void:
	if _arg_widget != null:
		emit_signal("module_removed")
		remove_child(_arg_widget)
		_arg_widget.queue_free()
		_arg_widget = null

	_pick_module = PICKMODULE.instance()
	add_child(_pick_module)
	_pick_module.setup(_arg_signature)
	_pick_module.connect("item_selected", self, "create_arg_module")


func create_arg_module(id: int) -> void:
	if _pick_module != null:
		emit_signal("module_picked")
		remove_child(_pick_module)
		_pick_module.queue_free()
		_pick_module = null
	
	var idx = id - 1
	_arg_widget = ARGMODULE.instance()
	add_child(_arg_widget)
	_arg_widget.setup(_arg_signature[idx])
	_arg_widget.delete_button.connect("button_up", self, "create_pick_module")


func create_arg_string() -> void:
	_arg_widget = ARGSTRING.instance()
	add_child(_arg_widget)
	_arg_widget.setup(_arg_signature)


func create_arg_number() -> void:
	_arg_widget = ARGNUMBER.instance()
	add_child(_arg_widget)


func set_arg(arg) -> void:
	match typeof(arg):
		TYPE_DICTIONARY: #create arg module with dict["type"]
			_pick_module.pick_option(arg["type"])
			_arg_widget.set_arg_module(arg["args"])

		TYPE_STRING: #set arg_string with string
			_arg_widget.set_arg(arg)

		TYPE_INT, TYPE_REAL: #set arg_number with float
			_arg_widget.set_arg(arg)


func resolve_arg():
	if _arg_widget != null:
		return _arg_widget.resolve()