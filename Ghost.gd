extends KinematicBody2D

signal show_player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func _on_Player_show_ghost(player_pos):
  position = Vector2(player_pos.x, player_pos.y - 50)
  show()
