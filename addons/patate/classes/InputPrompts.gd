class_name InputPrompts                                
																						

const _BASE_PATH := "res://addons/patate/assets/input-prompts/"                                                                                                                                                                               

enum GamepadBrand {                                                                                                                                                                                                                         
	XBOX,     
	PLAYSTATION,
	NINTENDO_SWITCH,
	STEAM,
	GENERIC,
}

# Brand → [subfolder, filename prefix]
static var _brand_info: Dictionary = {
	GamepadBrand.XBOX:             ["Xbox Series/Default/",       "xbox_"],
	GamepadBrand.PLAYSTATION:      ["PlayStation Series/Default/", "playstation_"],
	GamepadBrand.NINTENDO_SWITCH:  ["Nintendo Switch/Default/",    "switch_"],
	GamepadBrand.STEAM:            ["Steam Controller/Default/",   "steam_"],
	GamepadBrand.GENERIC:          ["Generic/Default/",            "generic_"],
}

# Key enum → filename suffix (combined with "keyboard_" prefix)
static var _keyboard_map: Dictionary = {
	KEY_A: "a", KEY_B: "b", KEY_C: "c", KEY_D: "d", KEY_E: "e",
	KEY_F: "f", KEY_G: "g", KEY_H: "h", KEY_I: "i", KEY_J: "j",
	KEY_K: "k", KEY_L: "l", KEY_M: "m", KEY_N: "n", KEY_O: "o",
	KEY_P: "p", KEY_Q: "q", KEY_R: "r", KEY_S: "s", KEY_T: "t",
	KEY_U: "u", KEY_V: "v", KEY_W: "w", KEY_X: "x", KEY_Y: "y",
	KEY_Z: "z",

	KEY_0: "0", KEY_1: "1", KEY_2: "2", KEY_3: "3", KEY_4: "4",
	KEY_5: "5", KEY_6: "6", KEY_7: "7", KEY_8: "8", KEY_9: "9",

	KEY_F1: "f1",   KEY_F2: "f2",   KEY_F3: "f3",  KEY_F4: "f4",
	KEY_F5: "f5",   KEY_F6: "f6",   KEY_F7: "f7",  KEY_F8: "f8",
	KEY_F9: "f9",   KEY_F10: "f10", KEY_F11: "f11", KEY_F12: "f12",

	KEY_ESCAPE:    "escape",
	KEY_ENTER:     "enter",
	KEY_KP_ENTER:  "numpad_enter",
	KEY_TAB:       "tab",
	KEY_BACKSPACE: "backspace",
	KEY_INSERT:    "insert",
	KEY_DELETE:    "delete",
	KEY_HOME:      "home",
	KEY_END:       "end",
	KEY_PAGEUP:    "page_up",
	KEY_PAGEDOWN:  "page_down",
	KEY_PRINT:     "printscreen",
	KEY_CAPSLOCK:  "capslock",
	KEY_NUMLOCK:   "numlock",

	KEY_UP:    "arrow_up",
	KEY_DOWN:  "arrow_down",
	KEY_LEFT:  "arrow_left",
	KEY_RIGHT: "arrow_right",

	KEY_SHIFT: "shift",
	KEY_CTRL:  "ctrl",
	KEY_ALT:   "alt",

	KEY_SPACE:        "space",
	KEY_MINUS:        "minus",
	KEY_EQUAL:        "equals",
	KEY_PLUS:         "plus",
	KEY_ASTERISK:     "asterisk",
	KEY_SLASH:        "slash_forward",
	KEY_BACKSLASH:    "slash_back",
	KEY_PERIOD:       "period",
	KEY_COMMA:        "comma",
	KEY_SEMICOLON:    "semicolon",
	KEY_COLON:        "colon",
	KEY_APOSTROPHE:   "apostrophe",
	KEY_QUOTEDBL:     "quote",
	KEY_QUOTELEFT:    "tilde",
	KEY_ASCIITILDE:   "tilde",
	KEY_ASCIICIRCUM:  "caret",
	KEY_BRACKETLEFT:  "bracket_open",
	KEY_BRACKETRIGHT: "bracket_close",
	KEY_LESS:         "bracket_less",
	KEY_GREATER:      "bracket_greater",
	KEY_EXCLAM:       "exclamation",
	KEY_QUESTION:     "question",
	KEY_KP_ADD:       "numpad_plus",
}

# MouseButton enum → full filename (no prefix)
static var _mouse_map: Dictionary = {
	MOUSE_BUTTON_LEFT:       "mouse_left",
	MOUSE_BUTTON_RIGHT:      "mouse_right",
	MOUSE_BUTTON_MIDDLE:     "mouse_scroll",
	MOUSE_BUTTON_WHEEL_UP:   "mouse_scroll_up",
	MOUSE_BUTTON_WHEEL_DOWN: "mouse_scroll_down",
}

