extends CharacterBody2D

const SPEED = 400
var CHANGED := false

func _ready():
	$Label.text = name
	set_multiplayer_authority(name.to_int())

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		if CHANGED:
			($Icon as Sprite2D).modulate = Color.WHITE
			CHANGED = false
		else:
			($Icon as Sprite2D).modulate = Color.RED
			CHANGED = true

func _physics_process(delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
