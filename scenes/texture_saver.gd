class_name TextureSaver
extends Control

@export var channeltouse: TextureLookup.channelselect

@onready var panel_container: PanelContainer = $PanelContainer
@onready var file_dialog: FileDialog = $FileDialog
@onready var sub_viewport: SubViewport = $SubViewport
@onready var save_texture: TextureRect = $SubViewport/SaveTexture
@onready var texture_rect: TextureRect = $PanelContainer/VBox/TextureRect
@onready var channel_label: Label = $PanelContainer/VBox/HBoxContainer/ChannelLabel

var image_set: bool = false

func _ready() -> void:
	match channeltouse:
		TextureLookup.channelselect.RED:
			texture_rect.set_instance_shader_parameter("mode", 1)
			channel_label.text = "Red Channel"
		TextureLookup.channelselect.GREEN:
			texture_rect.set_instance_shader_parameter("mode", 2)
			channel_label.text = "Green Channel"
		TextureLookup.channelselect.BLUE:
			texture_rect.set_instance_shader_parameter("mode", 3)
			channel_label.text = "Blue Channel"
		TextureLookup.channelselect.ALPHA:
			texture_rect.set_instance_shader_parameter("mode", 4)
			channel_label.text = "Alpha Channel"

func set_image(newimage: Image) -> void:
	texture_rect.texture = ImageTexture.create_from_image(newimage)
	save_texture.size = newimage.get_size()
	sub_viewport.size = newimage.get_size()
	save_texture.texture = ImageTexture.create_from_image(newimage)
	image_set = true
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE

func reset_image() -> void:
	image_set = false
	texture_rect.texture = preload("res://assets/whitecolor.png")

func _on_save_button_pressed() -> void:
	if image_set:
		file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	var texture = sub_viewport.get_texture()
	await RenderingServer.frame_post_draw
	var saveimage = texture.get_image()
	saveimage.save_png(path)
