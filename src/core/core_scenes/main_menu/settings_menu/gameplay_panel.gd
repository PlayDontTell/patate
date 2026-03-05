extends ScrollContainer

@onready var lang_option_button: HBoxContainer = $VBoxContainer/LangOptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lang_option_button.add_options(LocaleManager.get_available_locales())
	lang_option_button.option_button
