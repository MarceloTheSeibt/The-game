extends StaticBody2D
# Para que os mobs saibam onde é a janela
signal window_pos


var win_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	win_pos = $Wall/Mob_in.get_global_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	window_pos.emit(win_pos)

