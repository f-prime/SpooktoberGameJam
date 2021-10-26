extends RigidBody2D

export var acceleration = 100
export var max_speed = 100
export var _friction = 2

var velocity = Vector2()

func _ready():
  pass # Replace with function body.
  
func process_input(delta):
  if Input.is_key_pressed(KEY_D): 
    velocity += Vector2(acceleration, 0) * delta
    
  #velocity.x = round(lerp(velocity.x, 0, _friction)) * delta
  position += velocity

func _process(delta):
  process_input(delta)
