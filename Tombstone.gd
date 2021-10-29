extends KinematicBody2D

func toggle_collisions(state):
  $CollisionShape2D.disabled = !state
