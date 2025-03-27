extends Area2D
signal hit
signal fruit_hit
@export var speed: int = 400 #player speed (pixels/sec)
var screen_size: Vector2 #game window size


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Set velocity == (0, 0)
	var velocity: Vector2 = Vector2.ZERO

	#Check input
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1 
	if Input.is_action_pressed("move_right"):
		velocity.x += 1

	#If there is input, set the normalized velocity value to (velocity * speed) to get how far the player should move this frame
	#Play the animation
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#Actually move the character
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#Change animation based on input
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


#Player collision
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("mobs"):
		hide()
		hit.emit()
		#Defer disabling of the player until the current frame has finished processing
		$CollisionShape2D.set_deferred("disabled", true)
	elif body.is_in_group("fruits"):
		fruit_hit.emit()


#Reset the player when we start the game
func start(pos: Vector2) -> void:
	position = pos
	show()
	$CollisionShape2D.disabled = false
