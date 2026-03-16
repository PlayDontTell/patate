extends BaseMenu

signal back_requested
signal slot_creation_confirmed(
	slot_name: String,
)

@onready var save_slot_name_input: LineEdit = %SaveSlotNameInput
@onready var save_slot_create_btn: AnimatedButton = %SaveSlotCreateBtn


func _ready() -> void:
	_on_save_slot_name_input_text_changed()
	super._ready()


func _on_back_btn_pressed() -> void:
	back_requested.emit()


func _on_save_slot_create_btn_pressed() -> void:
	_handle_save_slot_create()


func _on_save_slot_name_input_text_changed(new_text: String = save_slot_name_input.text) -> void:
	var caret_column = save_slot_name_input.caret_column
	
	save_slot_name_input.text = Utils.sanitize_string(new_text)
	
	save_slot_name_input.caret_column = caret_column
	
	var is_name_empty : bool = new_text == ""
	save_slot_create_btn.disabled = is_name_empty


func _on_save_slot_name_input_text_submitted(_new_text: String) -> void:
	_handle_save_slot_create()


func _handle_save_slot_create() -> void:
	slot_creation_confirmed.emit(
		save_slot_name_input.text.strip_edges()
	)
