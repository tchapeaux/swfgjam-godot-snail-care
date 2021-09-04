extends Node2D

export (PackedScene) var rain_scene

var viewport_rec
var is_umbrella_grabbed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport_rec = get_viewport_rect().size


func make_rain():
	var rain = rain_scene.instance()
	rain.position.x = rand_range(-viewport_rec.x / 2, viewport_rec.x)
	rain.position.y = rand_range(-10, -40)
	rain.scale.x = 0.2
	rain.scale.y = 0.2

	add_child(rain)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_umbrella_grabbed:
		var mousePosition = get_viewport().get_mouse_position()
		if mousePosition.length() > 0:
			$Umbrella.position = mousePosition
			$Umbrella.position.y = min($Umbrella.position.y, viewport_rec.y * .65)
			$Umbrella.rotation = -PI / 6



func _on_Snail_win():
	print("win!")
	$FadeOut.show()
	var tween = get_node("FadeOut/FadeOutTween")
	tween.interpolate_property($FadeOut/FadeOutBlack, "color",
		Color(0,0,0,0), Color(0,0,0,1), 5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 2)
	tween.interpolate_property($RaindropsBGM, "volume_db",
		0, -80, 7, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_FadeOutTween_tween_all_completed():
	print("finished")
	$FadeOut/ThankYouLabel.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_GrabUmbrella_mouse_entered():
	if not is_umbrella_grabbed:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		is_umbrella_grabbed = true
		$Snail.start_or_restart()
		$TitleLabel.start_fade_out()
