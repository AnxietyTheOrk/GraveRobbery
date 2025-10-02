extends Control

@onready var volume_slider:= $MarginContainer/HBoxContainer/Options/VolumeSlider
@onready var mute_button:= $MarginContainer/HBoxContainer/Options/MuteBox

func _ready() -> void:
	var audio_settings := ConfigFileHandler.load_audio_settings()
	volume_slider.value = min(audio_settings.volume, 1.0) * 100
	mute_button.toggle_mode = audio_settings.mute

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)
	ConfigFileHandler.save_audio_settings("volume", volume_slider.value / 100)


func _on_mute_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)
	ConfigFileHandler.save_audio_settings("mute", mute_button.toggle_mode)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Main_Menu/main_menu.tscn")
