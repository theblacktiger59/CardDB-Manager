extends Node
#class_name ModuleList

var empty_card_template: = {
	"empty": {
		"abilities": [
			{
				"conditions": [],
				"f_effects": [],
				"t_effects": [],
				"triggers": []
			}
		],
		"attributes": {
			"color": "3d3d3d",
			"cost": 0,
			"description": "",
			"image": "none.png",
			"name": "",
			"playable": true,
			"type": "tile",
			"type_attributes": {
				"pickable": false,
				"triggerlimit": 0,
				"turnlimit": 0
			}
		}
	}
}
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
