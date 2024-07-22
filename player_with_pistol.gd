extends Node2D
var pistol_flipped = false 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Player/Pistol.set_global_position($Player/arm_left/gun_point.get_global_position())
	$Player/Pistol.set_rotation($Player/arm_left.get_rotation())

	if !pistol_flipped:
		if $Player/Pistol.get_global_rotation() >= PI / 2 or $Player/Pistol.get_global_rotation() <= - PI / 2:
			$Player/Pistol.set_scale(Vector2($Player/Pistol.get_scale()[0], - $Player/Pistol.get_scale()[1]))
			pistol_flipped = true

	elif pistol_flipped:
		if $Player/Pistol.get_global_rotation() <= PI / 2 and $Player/Pistol.get_global_rotation() >= - PI / 2:
			$Player/Pistol.set_scale(Vector2($Player/Pistol.get_scale()[0], - $Player/Pistol.get_scale()[1]))
			pistol_flipped = false



