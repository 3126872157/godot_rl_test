extends RigidBody2D

#构造小怪，随机样式
func _ready():
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

#小怪出屏幕就销毁
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
