extends VBoxContainer

const BINDING_ROW = preload("uid://46qikc2s4pbi")

@export var device_filter : DeviceManager.InputMethod


func _ready() -> void:
	update()


func _input(event: InputEvent) -> void:
	pass


func update() -> void:
	for binding_row in self.get_children():
		binding_row.queue_free()
	
	var actions : Array = InputManager.get_context_actions(
		InputManager.Context.GAMEPLAY, true
	)
	
	for action in actions:
		var new_binding_row : Control = BINDING_ROW.instantiate()
		new_binding_row.action = action
		new_binding_row.device_filter = device_filter
		new_binding_row.rebind_requested.connect(_on_rebind_requested)
		new_binding_row.reset_requested.connect(_on_reset_requested)

		self.add_child(new_binding_row)


func _on_rebind_requested(action: StringName) -> void:
	pass


func _on_reset_requested(action: StringName) -> void:
	pass
