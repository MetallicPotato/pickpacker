extends Control

@onready var red: TextureLookup = $GridContainer/Red
@onready var blue: TextureLookup = $GridContainer/Blue
@onready var green: TextureLookup = $GridContainer/Green
@onready var alpha: TextureLookup = $GridContainer/Alpha
@onready var file_dialog: FileDialog = $FileDialog
@onready var size_error_message = $SizeErrorMessage
@onready var sub_viewport: SubViewport = $VBoxContainer/SubViewportContainer/SubViewport

var image_size: Vector2i
var image_size_set: bool = false

func _ready() -> void:
	red.image_changed.connect(changeimage)
	blue.image_changed.connect(changeimage)
	green.image_changed.connect(changeimage)
	alpha.image_changed.connect(changeimage)
	
	red.image_channel_change.connect(_image_channel_changed)
	blue.image_channel_change.connect(_image_channel_changed)
	green.image_channel_change.connect(_image_channel_changed)
	alpha.image_channel_change.connect(_image_channel_changed)
	
	get_tree().root.files_dropped.connect(_on_files_dropped)

func _on_button_pressed() -> void:
	file_dialog.show()

func changeimage(channel: TextureLookup.channelselect) -> void:
	match channel:
		TextureLookup.channelselect.RED:
			RenderingServer.global_shader_parameter_set("redtexture", red.texture_rect.texture)
			if image_size_set == false:
				image_size_set = true
				image_size = red.texture_rect.texture.get_image().get_size()
			else:
				_check_image_size(red)
		TextureLookup.channelselect.GREEN:
			RenderingServer.global_shader_parameter_set("greentexture", green.texture_rect.texture)
			if image_size_set == false:
				image_size_set = true
				image_size = green.texture_rect.texture.get_image().get_size()
			else:
				_check_image_size(green)
		TextureLookup.channelselect.BLUE:
			RenderingServer.global_shader_parameter_set("bluetexture", blue.texture_rect.texture)
			if image_size_set == false:
				image_size_set = true
				image_size = blue.texture_rect.texture.get_image().get_size()
			else:
				_check_image_size(blue)
		TextureLookup.channelselect.ALPHA:
			RenderingServer.global_shader_parameter_set("alphatexture", alpha.texture_rect.texture)
			if image_size_set == false:
				image_size_set = true
				image_size = alpha.texture_rect.texture.get_image().get_size()
			else:
				_check_image_size(alpha)

func _check_image_size(node: TextureLookup) -> void:
	#TODO: this should check if all sizes are the same, not just use a saved size value. Remove size variables!
	if image_size != node.texture_rect.texture.get_image().get_size():
		size_error_message.show()
	else:
		size_error_message.hide()

func _on_file_dialog_file_selected(path: String) -> void:
	var texture = sub_viewport.get_texture()
	await RenderingServer.frame_post_draw
	var saveimage = texture.get_image()
	saveimage.save_png(path)

func _on_files_dropped(_files):
	if red.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		red.load_image(_files[0])
		return
	elif green.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		green.load_image(_files[0])
		return
	elif blue.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		blue.load_image(_files[0])
		return
	elif alpha.panel_container.get_global_rect().has_point(get_global_mouse_position()):
		alpha.load_image(_files[0])
		return

func _image_channel_changed(imagetouse: TextureLookup.channelselect, newchannel: int) -> void:
	match imagetouse:
		TextureLookup.channelselect.RED:
			RenderingServer.global_shader_parameter_set("redmode", newchannel)
		TextureLookup.channelselect.GREEN:
			RenderingServer.global_shader_parameter_set("greenmode", newchannel)
		TextureLookup.channelselect.BLUE:
			RenderingServer.global_shader_parameter_set("bluemode", newchannel)
		TextureLookup.channelselect.ALPHA:
			RenderingServer.global_shader_parameter_set("alphamode", newchannel)

func _on_reset_button_pressed():
	image_size_set = false
	var blank_img = preload("res://assets/whitecolor.png")
	red.texture_rect.texture = blank_img
	green.texture_rect.texture = blank_img
	blue.texture_rect.texture = blank_img
	alpha.texture_rect.texture = blank_img
	changeimage(TextureLookup.channelselect.RED)
	changeimage(TextureLookup.channelselect.GREEN)
	changeimage(TextureLookup.channelselect.BLUE)
	changeimage(TextureLookup.channelselect.ALPHA)
	size_error_message.hide()
	#TODO: call TextureLookup reset function that can handle everything?
