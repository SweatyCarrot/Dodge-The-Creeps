extends Node
@export var mob_scene: PackedScene
@export var fruit_scene: PackedScene
var score: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$FruitTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()


func new_game() -> void:
	score = 0
	
	$Player.start($PlayerStartPosition.position)
	$StartTimer.start()
	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("fruits", "queue_free")
	
	$Music.play()


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()
	$FruitTimer.start()


func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	#Instantiate a new mob scene
	var mob: Node = mob_scene.instantiate()
	
	#Pick a random point along the path for it to spawn at
	var mob_spawn_location = $MobPath/MobSpawnLocation #Question: what does $Node/Child mean? What is actually happening here?
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	
	#Set what direction the mob will move (with some randomness)
	var direction: float = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#Add velocity for the mob
	var velocity: Vector2 = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#Actually spawn the mob
	add_child(mob)


func _on_fruit_timer_timeout() -> void:
	var fruit: Node = fruit_scene.instantiate()
	
	var fruit_spawn_location = $FruitPath/FruitSpawnLocation
	fruit_spawn_location.progress_ratio = randf()
	fruit.position = fruit_spawn_location.position
	
	add_child(fruit)


func _on_player_fruit_hit() -> void:
	score += 5
	$HUD.update_score(score)
	
	get_tree().call_group("fruits", "queue_free")
	$FruitTimer.start()
	
