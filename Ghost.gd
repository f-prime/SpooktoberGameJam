extends KinematicBody2D

signal show_player

export var max_velocity = 200
export var acceleration = 25
export var friction = 5

var velocity = Vector2()
var frame_swap_occurred = 0

func _ready():
  toggle_collisions()
  hide()
  
func current_frame():
  return get_tree().get_frame()

func toggle_collisions():
  $CollisionShape2D.disabled = not $CollisionShape2D.disabled

func close_tombstone():
  var all_nodes = get_tree().get_root().get_children()[0].get_children()
  for node in all_nodes:
    if not node.is_visible():
      continue
    if not ("Tombstone" in node.name):
      continue
    var distance_to_tombstone = position.distance_to(node.position)
    if distance_to_tombstone < 100:
      return node
  return null

func show_player():
  var tombstone = close_tombstone()
  if not tombstone:
    return
  toggle_collisions()
  emit_signal("show_player", position, current_frame(), tombstone)
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
    
  if Input.is_action_just_pressed("sacrifice") and current_frame() != frame_swap_occurred:
    show_player()
    
  move_and_slide(velocity)
  
func _process(delta):
  if not is_visible():
    return
  process_input(delta)

func _on_Player_show_ghost(player_pos, frame_occurred):
  frame_swap_occurred = frame_occurred
  position = Vector2(player_pos.x, player_pos.y - 50)
  toggle_collisions()
  show()
