extends Area2D

@export var speed = 400
@export var dangerous_distance = 50
var screen_size
signal hit

@onready var ai_controller := $AIController2D
@onready var raycast_sensor = $RaycastSensor2D

#节点初始化
func _ready():
	screen_size = get_viewport_rect().size
	#ai_controller初始化
	ai_controller.init(self)
	raycast_sensor.activate()

#帧更新函数
func _process(delta):
	#根据输入设置速度
	var velocity = Vector2.ZERO
	
	#人机控制
	if ai_controller.heuristic == "human":
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
	else:
		if ai_controller.done:
			velocity = Vector2.ZERO
		else:
			velocity.x = ai_controller.move_action.x
			velocity.y = ai_controller.move_action.y
		
	

	#归一化速度，避免斜着走速度为正交走的根号2倍，其实这个Velocity应该叫direction的
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	#控制角色在屏幕内
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	#根据速度改变动画显示
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	update_reward()

#被怪物入了，死亡
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	ai_controller.reward -= 10.0
	
#游戏开始，设置player位置，显示角色图画，设置可碰撞
func start(pos):
	ai_controller.done = true
	ai_controller.reset()
	position = pos
	show()
	get_node("CollisionShape2D").disabled = false
	
func update_reward():
	ai_controller.reward += distance_reward()
	
func distance_reward() -> float:
	var reward = 0.0
	for mob in get_tree().get_nodes_in_group("mobs"):
		var distance_to_mob = (position - mob.position).length()
		if distance_to_mob < dangerous_distance:
			reward -= 1.0
		
	return reward
