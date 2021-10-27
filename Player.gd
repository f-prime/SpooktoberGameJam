extends KinematicBody2D

signal show_ghost

export var acceleration = 5
export var max_speed = 300
export var friction = 10
export var gravitational_acceleration = 500
export var jump_velocity = 200

var on_ground = false
var velocity = Vector2()

func _ready():
  pass # Replace with function body.
  
func process_input(delta):
  move_and_collide(Vector2(velocity.x * delta, 0))
  
  if Input.is_key_pressed(KEY_D):
    velocity.x = round(lerp(velocity.x, max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = false
  elif Input.is_key_pressed(KEY_A):
    velocity.x = round(lerp(velocity.x, -max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = true
  elif Input.is_key_pressed(KEY_S):
    emit_signal("show_ghost", position)
    hide()
  else:
    velocity.x = lerp(velocity.x, 0, friction * delta)
    
  if Input.is_action_just_pressed("jump") and on_ground:
    velocity.y -= jump_velocity
    
  
func gravity(delta):
  var movement = Vector2(0, velocity.y * delta)
  var ga = gravitational_acceleration * delta
  move_and_collide(movement)
  on_ground = test_move(transform, movement)
  
  if on_ground:
    velocity.y = ga
  else:
    velocity.y += ga


func _process(delta):
  if not is_visible():
    return
  gravity(delta)
  process_input(delta)

