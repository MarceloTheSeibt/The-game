extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("/root/Main/Player")
	player.player_position.connect(self._player_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _player_position(pos):
	#self.set_global_position(pos)
	pass


func _on_player_player_death(pos):
	self.set_global_position(pos)
	self.set_zoom(Vector2(1.5, 1.5))
