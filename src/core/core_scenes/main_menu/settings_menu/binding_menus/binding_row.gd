extends HBoxContainer

signal rebind_requested(action: StringName)
signal reset_requested(action: StringName)

@onready var action_label: Label = %ActionLabel
@onready var binding_btn: Button = %BindingBtn
@onready var reset_btn: Button = $ResetBtn

var action: StringName
var device_filter: DeviceManager.InputMethod


func _ready() -> void:
	refresh()


func refresh() -> void:
	action_label.text = " ".join(Array(action.split("_")).map(func(w): return w.capitalize()))
	
	var event : InputEvent = InputManager.get_binding_for_device(action, device_filter)
	
	binding_btn.text = event.as_text() if event else "Unbound"
	
	var default_event : InputEvent = _get_default_event()
	var is_default: bool = (event == null and default_event == null) or \
		(event != null and default_event != null and event.is_match(default_event))
	
	reset_btn.disabled = is_default


func set_listening(is_listening: bool) -> void:
	if is_listening:
		binding_btn.text = "Press a key..."
	else:
		var event := InputManager.get_binding_for_device(action, device_filter)
		binding_btn.text = event.as_text() if event else "Unbound"
	reset_btn.disabled = is_listening


func _get_default_event() -> InputEvent:
	var default_events : Array = ProjectSettings.get_setting("input/" + action).get("events", [])
	for event in default_events:
		if DeviceManager.get_input_method_from_event(event) == device_filter:
				return event
	return null


func _on_rebind_btn_pressed() -> void:
	rebind_requested.emit(action)


func _on_reset_btn_pressed() -> void:
	reset_requested.emit(action)
