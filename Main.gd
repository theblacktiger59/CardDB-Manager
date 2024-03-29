extends Control

onready var toolbar = find_node("Toolbar")
onready var card_list = find_node("CardList")
onready var attribute_editor = find_node("Attributes")
onready var ability_editor = find_node("Abilities")
onready var cardid_popup = find_node("CardIdPopup")
onready var file_dialog = find_node("JsonFileDialog")

var json_patch: String = "" # The card database file patch

var cards_db: = {} # The card database
var selected_card_id: String

var set_list: = {}

signal reload_app()


func _ready() -> void:
	card_list.connect("item_selected", self, "_card_selected")
	find_node("RefreshButton").connect("button_up", self, "_refresh_card_list")
	find_node("NewCardButton").connect("button_up", self, "_create_new_card")
	find_node("DuplicateButton").connect("button_up", self, "_duplicate_card")
	find_node("DeleteButton").connect("button_up", self, "_delete_card")
	toolbar.get_node("OpenButton").connect("button_up", self, "_open_file_dialog")
	toolbar.get_node("SaveToButton").connect("button_up", self, "_save_file_dialog")
	toolbar.get_node("SaveButton").connect("button_up", self, "_save_file_no_dialog")
	toolbar.get_node("ReloadButton").connect("button_up", self, "_reload_app")
	cardid_popup.connect("about_to_show", self, "_set_cardid_popup")
	
	connect("reload_app", ModuleList, "force_reload")


func _open_file_dialog() -> void:
	file_dialog.mode = FileDialog.MODE_OPEN_FILE
	file_dialog.popup()
	json_patch = yield(file_dialog, "file_selected")
	toolbar.get_node("LoadedFile").set("text", json_patch)
	_load_cards_db()
	_refresh_card_list()


func _save_file_dialog() -> void:
	file_dialog.mode = FileDialog.MODE_SAVE_FILE
	file_dialog.popup()
	json_patch = yield(file_dialog, "file_selected")
	toolbar.get_node("LoadedFile").set("text", json_patch)
	_save_cards_db()


func _save_file_no_dialog() -> void:
	if json_patch == "":
		_save_file_dialog()
	else:
		_save_cards_db()


func _load_cards_db() -> void:
	var file = File.new()
	file.open(json_patch, File.READ)
	var cards_json = file.get_as_text()
	file.close()
	cards_db = JSON.parse(cards_json).result


func _save_cards_db() -> void:
	_save_selected_card()
	var file = File.new()
	file.open(json_patch, File.WRITE)
	file.store_line(to_json(cards_db))
	file.close()


func _fill_card_list() -> void:
	for card_id in cards_db:
		register_card_id(card_id)
		var card_list_name: String = card_id + " - " + cards_db[card_id]["attributes"]["name"]
		card_list.add_item(card_list_name)


func register_card_id(card_id: String) -> void:
	var separator_idx = card_id.find("_")
	var card_set_name = card_id.left(separator_idx)
	var card_card_id = card_id.right(separator_idx + 1)
	if not set_list.has(card_set_name):
		set_list[card_set_name] = []
	if not set_list[card_set_name].has(card_card_id):
		set_list[card_set_name].append(card_card_id)


func _refresh_card_list() -> void:
	card_list.clear()
	_fill_card_list()


func _card_selected(index: int) -> void:
	_save_selected_card()
	selected_card_id = cards_db.keys()[index]
	attribute_editor.set_attributes(cards_db[selected_card_id]["attributes"])
	ability_editor.set_abilities(cards_db[selected_card_id]["abilities"])


func _save_selected_card() -> void:
	if selected_card_id != "":
		cards_db[selected_card_id]["attributes"] = attribute_editor.get_attributes()
		cards_db[selected_card_id]["abilities"] = ability_editor.get_abilities()


func _create_new_card() -> void:
	cardid_popup.popup()
	var card_id = yield(cardid_popup, "card_id_picked")
	if card_id != "cancel":
		register_card_id(card_id)
		cards_db[card_id] = ModuleList.empty_card_template["empty"].duplicate(true)
		_refresh_card_list()


func _duplicate_card() -> void:
	if selected_card_id != "":
		cardid_popup.popup()
		var card_id = yield(cardid_popup, "card_id_picked")
		if card_id != "cancel":
			register_card_id(card_id)
			cards_db[card_id] = cards_db[selected_card_id].duplicate(true)
			_refresh_card_list()


func _delete_card() -> void:
	if selected_card_id != "":
		cards_db.erase(selected_card_id)
		selected_card_id = ""
		_refresh_card_list()


func _set_cardid_popup() -> void:
	cardid_popup.setup(set_list)


func _reload_app() -> void:
	get_tree().reload_current_scene()
	emit_signal("reload_app")
