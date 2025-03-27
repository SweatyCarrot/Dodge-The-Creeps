extends RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Get a random animation to play
	var mob_types: Array = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

#Get rid of the mob when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
