class_name Setting

var section: String
var key: String

func _init(_section: String, _key: String) -> void:
	section = _section
	key = _key

func equals(_section: String, _key: String) -> bool:
	return section == _section and key == _key
