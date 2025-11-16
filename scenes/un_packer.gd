extends Control

@onready var red: TextureSaver = $UnpackedImages/HBoxContainer/Red
@onready var green: TextureSaver = $UnpackedImages/HBoxContainer/Green
@onready var blue: TextureSaver = $UnpackedImages/HBoxContainer2/Blue
@onready var alpha: TextureSaver = $UnpackedImages/HBoxContainer2/Alpha
@onready var panel_container: PanelContainer = $PanelContainer
@onready var texture_rect: TextureRect = $PanelContainer/ImportImage/TextureRect
@onready var file_dialog: FileDialog = $FileDialog

var active: bool = false

func _ready() -> void:
	get_tree().root.files_dropped.connect(_on_files_dropped)

func _on_files_dropped(files) -> void:
	if active:
		if panel_container.get_rect().has_point(get_global_mouse_position()):
			_load_image(files[0])

func _load_image(path: String) -> void:
	var image = Image.load_from_file(path)
	texture_rect.texture = ImageTexture.create_from_image(image)
	red.set_image(image)
	green.set_image(image)
	blue.set_image(image)
	alpha.set_image(image)

func set_active(newactive: bool) -> void:
	active = newactive

func _on_reset_button_pressed() -> void:
	texture_rect.texture = preload("res://assets/whitecolor.png")
	red.reset_image()
	green.reset_image()
	blue.reset_image()
	alpha.reset_image()

func _on_import_button_pressed() -> void:
	file_dialog.show()

func _on_file_dialog_file_selected(path: String) -> void:
	_load_image(path)
