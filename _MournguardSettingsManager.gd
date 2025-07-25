# Extend then autoload this
@abstract class_name MournguardSettingsManager extends Node

const DEFAULT_SETTINGS_FILE := "res://addons/Mournguard-Settings/default_settings.cfg"

var _config := ConfigFile.new()
var _config_file := "user://settings.cfg"
var _config_file_default := ""
var _initialized := false

# This should simply call _apply_setting on all available settings
@abstract func _apply_settings() -> void

# Handle whatever happens when a setting's value has been modified
@abstract func _apply_setting(setting: Setting) -> void

func initialize(_default_config: String = DEFAULT_SETTINGS_FILE) -> void:
	_config_file_default = _default_config
	var status := _config.load(_config_file)
	if status != OK:
		status = _config.load(_config_file_default)
		if status != OK:
			Game.crash()

	_initialized = true

	_apply_settings()

func _find_default_value(setting: Setting) -> Variant:
	var temp := ConfigFile.new()
	var status := temp.load(_config_file_default)
	if status != OK:
		printerr(status)
		Game.crash()
	return temp.get_value(setting.section, setting.key)

func write(setting: Setting, value: Variant) -> void:
	if !_initialized:
		return
	_config.set_value(setting.section, setting.key, value)
	_apply_setting(setting)
	save()

func read(setting: Setting) -> Variant:
	if !_initialized:
		return
	if _config.has_section_key(setting.section, setting.key):
		return _config.get_value(setting.section, setting.key)
	else:
		var value: Variant = _find_default_value(setting)
		write(setting, value)
		return value

func save() -> void:
	_config.save(_config_file)
