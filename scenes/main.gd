extends Control

@onready var pack: Control = $TabContainer/Pack
@onready var un_pack: Control = $"TabContainer/Un-Pack"

func _ready() -> void:
	pack.set_active(true)
	un_pack.set_active(false)

func _on_tab_container_tab_changed(tab: int) -> void:
	match tab:
		0:
			pack.set_active(true)
			un_pack.set_active(false)
		1:
			pack.set_active(false)
			un_pack.set_active(true)
