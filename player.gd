extends CharacterBody2D

# Preload the fireball scene
var fireball_scene = preload("res://fireball.tscn")
var fireball_speed = 800  # Adjust as needed

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	
	# Disable camera if not the multiplayer authority (client)
	if has_node("Camera2D"):
		$Camera2D.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left","ui_right","ui_up","ui_down") * 400
		
		# Check for space bar press to shoot fireball
		if Input.is_action_just_pressed("ui_accept"):  # Space bar is typically mapped to ui_accept
			shoot_fireball()
	
	move_and_slide()

func shoot_fireball():
	var fireball = fireball_scene.instantiate()
	
	# Calculate direction based on player's movement or default to right
	var direction = Vector2(1, 0)  # Default right direction
	if velocity.length() > 0:
		direction = velocity.normalized()
	
	# Position the fireball slightly in front of the player in the direction it's facing
	fireball.position = position + direction * 30  # Offset by 30 pixels
	
	# Add the fireball to the scene
	get_parent().add_child(fireball)
	
	# Apply an impulse to the RigidBody2D in the shooting direction
	fireball.apply_impulse(direction * fireball_speed)
