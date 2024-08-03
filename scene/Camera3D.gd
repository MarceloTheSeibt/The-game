extends Camera3D

var room
var room_out
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	room = get_node("/root/Main/Room")
	player = get_node("/root/Main/Player/player_skeleton")
	room_out = get_node("/root/Main/Room/StaticBody2D/AreaTest")
	room.player_exited_room.connect(self._on_player_exited_room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_exited_room():
	global_position = $Camera_pos_1.get_global_position()