# JoyButton enum → filename suffix per brand
static var _gamepad_button_maps: Dictionary = {
	GamepadBrand.XBOX: {
			JOY_BUTTON_A:              "button_a",
			JOY_BUTTON_B:              "button_b",
			JOY_BUTTON_X:              "button_x",
			JOY_BUTTON_Y:              "button_y",
			JOY_BUTTON_BACK:           "button_back",
			JOY_BUTTON_START:          "button_start",
			JOY_BUTTON_LEFT_STICK:     "ls",
			JOY_BUTTON_RIGHT_STICK:    "rs",
			JOY_BUTTON_LEFT_SHOULDER:  "lb",
			JOY_BUTTON_RIGHT_SHOULDER: "rb",
			JOY_BUTTON_DPAD_UP:        "dpad_up",
			JOY_BUTTON_DPAD_DOWN:      "dpad_down",
			JOY_BUTTON_DPAD_LEFT:      "dpad_left",
			JOY_BUTTON_DPAD_RIGHT:     "dpad_right",
	},
	GamepadBrand.PLAYSTATION: {
			JOY_BUTTON_A:              "button_cross",
			JOY_BUTTON_B:              "button_circle",
			JOY_BUTTON_X:              "button_square",
			JOY_BUTTON_Y:              "button_triangle",
			JOY_BUTTON_BACK:           "button_options",
			JOY_BUTTON_START:          "button_options",
			JOY_BUTTON_LEFT_STICK:     "button_l3",
			JOY_BUTTON_RIGHT_STICK:    "button_r3",
			JOY_BUTTON_LEFT_SHOULDER:  "trigger_l1",
			JOY_BUTTON_RIGHT_SHOULDER: "trigger_r1",
			JOY_BUTTON_DPAD_UP:        "dpad_up",
			JOY_BUTTON_DPAD_DOWN:      "dpad_down",
			JOY_BUTTON_DPAD_LEFT:      "dpad_left",
			JOY_BUTTON_DPAD_RIGHT:     "dpad_right",
	},
	GamepadBrand.NINTENDO_SWITCH: {
			JOY_BUTTON_A:              "button_b",   # Godot A = bottom face = Switch B
			JOY_BUTTON_B:              "button_a",   # Godot B = right face  = Switch A
			JOY_BUTTON_X:              "button_y",   # Godot X = left face   = Switch Y
			JOY_BUTTON_Y:              "button_x",   # Godot Y = top face    = Switch X
			JOY_BUTTON_BACK:           "button_minus",
			JOY_BUTTON_START:          "button_plus",
			JOY_BUTTON_LEFT_STICK:     "stick_l_press",
			JOY_BUTTON_RIGHT_STICK:    "stick_r_press",
			JOY_BUTTON_LEFT_SHOULDER:  "button_l",
			JOY_BUTTON_RIGHT_SHOULDER: "button_r",
			JOY_BUTTON_DPAD_UP:        "dpad_up",
			JOY_BUTTON_DPAD_DOWN:      "dpad_down",
			JOY_BUTTON_DPAD_LEFT:      "dpad_left",
			JOY_BUTTON_DPAD_RIGHT:     "dpad_right",
	},
	GamepadBrand.STEAM: {
			JOY_BUTTON_A:              "button_a",
			JOY_BUTTON_B:              "button_b",
			JOY_BUTTON_X:              "button_x",
			JOY_BUTTON_Y:              "button_y",
			JOY_BUTTON_BACK:           "button_back_icon",
			JOY_BUTTON_START:          "button_start_icon",
			JOY_BUTTON_LEFT_STICK:     "stick_l_press",
			JOY_BUTTON_RIGHT_STICK:    "stick_r_press",
			JOY_BUTTON_LEFT_SHOULDER:  "lb",
			JOY_BUTTON_RIGHT_SHOULDER: "rb",
			JOY_BUTTON_DPAD_UP:        "dpad_up",
			JOY_BUTTON_DPAD_DOWN:      "dpad_down",
			JOY_BUTTON_DPAD_LEFT:      "dpad_left",
			JOY_BUTTON_DPAD_RIGHT:     "dpad_right",
	},
	GamepadBrand.GENERIC: {
			JOY_BUTTON_A:              "button_circle_fill",
			JOY_BUTTON_B:              "button_square_fill",
			JOY_BUTTON_X:              "button_trigger_a_fill",
			JOY_BUTTON_Y:              "button_trigger_b_fill",
			JOY_BUTTON_LEFT_STICK:     "stick_press",
			JOY_BUTTON_RIGHT_STICK:    "stick_press",
			JOY_BUTTON_LEFT_SHOULDER:  "button_trigger_a",
			JOY_BUTTON_RIGHT_SHOULDER: "button_trigger_b",
			JOY_BUTTON_DPAD_UP:        "stick_up",
			JOY_BUTTON_DPAD_DOWN:      "stick_down",
			JOY_BUTTON_DPAD_LEFT:      "stick_left",
			JOY_BUTTON_DPAD_RIGHT:     "stick_right",
	},
}

