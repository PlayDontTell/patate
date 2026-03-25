## Can be used in DEV and EXPO build profiles
extends CanvasLayer

@onready var placement: Control = %Placement
@onready var debug_panel: MarginContainer = %DebugPanel
@onready var frame_btns: MarginContainer = %FrameBtns
@onready var debug_window: VBoxContainer = %DebugWindow

@onready var tab_1: Button = %Tab1
@onready var tab_2: Button = %Tab2
@onready var tab_3: Button = %Tab3
@onready var tab_4: Button = %Tab4
@onready var tab_5: Button = %Tab5
@onready var tab_6: Button = %Tab6

@onready var collapse_expand_btn: Button = %CollapseExpandBtn
@onready var position_btns: GridContainer = %PositionBtns
@onready var debug_container: VBoxContainer = %DebugContainer

# Time
@onready var fps_value: Label = %FPSValue
@onready var time_since_start_value: Label = %TimeSinceStartValue
@onready var time_played_value: Label = %TimePlayedValue
@onready var process_delta_value: Label = %ProcessDeltaValue
@onready var physics_delta_value: Label = %PhysicsDeltaValue
@onready var time_scale_value: Label = %TimeScaleValue
@onready var time_scale_slider: HSlider = %TimeScaleSlider
@onready var audio_latency_value: Label = %AudioLatencyValue

# Costs
@onready var memory_usage_value: Label = %MemoryUsageValue
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


@export var expanded_on_start: bool = false

enum StartPosition {TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT}
@export var position_on_start: StartPosition

@export var info_refresh_period: float = 1.

enum Tab {TIME=1, COSTS=2, MACHINE=4, GAME_STATE=8, INPUT_OUTPUT=16, PAUSE=32}
@export_flags("Time:1", "Costs:2", "Machine:4", "Game State:8", "Input/Output:16", "Pause:32") var active_tabs_on_start = 63


var info_refresh_timer: Timer


func _ready() -> void:
	G.new_core_scene_loaded.connect(set_core_scene_label)
	LocaleManager.locale_changed.connect(set_locale_label)
	PauseManager.pause_state_changed.connect(set_pause_label)
	init()


func _exit_tree() -> void:
	G.new_core_scene_loaded.disconnect(set_core_scene_label)
	LocaleManager.locale_changed.disconnect(set_locale_label)
	PauseManager.pause_state_changed.disconnect(set_pause_label)


func _process(delta: float) -> void:
	set_fps_label()
	set_time_since_start_label()
	set_time_played_label()
	set_process_delta_label(delta)


func _physics_process(delta: float) -> void:
	set_physics_delta_label(delta)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag or event is InputEventMouseMotion:
			set_mouse_position_label(event.position)
	if InputManager.just_pressed_event("toggle_Dev_layer", event):
			display_debug_layer()


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
			StartPosition.TOP_LEFT:   _on_nw_pressed()
			StartPosition.TOP_RIGHT:  _on_ne_pressed()
			StartPosition.BOTTOM_LEFT:  _on_sw_pressed()
			StartPosition.BOTTOM_RIGHT: _on_se_pressed()

	# Static machine info — set once
	machine_value.set_text(str(OS.get_model_name()))
	os_value.set_text(str(OS.get_name()))
	os_version_value.set_text(str(OS.get_version()))
	set_gpu_name_label()
	set_cpu_name_label()
	set_cpu_cores_label()
	set_display_scale_label()
	window_scale_value.set_text(str(ProjectSettings.get_setting("display/window/stretch/scale")))
	viewport_size_value.set_text(stringify_vector2(Vector2i(
			ProjectSettings.get_setting("display/window/size/viewport_width"),
			ProjectSettings.get_setting("display/window/size/viewport_height"),
	)))

	tab_1.toggle(bool(active_tabs_on_start & Tab.TIME))
	tab_2.toggle(bool(active_tabs_on_start & Tab.COSTS))
	tab_3.toggle(bool(active_tabs_on_start & Tab.MACHINE))
	tab_4.toggle(bool(active_tabs_on_start & Tab.GAME_STATE))
	tab_5.toggle(bool(active_tabs_on_start & Tab.INPUT_OUTPUT))
	tab_6.toggle(bool(active_tabs_on_start & Tab.PAUSE))


