extends Control

@onready var red: TextureLookup = $GridContainer/Red
@onready var blue: TextureLookup = $GridContainer/Blue
@onready var green: TextureLookup = $GridContainer/Green
@onready var alpha: TextureLookup = $GridContainer/Alpha
@onready var file_dialog: FileDialog = $FileDialog
@onready var size_error_message = $SizeErrorMessage
@onready var sub_viewport: SubViewport = $SubViewport
@onready var final_image: ColorRect = $SubViewport/FinalImage
var active: bool = false

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
			_check_image_size()
		TextureLookup.channelselect.GREEN:
			RenderingServer.global_shader_parameter_set("greentexture", green.texture_rect.texture)
			_check_image_size()
		TextureLookup.channelselect.BLUE:
			RenderingServer.global_shader_parameter_set("bluetexture", blue.texture_rect.texture)
			_check_image_size()
		TextureLookup.channelselect.ALPHA:
			RenderingServer.global_shader_parameter_set("alphatexture", alpha.texture_rect.texture)
			_check_image_size()

func _check_image_size() -> void:
	var nodes: Array[TextureLookup] = [red, green, blue, alpha]
	var mismatch: bool = false
	for thisnode in nodes:
		for thisnodeagain in nodes:
			if thisnode.texture_rect.texture.get_image().get_size() != thisnodeagain.texture_rect.texture.get_image().get_size():
				if thisnodeagain.image_set and thisnode.image_set:
					mismatch = true
	if mismatch:
		size_error_message.show()
	else:
		size_error_message.hide()
		set_image_size(red.texture_rect.texture.get_image().get_size())

func set_image_size(newsize: Vector2i) -> void:
	sub_viewport.size = newsize
	final_image.size = newsize

func _on_file_dialog_file_selected(path: String) -> void:
	var texture = sub_viewport.get_texture()
	await RenderingServer.frame_post_draw
	var saveimage = texture.get_image()
	saveimage.save_png(path)

func _on_files_dropped(_files):
	if not active: return
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
	red.reset_image()
	green.reset_image()
	blue.reset_image()
	alpha.reset_image()
	changeimage(TextureLookup.channelselect.RED)
	changeimage(TextureLookup.channelselect.GREEN)
	changeimage(TextureLookup.channelselect.BLUE)
	changeimage(TextureLookup.channelselect.ALPHA)
	_check_image_size()

func set_active(newactive: bool) -> void:
	active = newactive
	
	if active:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	else:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
