extends CharacterBody2D

const SPEED = 400

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
