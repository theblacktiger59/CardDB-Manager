extends Node
#class_name ModuleList


var abi_patterns: = {}
var att_patterns: = {}


func _ready() -> void:
	_load_abi_patterns()
	_load_att_patterns()


func _load_abi_patterns() -> void:
	var file = File.new()
	file.open("res://Patterns/abi_patterns.json", File.READ)
	var abi_patterns_json = file.get_as_text()
	file.close()
	abi_patterns = JSON.parse(abi_patterns_json).result


func _load_att_patterns() -> void:
	var file = File.new()
	file.open("res://Patterns/att_patterns.json", File.READ)
	var att_patterns_json = file.get_as_text()
	file.close()
	att_patterns = JSON.parse(att_patterns_json).result


func force_reload() -> void:
	_ready()
