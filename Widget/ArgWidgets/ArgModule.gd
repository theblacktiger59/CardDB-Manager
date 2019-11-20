extends Control
class_name ArgModule

const ARGHOLDERPATH: = "res://Widget/ArgWidgets/ArgHolder.tscn"

onready var _module_name: = get_node("ModuleRows/TitleBar/Label")
onready var _arg_holders: = get_node("ModuleRows/ArgHolderRow")
onready var delete_button = get_node("ModuleRows/TitleBar/DeleteButton")


func setup(module_ref: Dictionary) -> void:
	_module_name.text = module_ref["type"]
	for arg in module_ref["args"]:
		var new_arg_holder = load(ARGHOLDERPATH).instance()
		_arg_holders.add_child(new_arg_holder)
		new_arg_holder.setup(module_ref["args"][arg])
		new_arg_holder.set_arg_name(arg)


func set_arg_module(args: Dictionary) -> void:
	for a_h in _arg_holders.get_children():
		a_h.set_arg(args[a_h.get_arg_name()])
		
		
func resolve() -> Dictionary:
	var resolved: = {}
	resolved["args"] = {}
	for a_h in _arg_holders.get_children():
		resolved["args"][a_h.get_arg_name()] = a_h.resolve_arg()
	resolved["type"] = _module_name.text
	return resolved
