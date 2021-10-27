extends KinematicBody2D

signal show_player

export var max_velocity = 200
export var acceleration = 25
export var friction = 5

var velocity = Vector2()

func _ready():
  hide()

func process_input(delta):
  if Input.is_key_pressed(KEY_W):
    velocity.y = lerp(velocity.y, -max_velocity, acceleration * delta)
  elif Input.is_key_pressed(KEY_S):
    velocity.y = lerp(velocity.y, max_velocity, acceleration * delta)
  else:
    velocity.y = lerp(velocity.y, 0, friction * delta)
    
  if Input.is_key_pressed(KEY_D):
    $AnimatedSprite.flip_h = false
    velocity.x = lerp(velocity.x, max_velocity, acceleration * delta)
  elif Input.is_key_pressed(KEY_A):
    $AnimatedSprite.flip_h = true
    velocity.x = lerp(velocity.x, -max_velocity, acceleration * delta)  
  else:
    velocity.x = lerp(velocity.x, 0, friction * delta)
    
  move_and_slide(velocity)
  
func _process(delta):
  if not is_visible():
    return
  process_input(delta)

func _on_Player_show_ghost(player_pos):
  position = Vector2(player_pos.x, player_pos.y - 50)
  show()