# JoyAxis → filename suffix per brand
# Key format: str(axis_index) + "+" (positive) or "-" (negative)
static var _gamepad_axis_maps: Dictionary = {
	GamepadBrand.XBOX: {
			"0+": "stick_l_right", "0-": "stick_l_left",
			"1+": "stick_l_down",  "1-": "stick_l_up",
			"2+": "stick_r_right", "2-": "stick_r_left",
			"3+": "stick_r_down",  "3-": "stick_r_up",
			"4+": "lt",            "5+": "rt",
	},
	GamepadBrand.PLAYSTATION: {
			"0+": "stick_l_right", "0-": "stick_l_left",
			"1+": "stick_l_down",  "1-": "stick_l_up",
			"2+": "stick_r_right", "2-": "stick_r_left",
			"3+": "stick_r_down",  "3-": "stick_r_up",
			"4+": "trigger_l2",    "5+": "trigger_r2",
	},
	GamepadBrand.NINTENDO_SWITCH: {
			"0+": "stick_l_right", "0-": "stick_l_left",
			"1+": "stick_l_down",  "1-": "stick_l_up",
			"2+": "stick_r_right", "2-": "stick_r_left",
			"3+": "stick_r_down",  "3-": "stick_r_up",
			"4+": "button_zl",     "5+": "button_zr",
	},
	GamepadBrand.STEAM: {
			"0+": "stick_l_right", "0-": "stick_l_left",
			"1+": "stick_l_down",  "1-": "stick_l_up",
			"4+": "lt",            "5+": "rt",
	},
	GamepadBrand.GENERIC: {
			"0+": "stick_right", "0-": "stick_left",
			"1+": "stick_down",  "1-": "stick_up",
	},
}


## Detects the brand of a connected gamepad by its reported name.
static func get_brand(device_id: int) -> GamepadBrand:
	var name := Input.get_joy_name(device_id).to_lower()
	if "xbox" in name or "microsoft" in name:
			return GamepadBrand.XBOX
	if "playstation" in name or "dualshock" in name or "dualsense" in name or "sony" in name:
			return GamepadBrand.PLAYSTATION
	if "nintendo" in name or "switch" in name or "joy-con" in name:
			return GamepadBrand.NINTENDO_SWITCH
	if "steam" in name or "valve" in name:
			return GamepadBrand.STEAM
	return GamepadBrand.GENERIC


## Returns a prompt texture for an InputEvent, or null if no asset is found.
## Caller should fall back to event.as_text() when null is returned.
## device_id is used to detect gamepad brand; pass -1 for keyboard/mouse.
static func get_texture(event: InputEvent, device_id: int = -1) -> Texture2D:
	var path := _get_path(event, device_id)
	if path.is_empty() or not ResourceLoader.exists(path):
			return null
	return ResourceLoader.load(path) as Texture2D


static func _get_path(event: InputEvent, device_id: int) -> String:
	if event is InputEventKey:
		var keycode : Key = event.keycode if event.keycode != KEY_NONE else event.physical_keycode
		if keycode == KEY_META:
			var suffix := "command" if OS.get_name() == "macOS" else "win"
			return _BASE_PATH + "Keyboard & Mouse/Default/keyboard_" + suffix + ".png"
		if keycode in _keyboard_map:
			return _BASE_PATH + "Keyboard & Mouse/Default/keyboard_" + _keyboard_map[keycode] + ".png"
	
	elif event is InputEventMouseButton:
			if event.button_index in _mouse_map:
					return _BASE_PATH + "Keyboard & Mouse/Default/" + _mouse_map[event.button_index] + ".png"
	
	elif event is InputEventJoypadButton:
			var brand := get_brand(device_id)
			var map: Dictionary = _gamepad_button_maps.get(brand, {})
			if event.button_index in map:
					var info: Array = _brand_info[brand]
					return _BASE_PATH + info[0] + info[1] + map[event.button_index] + ".png"
	
	elif event is InputEventJoypadMotion:
			var brand := get_brand(device_id)
			var map: Dictionary = _gamepad_axis_maps.get(brand, {})
			var axis_key := str(event.axis) + ("+" if event.axis_value >= 0.0 else "-")
			if axis_key in map:
					var info: Array = _brand_info[brand]
					return _BASE_PATH + info[0] + info[1] + map[axis_key] + ".png"
	
	return ""