func display_debug_layer() -> void:
	self.visible = not self.visible


# — Helpers —

func _set_count_label(label: Label, value: int) -> void:
	label.set_text(str(value))
	label.get_parent().modulate.a = 0.5 if value == 0 else 1.0


func stringify_vector2(vector2i: Vector2i) -> String:
	return "(" + str(vector2i.x).lpad(4) + ", " + str(vector2i.y).lpad(4) + ")"


# — Time —

func set_fps_label() -> void:
	fps_value.set_text(str(Engine.get_frames_per_second()))


func set_time_since_start_label() -> void:
	if SaveManager.save_data:
			time_since_start_value.set_text(str(Utils.round_to_dec(SaveManager.save_data.time_since_start, 1)) + " s")


func set_time_played_label() -> void:
	if SaveManager.save_data:
			time_played_value.set_text(str(Utils.round_to_dec(SaveManager.save_data.time_played, 1)) + " s")


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


func set_display_scale_label() -> void:
	display_scale_value.set_text(str(DisplayServer.screen_get_scale()))


func set_window_mode_label() -> void:
	var mode_name: String
	match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_WINDOWED:            mode_name = "Windowed"
			DisplayServer.WINDOW_MODE_MINIMIZED:           mode_name = "Minimized"
			DisplayServer.WINDOW_MODE_MAXIMIZED:           mode_name = "Maximized"
			DisplayServer.WINDOW_MODE_FULLSCREEN:          mode_name = "Fullscreen"
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
			pause_resume_btn.icon = preload("uid://dwi38q3spugmy")
			pause_resume_btn.text = "Pause"
			PauseManager.request_pause(pause_resume_btn, false)
	else:
			pause_resume_btn.icon = preload("uid://vrok71kbmo3u")
			pause_resume_btn.text = "Resume"
			PauseManager.request_pause(pause_resume_btn, true)


func _on_collapse_expand_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
			collapse_expand_btn.icon = preload("uid://csfspd6lrbrl8")
			debug_container.visible = true
			position_btns.visible = true
	else:
			collapse_expand_btn.icon = preload("uid://d1cqgv5o7t1if")
			debug_container.visible = false
			position_btns.visible = false


func _on_time_scale_slider_value_changed(value: float = time_scale_slider.value) -> void:
	time_scale_value.set_text(str(value))
	Engine.time_scale = value


func refresh_stats() -> void:
	set_memory_usage_label()
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

	window_count_value.set_text(str(DisplayServer.get_screen_count()))
	window_size_value.set_text(stringify_vector2(Vector2i(DisplayServer.screen_get_size())))
	visible_viewport_size_value.set_text(stringify_vector2(Vector2i(get_viewport().get_visible_rect().size)))


func _on_nw_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	collapse_expand_btn.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	position_btns.set_h_size_flags(Control.SIZE_SHRINK_END)
	debug_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)


func _on_ne_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_TOP_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	collapse_expand_btn.set_h_size_flags(Control.SIZE_SHRINK_END)
	position_btns.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	debug_container.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_BEGIN)


func _on_sw_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_LEFT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	collapse_expand_btn.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	position_btns.set_h_size_flags(Control.SIZE_SHRINK_END)
	frame_btns.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_END)


func _on_se_pressed() -> void:
	placement.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	debug_panel.set_anchors_and_offsets_preset(Control.LayoutPreset.PRESET_BOTTOM_RIGHT, Control.LayoutPresetMode.PRESET_MODE_KEEP_SIZE, 0)
	collapse_expand_btn.set_h_size_flags(Control.SIZE_SHRINK_END)
	position_btns.set_h_size_flags(Control.SIZE_SHRINK_BEGIN)
	frame_btns.move_to_front()
	debug_window.set_v_size_flags(Control.SIZE_SHRINK_END)
