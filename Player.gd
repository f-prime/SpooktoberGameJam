extends KinematicBody2D

signal show_ghost

export var acceleration = 5
export var max_speed = 200
export var friction = 10
export var gravitational_acceleration = 580
export var jump_velocity = 250

var on_ground = false
var velocity = Vector2()
var frame_swap_occurred = 0

func _ready():
  pass # Replace with function body.

func current_frame():
  return get_tree().get_frame()

func show_ghost():
  if not on_ground:
    return
  emit_signal("show_ghost", position, current_frame())
  hide()

func process_input(delta):
  move_and_collide(Vector2(velocity.x * delta, 0))
  
  if Input.is_key_pressed(KEY_D):
    velocity.x = round(lerp(velocity.x, max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = false
  elif Input.is_key_pressed(KEY_A):
    velocity.x = round(lerp(velocity.x, -max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = true
  elif Input.is_action_just_pressed("sacrifice") and current_frame() != frame_swap_occurred:
    show_ghost()
  else:
    velocity.x = lerp(velocity.x, 0, friction * delta)
    
  if Input.is_action_just_pressed("jump") and on_ground:
    velocity.y -= jump_velocity
  
  if abs(velocity.x) > 1:
    $AnimatedSprite.animation = "walking"
    $AnimatedSprite.play()
  else:
    $AnimatedSprite.animation = "idle"
    $AnimatedSprite.stop()  
  
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

func _on_Ghost_show_player(ghost_position, frame_occurred):
  frame_swap_occurred = frame_occurred
  position = Vector2(ghost_position.x, ghost_position.y)
  show()
