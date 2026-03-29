## Can be used in DEV and EXPO build profiles
extends CanvasLayer

@onready var help_panel: Control = %HelpPanel
@onready var help_label: Label = %HelpLabel
@onready var bug_report_panel: Control = %BugReportPanel

@onready var btn_container: MarginContainer = %BtnContainer
@onready var placement: Control = %Placement
@onready var debug_panel: MarginContainer = %DebugPanel
@onready var frame_btns: HBoxContainer = %FrameBtns
@onready var debug_window: VBoxContainer = %DebugWindow

@onready var tab_1: Button = %Tab1
@onready var tab_2: Button = %Tab2
@onready var tab_3: Button = %Tab3
@onready var tab_4: Button = %Tab4
@onready var tab_5: Button = %Tab5

@onready var collapse_expand_btn: Button = %CollapseExpandBtn
@onready var debug_btns: HBoxContainer = %DebugBtns
@onready var position_btns: GridContainer = %PositionBtns
@onready var debug_container: Control = %DebugContainer

# Time
@onready var date_value: Label = %DateValue
@onready var fps_value: Label = %FPSValue
@onready var real_time_value: Label = %RealTimeValue
@onready var time_since_start_value: Label = %TimeSinceStartValue
@onready var time_played_value: Label = %TimePlayedValue
@onready var time_paused_value: Label = %timePausedValue
@onready var process_delta_value: Label = %ProcessDeltaValue
@onready var physics_delta_value: Label = %PhysicsDeltaValue
@onready var time_scale_value: Label = %TimeScaleValue
@onready var time_scale_slider: HSlider = %TimeScaleSlider
@onready var audio_latency_value: Label = %AudioLatencyValue

# Costs
@onready var memory_usage_value: Label = %MemoryUsageValue
@onready var buffer_value: Label = %BufferValue
@onready var node_count_value: Label = %NodeCountValue
@onready var tween_count_value: Label = %TweenCountValue
@onready var orphan_node_count_value: Label = %OrphanNodeCountValue
@onready var resource_count_value: Label = %ResourceCountValue
@onready var draw_calls_value: Label = %DrawCallsValue
@onready var vram_usage_value: Label = %VRAMUsageValue
@onready var texture_memory_value: Label = %TextureMemoryValue
@onready var primitives_value: Label = %PrimitivesValue
@onready var physics_2d_objects_value: Label = %Physics2DObjectsValue
@onready var physics_3d_objects_value: Label = %Physics3DObjectsValue

# Machine
@onready var machine_value: Label = %MachineValue
@onready var os_value: Label = %OSValue
@onready var os_version_value: Label = %OSVersionValue
@onready var gpu_name_value: Label = %GPUNameValue
@onready var cpu_name_value: Label = %CPUNameValue
@onready var cpu_cores_value: Label = %CPUCoresValue
@onready var display_scale_value: Label = %DisplayScaleValue
@onready var window_scale_value: Label = %WindowScaleValue
@onready var window_mode_value: Label = %WindowModeValue
@onready var window_count_value: Label = %WindowCountValue
@onready var window_size_value: Label = %WindowSizeValue
@onready var visible_viewport_size_value: Label = %VisibleViewportSizeValue
@onready var viewport_size_value: Label = %ViewportSizeValue
@onready var content_scale_value: Label = %ContentScaleValue

# Game State
@onready var build_profile_value: Label = %BuildProfileValue
@onready var version_value: Label = %VersionValue
@onready var locale_value: Label = %LocaleValue
@onready var core_scene_value: Label = %CoreSceneValue

# Input/Output
@onready var mouse_position_value: Label = %MousePositionValue

# Pause
@onready var pause_requests_value: Label = %PauseRequestsValue
@onready var pause_value: Label = %PauseValue
@onready var pause_resume_btn: Button = %PauseResumeBtn

@export var bug_categories: PackedStringArray = [
	"Gameplay",
	"UI",
	"Audio",
	"Visual",
	"Crash",
	"Other"
]
@export var expanded_on_start: bool = false

enum StartPosition {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
}
@export var position_on_start: StartPosition

