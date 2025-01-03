extends AIController2D
#
#var move_action :int = 0
#
#func get_obs() -> Dictionary:
	## get the balls position and velocity in the paddle's frame of reference
	#var ball_pos = to_local(_player.ball.global_position)
	#var ball_vel = to_local(_player.ball.linear_velocity)
	#var obs = [ball_pos.x, ball_pos.z, ball_vel.x/10.0, ball_vel.z/10.0]
#
	#return {"obs":obs}
#
#func get_reward() -> float:
	#return reward
#
#func get_action_space() -> Dictionary:
	#return {
		#"move_action" : {
			#"size": 4,
			#"action_type": "discrete"
		#},
		#}
#
#func set_action(action) -> void:
	#move_action = action["move_action"]
