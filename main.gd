extends Node

@export var mob_scene: PackedScene
var score
signal startTim

func _ready() -> void:
	new_game()

func new_game():
	$HUD/Message.hide()
	score = 0
	$Player.start($StartPosition.position)
	startTim.emit()
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")
	$Music.play()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	
	await get_tree().create_timer(1.0).timeout
	new_game()

func _on_start_tim() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)
	$Player/AIController2D.reward += 0.5
	
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	
	var mob_spawn_position = $MobPath/MobSpawnLocation
	mob_spawn_position.progress_ratio = randf()
	
	var direction = mob_spawn_position.rotation + PI/2
	mob.position = mob_spawn_position.position
	
	direction += randf_range(-PI/4, PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