@export var info_refresh_period: float = 1.

enum Tab {
	TIME = 1,
	COSTS = 2,
	MACHINE = 4,
	GAME_STATE = 8,
	INPUT_OUTPUT = 16,
}
@export_flags(
	"Time:1",
	"Costs:2",
	"Machine:4",
	"Game State:8",
	"Input/Output:16"
) var active_tabs_on_start = 63


var info_refresh_timer: Timer
var _last_process_delta: float = 0.0
var _last_physics_delta: float = 0.0

func _ready() -> void:
	help_panel.hide()
	G.new_core_scene_loaded.connect(set_core_scene_label)
	LocaleManager.locale_changed.connect(set_locale_label)
	PauseManager.pause_state_changed.connect(set_pause_label)
	init()


func _exit_tree() -> void:
	G.new_core_scene_loaded.disconnect(set_core_scene_label)
	LocaleManager.locale_changed.disconnect(set_locale_label)
	PauseManager.pause_state_changed.disconnect(set_pause_label)


func _process(delta: float) -> void:
	_last_process_delta = delta
	set_fps_label()
	set_real_time_label()
	set_time_since_start_label()
	set_time_played_label()
	set_time_paused_label()
	set_process_delta_label(delta)

	var hovered := get_viewport().gui_get_hovered_control()
	if hovered:
		var text := _get_help_text(hovered)
		help_label.text = text
		help_label.modulate.a = 0.8 if not text.is_empty() else 0.


