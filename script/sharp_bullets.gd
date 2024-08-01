extends Area2D
# Avisa o Main que foi coletado
signal picked_up(powerup_name: String)

var player


func _ready():
	$Start_blinking_timer.start()
	$AnimationPlayer.play("shining")
	player = get_node("/root/Main/Player/player_skeleton")


func _process(delta):
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
