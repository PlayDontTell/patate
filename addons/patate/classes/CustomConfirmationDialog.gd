class_name CustomConfirmationDialog
extends BaseMenu

signal cancel_request
signal confirm_request

@export var statement_key: String
@export var confirm_btn_key: String
@export var cancel_btn_key: String = "COMMON_CANCEL"

@onready var statement_label: Label = %StatementLabel
@onready var confirm_btn: Button = %ConfirmBtn
@onready var cancel_btn: Button = %CancelBtn

var format_dict: Dictionary = {}
var _focus_to_restore: Control = null


func _ready() -> void:
	activated.connect(_on_dialog_activated)
	deactivated.connect(_on_dialog_deactivated)
	refresh()
	super._ready()


func set_format_dict(new_format_dict : Dictionary) -> void:
	if not new_format_dict.is_empty():
		format_dict = new_format_dict.duplicate(true)
		refresh()


func refresh() -> void:
	LocaleManager.bind_translation(statement_label, statement_key, format_dict)
	confirm_btn.set_text(confirm_btn_key)
	cancel_btn.set_text(cancel_btn_key)


func _on_cancel_btn_pressed() -> void:
	deactivate()
	cancel_request.emit()


func _on_confirm_btn_pressed() -> void:
	deactivate()
	confirm_request.emit()


func _on_dialog_activated() -> void:
	_focus_to_restore = get_viewport().gui_get_focus_owner()
	grab_default_focus()


func _on_dialog_deactivated() -> void:
	if is_instance_valid(_focus_to_restore):
		_focus_to_restore.grab_focus()
	else:
		var node := get_parent()
		while node:
			if node is BaseMenu:
				(node as BaseMenu).grab_default_focus()
				break
			node = node.get_parent()
	_focus_to_restore = null