func _physics_process(delta: float) -> void:
	_last_physics_delta = delta
	set_physics_delta_label(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag or event is InputEventMouseMotion:
		set_mouse_position_label(event.position)
	
	if InputManager.just_pressed_event("toggle_Debug_layer", event):
		display_debug_layer()
	
	help_panel.visible = InputManager.pressed("toggle_Help") or mouse_on_help_spot
	
	if InputManager.just_pressed_event("Take_Marketing_Screenshot", event):
		take_marketing_screenshots(true)
	
	if InputManager.just_pressed_event("Report_Bug", event):
		bug_report_panel._on_bug_btn_pressed()


func _get_help_text(node: Node) -> String:
	var current := node
	while current and current != debug_panel:
		if current.has_meta("help"):
			return current.get_meta("help")
		current = current.get_parent()
	return ""


func init() -> void:
	if not G.config.release_mode in [G.ReleaseMode.DEV, G.ReleaseMode.EXPO]:
		self.queue_free()
		return

	self.visible = G.is_dev()

	set_core_scene_label()
	set_locale_label()
	set_version_label()
	set_build_profile_label()
	set_pause_label()

	collapse_expand_btn.button_pressed = expanded_on_start
	_on_collapse_expand_btn_toggled(collapse_expand_btn.button_pressed)
	_on_pause_resume_btn_toggled(pause_resume_btn.button_pressed)
	_on_time_scale_slider_value_changed()

	refresh_stats()

	if info_refresh_timer == null:
		info_refresh_timer = Timer.new()
		info_refresh_timer.autostart = true
		info_refresh_timer.wait_time = info_refresh_period
		info_refresh_timer.ignore_time_scale = true
		info_refresh_timer.one_shot = false
		info_refresh_timer.timeout.connect(refresh_stats)
		self.add_child(info_refresh_timer)

	await get_tree().process_frame
	match position_on_start:
		StartPosition.TOP_LEFT: _on_nw_pressed()
		StartPosition.TOP_RIGHT: _on_ne_pressed()
		StartPosition.BOTTOM_LEFT: _on_sw_pressed()
		StartPosition.BOTTOM_RIGHT: _on_se_pressed()

	# Static machine info — set once
	machine_value.set_text(str(OS.get_model_name()))
	os_value.set_text(str(OS.get_name()))
	os_version_value.set_text(str(OS.get_version()))
	set_gpu_name_label()
	set_cpu_name_label()
	set_cpu_cores_label()
	viewport_size_value.set_text(stringify_vector2(Vector2i(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"),
	)))

	tab_1.toggle(bool(active_tabs_on_start & Tab.TIME))
	tab_2.toggle(bool(active_tabs_on_start & Tab.COSTS))
	tab_3.toggle(bool(active_tabs_on_start & Tab.MACHINE))
	tab_4.toggle(bool(active_tabs_on_start & Tab.GAME_STATE))
	tab_5.toggle(bool(active_tabs_on_start & Tab.INPUT_OUTPUT))


func display_debug_layer() -> void:
	placement.visible = not placement.visible


# — Helpers —

func _set_count_label(label: Label, value: int) -> void:
	label.set_text(str(value))
	label.get_parent().modulate.a = 0.4 if value == 0 else 1.0


func stringify_vector2(vector2i: Vector2i) -> String:
	return "(" + str(vector2i.x).lpad(4) + ", " + str(vector2i.y).lpad(4) + ")"


# — Time —

func set_fps_label() -> void:
	fps_value.set_text(str(Engine.get_frames_per_second()))


func set_date_value() -> void:
	date_value.set_text(Time.get_datetime_string_from_system().replace("T", " "))


func set_time_since_start_label() -> void:
	if SaveManager.save_data:
		time_since_start_value.set_text(str(Utils.round_to_dec(SaveManager.save_data.time_since_start, 1)) + " s")


func set_real_time_label() -> void:
	if SaveManager.save_data:
		real_time_value.set_text(str(Utils.round_to_dec(Time.get_ticks_msec() / 1000.0, 1)) + " s")


func set_time_played_label() -> void:
	if SaveManager.save_data:
		time_played_value.set_text(str(Utils.round_to_dec(SaveManager.save_data.time_played, 1)) + " s")


func set_time_paused_label() -> void:
	if SaveManager.save_data:
		time_paused_value.set_text(str(Utils.round_to_dec(
		SaveManager.save_data.time_since_start - SaveManager.save_data.time_played,
		1)) + " s")


func set_process_delta_label(delta: float = 99.) -> void:
	process_delta_value.set_text(str(Utils.round_to_dec(delta * 1000., 2)) + " ms")


func set_physics_delta_label(delta: float = 99.) -> void:
	physics_delta_value.set_text(str(Utils.round_to_dec(delta * 1000., 2)) + " ms")


func set_audio_latency_label() -> void:
	audio_latency_value.set_text(
		"%.2f ms" % (Performance.get_monitor(Performance.AUDIO_OUTPUT_LATENCY) * 1000.0)
	)


# — Costs —

func set_memory_usage_label() -> void:
	memory_usage_value.set_text(
		"%.2f MB" % (Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0)
	)


func set_buffer_label() -> void:
	buffer_value.set_text(
		"%.2f MB" % (Performance.get_monitor(Performance.RENDER_BUFFER_MEM_USED) / 1048576.0)
	)


func set_node_count_label() -> void:
	_set_count_label(node_count_value, get_tree().get_node_count())


func set_tween_count_label() -> void:
	_set_count_label(tween_count_value, get_tree().get_processed_tweens().size())


func set_orphan_node_count_label() -> void:
	_set_count_label(orphan_node_count_value, int(Performance.get_monitor(Performance.OBJECT_ORPHAN_NODE_COUNT)))


func set_resource_count_label() -> void:
	_set_count_label(resource_count_value, int(Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)))


func set_draw_calls_label() -> void:
	draw_calls_value.set_text(str(int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))))


func set_vram_usage_label() -> void:
	vram_usage_value.set_text(
		"%.2f MB" % (Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0)
	)


func set_texture_memory_label() -> void:
	texture_memory_value.set_text(
		"%.2f MB" % (Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED) / 1048576.0)
	)


func set_primitives_label() -> void:
	primitives_value.set_text(str(int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME))))


func set_physics_2d_objects_label() -> void:
	_set_count_label(physics_2d_objects_value, int(Performance.get_monitor(Performance.PHYSICS_2D_ACTIVE_OBJECTS)))


func set_physics_3d_objects_label() -> void:
	_set_count_label(physics_3d_objects_value, int(Performance.get_monitor(Performance.PHYSICS_3D_ACTIVE_OBJECTS)))


# — Machine —

