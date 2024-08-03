extends StaticBody2D
# Para que os mobs saibam onde é a janela
signal window_pos
signal player_exited_room
var player
var emitted = false

var win_pos: Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	win_pos = $Wall/Mob_in.get_global_position()
	player = get_node("/root/Main/Player/player_skeleton")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	window_pos.emit(win_pos)
	if $StaticBody2D/AreaTest.overlaps_body(player):
		if !emitted:
			player_exited_room.emit()
			emitted = true

