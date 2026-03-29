extends HBoxContainer


func _on_user_data_folder_pressed() -> void:
	if OS.has_feature("web"):
		return
	OS.shell_open(OS.get_user_data_dir())


func _on_restart_game_btn_pressed() -> void:
	G.request_game_restart.emit()


func _on_stop_btn_pressed() -> void:
	get_tree().quit()
