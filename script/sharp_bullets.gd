extends Area2D
signal picked_up(powerup_name: String)

var player: Node
var safe_spawn_area
var safe_pos
var is_in_safe_place := true
var speed := 300


# Called when the node enters the scene tree for the first time.
func _ready():
	$Start_blinking_timer.start()
	$AnimationPlayer.play("shining")
	player = get_node("/root/Main/Player/player_skeleton")
	safe_spawn_area = get_node("/root/Main/Room/Power_up_safe_area")
	safe_pos = safe_spawn_area.get_global_position()


func _process(delta):
	# Caso spawne fora do alcance do player, se moverá até área segura
	if !self.overlaps_area(safe_spawn_area):
		var angle_to_safe_place := self.get_angle_to(safe_pos)
		var velocity := Vector2(cos(angle_to_safe_place), sin(angle_to_safe_place))
		if velocity.length() > 0: 
			velocity = velocity.normalized()
			position += velocity * delta * speed

	if self.overlaps_body(player):
		picked_up.emit("sharp_bullets")
		self.queue_free()


# Timer para começar a piscar
func _on_start_blinking_timer_timeout():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("shining_and_blinking")
	$Despawn_timer.start()


func _on_despawn_timer_timeout():
	self.queue_free()
