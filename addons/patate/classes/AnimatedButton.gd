@tool
class_name AnimatedButton
extends Button

@export var config : AnimatedButtonConfig

var _tween : Tween


func _ready() -> void:
	_center_pivot()
	
	focus_entered.connect(_on_focused)
	focus_exited.connect(_on_unfocused)
	mouse_entered.connect(_on_focused)
	mouse_exited.connect(_on_unfocused)
	resized.connect(_center_pivot)


func _center_pivot() -> void:
	pivot_offset = size / 2.0


func _on_focused() -> void:
	if not config or disabled:
		return
	_animate(config.focus_margins, config.focus_max_scale, config.focus_duration, config.focus_ease, config.focus_trans)


func _on_unfocused() -> void:
	if not config or disabled:
		return
	_animate(0., 1., config.unfocus_duration, config.unfocus_ease, config.unfocus_trans)


func _animate(margins : float, max_scale : float, duration : float, ease_type : Tween.EaseType, trans_type : Tween.TransitionType) -> void:
	if is_instance_valid(_tween):
		_tween.kill()
	
	var new_scale : Vector2 = Vector2.ONE * min(
		(self.size.x + margins * 2.) / self.size.x,
		max_scale,
	)
	
	_tween = create_tween()
	_tween.tween_property(
		self,
		"scale",
		new_scale,
		duration
	).set_ease(ease_type).set_trans(trans_type)
