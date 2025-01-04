extends AIController2D

var move_action = Vector2.ZERO
var screen_width
var screen_height

func _ready():
	screen_width = get_viewport().size.x
	screen_height = get_viewport().size.y
	reset()
	
#需要reset()的情况
func _physics_process(delta: float) -> void:
	pass

func get_obs():
	#获取射线探测器返回的数组
	var obs = _player.raycast_sensor.get_observation()
	
	# 获取玩家位置并归一化
	var player_pos = _player.position
	obs.append(player_pos.x / screen_width)
	obs.append(player_pos.y / screen_height)

	return {"obs":obs}

func get_reward() -> float:
	return reward

func get_action_space() -> Dictionary:
	return {
		"move" : {
			"size": 2,
			"action_type": "continuous"
		},
		}

func set_action(action) -> void:
	move_action.x = action["move"][0]
	move_action.y = action["move"][1]