func set_gpu_name_label() -> void:
	var rd := RenderingServer.get_rendering_device()
	gpu_name_value.set_text(rd.get_device_name() if rd else "N/A")


func set_cpu_name_label() -> void:
	cpu_name_value.set_text(OS.get_processor_name())


func set_cpu_cores_label() -> void:
	cpu_cores_value.set_text(str(OS.get_processor_count()))


func set_window_scale_label() -> void:
	var value : float = ProjectSettings.get_setting("display/window/stretch/scale")
	window_scale_value.set_text(str(value))
	window_scale_value.get_parent().modulate.a = 0.4 if value == 1.0 else 1.0


func set_display_scale_label() -> void:
	var value : float = DisplayServer.screen_get_scale()
	display_scale_value.set_text(str(value))
	display_scale_value.get_parent().modulate.a = 0.4 if value == 1.0 else 1.0


func set_content_scale_label() -> void:
	var value : float = get_window().content_scale_factor
	content_scale_value.set_text(str(value))
	content_scale_value.get_parent().modulate.a = 0.4 if value == 1.0 else 1.0


func set_window_mode_label() -> void:
	var mode_name: String
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED: mode_name = "Windowed"
		DisplayServer.WINDOW_MODE_MINIMIZED: mode_name = "Minimized"
		DisplayServer.WINDOW_MODE_MAXIMIZED: mode_name = "Maximized"
		DisplayServer.WINDOW_MODE_FULLSCREEN: mode_name = "Fullscreen"
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN: mode_name = "Exclusive Fullscreen"
	window_mode_value.set_text(mode_name)


# — Game State —

func set_core_scene_label(_core_scene: StringName = G.core_scene) -> void:
	core_scene_value.set_text(str(G.core_scene))


func set_locale_label(_locale: String = SettingsManager.settings.lang) -> void:
	locale_value.set_text(str(SettingsManager.settings.lang))


func set_version_label(version: String = ProjectSettings.get_setting("application/config/version")) -> void:
	version_value.set_text(str(version))


func set_build_profile_label(release_mode: G.ReleaseMode = G.config.release_mode) -> void:
	build_profile_value.set_text(str(G.ReleaseMode.find_key(release_mode)))


# — Input/Output —

func set_mouse_position_label(mouse_position: Vector2) -> void:
	mouse_position_value.set_text(stringify_vector2(Vector2i(mouse_position)))


# — Pause —

func set_pause_label(pause_state: bool = get_tree().paused) -> void:
	if SaveManager.save_data:
		pause_value.set_text(str(pause_state))
		pause_requests_value.set_text(str(PauseManager.request_pause_objects.size()))
		if pause_state:
			pause_value.modulate = Color.GREEN
			pause_requests_value.modulate = Color.GREEN
		else:
			pause_value.modulate = Color.TOMATO
			pause_requests_value.modulate = Color.TOMATO


func _on_pause_resume_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		pause_resume_btn.icon = preload("res://addons/patate/assets/icons/pause.png")
		pause_resume_btn.modulate = Color(2.117, 1.354, 0.943, 1.0)
		#pause_resume_btn.text = "Pause"
		PauseManager.request_pause(pause_resume_btn, false)
	else:
		pause_resume_btn.icon = preload("res://addons/patate/assets/icons/right.png")
		pause_resume_btn.modulate = Color(0.943, 1.825, 0.845)
		#pause_resume_btn.text = "Resume"
		PauseManager.request_pause(pause_resume_btn, true)




func _on_collapse_expand_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		collapse_expand_btn.icon = preload("res://addons/patate/assets/icons/minus.png")
		debug_container.visible = true
		debug_btns.visible = true
		position_btns.visible = true
		help_label.visible = true
	else:
		collapse_expand_btn.icon = preload("res://addons/patate/assets/icons/plus.png")
		debug_container.visible = false
		debug_btns.visible = false
		position_btns.visible = false
		help_label.visible = false


func _on_time_scale_slider_value_changed(value: float = time_scale_slider.value) -> void:
	time_scale_value.set_text(str(value).lpad(4))
	Engine.time_scale = value


