extends KinematicBody2D

export var acceleration = 5
export var max_speed = 200
export var friction = 10
export var gravitational_acceleration = 580
export var jump_velocity = 250

var on_ground = false
var velocity = Vector2()

func show_ghost():
  var ghost: KinematicBody2D = load("res://Ghost.tscn").instance()
  ghost.position = position
  ghost.position.y -= 50
  get_parent().add_child(ghost)
  get_parent().remove_child(self)

  
func process_input(delta):
  move_and_collide(Vector2(velocity.x * delta, 0))
  
  if Input.is_key_pressed(KEY_D):
    velocity.x = round(lerp(velocity.x, max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = false
  elif Input.is_key_pressed(KEY_A):
    velocity.x = round(lerp(velocity.x, -max_speed, acceleration * delta))
    $AnimatedSprite.flip_h = true
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


func _on_Fire_body_entered(body):
  if body.name == "Player":
    show_ghost()
