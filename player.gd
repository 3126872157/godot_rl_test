extends Area2D

@export var speed = 400
var screen_size
signal hit

@onready var ai_controller := $AIController2D
@onready var raycast_sensor = $RaycastSensor2D

#节点初始化
func _ready():
	screen_size = get_viewport_rect().size
	#hide()
	
	#ai_controller初始化
	ai_controller.init(self)
	raycast_sensor.activate()

#帧更新函数
func _process(delta):
	#根据输入设置速度
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	#归一化速度，避免斜着走速度为正交走的根号2倍
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

#被怪物入了，死亡
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
#游戏开始，设置player位置，显示角色图画，设置可碰撞
func start(pos):
	position = pos
	show()
	get_node("CollisionShape2D").disabled = false
	