func refresh_stats() -> void:
	set_date_value()
	set_display_scale_label()
	set_content_scale_label()
	set_memory_usage_label()
	set_buffer_label()
	set_node_count_label()
	set_tween_count_label()
	set_orphan_node_count_label()
	set_resource_count_label()
	set_draw_calls_label()
	set_vram_usage_label()
	set_texture_memory_label()
	set_primitives_label()
	set_physics_2d_objects_label()
	set_physics_3d_objects_label()
	set_audio_latency_label()
	set_window_mode_label()
	set_window_scale_label()

	window_count_value.set_text(str(DisplayServer.get_screen_count()))
	window_size_value.set_text(stringify_vector2(Vector2i(DisplayServer.screen_get_size())))
	visible_viewport_size_value.set_text(stringify_vector2(Vector2i(get_viewport().get_visible_rect().size)))


func _on_nw_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)
	debug_window.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	frame_btns.move_child(collapse_expand_btn, 0)
	frame_btns.move_child(position_btns, -1)



func _on_ne_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)
	debug_window.set_h_size_flags(Control.SIZE_SHRINK_END)
	frame_btns.move_child(collapse_expand_btn, -1)
	frame_btns.move_child(position_btns, 0)


func _on_sw_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	btn_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_END)
	debug_window.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	frame_btns.move_child(collapse_expand_btn, 0)
	frame_btns.move_child(position_btns, -1)


func _on_se_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	btn_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_END)
	debug_window.set_h_size_flags(Control.SIZE_SHRINK_END)
	frame_btns.move_child(collapse_expand_btn, -1)
	frame_btns.move_child(position_btns, 0)


var mouse_on_help_spot : bool = false
func _on_help_spot_mouse_entered() -> void:
	mouse_on_help_spot = true

func _on_help_spot_mouse_exited() -> void:
	mouse_on_help_spot = false


func take_marketing_screenshots(hide_dev_layer : bool = false) -> void:
	if G.is_release():
		return

	var game_name: String = (ProjectSettings.get_setting("application/config/name") as String).replace(" ", "_")
	var version: String = str(ProjectSettings.get_setting("application/config/version"))
	var date: String = Time.get_datetime_string_from_system()
	var mode: String = str(G.ReleaseMode.find_key(G.config.release_mode))
	var base_filename := "%s_%s_%s_%s" % [game_name, version, date, mode]

	var native_w: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var native_h: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var game_is_landscape := native_w >= native_h

	if hide_dev_layer:
		self.visible = false
		SaveManager.before_screenshot.emit()
	await get_tree().process_frame

	for target_size: Vector2i in G.config.ScreenshotResolutions:
		var target_is_landscape := target_size.x >= target_size.y
		var needs_rotation := game_is_landscape != target_is_landscape
		var capture_size := Vector2i(target_size.y, target_size.x) if needs_rotation else target_size

		var img := await _render_to_image(capture_size)

		if needs_rotation:
			img.rotate_90(ClockDirection.CLOCKWISE)

		var folder := "user://marketing_screenshots/%dx%d/" % [target_size.x, target_size.y]
		DirAccess.make_dir_recursive_absolute(folder)
		img.save_png(folder + base_filename + ".png")

	if hide_dev_layer:
		SaveManager.after_screenshot.emit()
		self.visible = true

	print("Marketing screenshots saved to: %s/marketing_screenshots/" % OS.get_user_data_dir())


func _render_to_image(size: Vector2i) -> Image:
	var root := get_tree().root
	var orig_mode := root.content_scale_mode
	var orig_size := root.content_scale_size
	var orig_aspect := root.content_scale_aspect

	root.content_scale_mode = Window.CONTENT_SCALE_MODE_VIEWPORT
	root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_IGNORE
	root.content_scale_size = size

	await get_tree().process_frame
	await get_tree().process_frame

	var img := get_viewport().get_texture().get_image()

	root.content_scale_mode = orig_mode
	root.content_scale_size = orig_size
	root.content_scale_aspect = orig_aspect

	return img


func _on_marketing_screenshot_btn_pressed() -> void:
	take_marketing_screenshots(true)
