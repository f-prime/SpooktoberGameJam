extends Node2D

func _ready():
  for node in get_children():
    if node.name == "Ghost":
      node.connect("show_player", self, "show_player")
    elif node.name == "Player":
      node.connect("show_ghost", self, "show_ghost")

func show_ghost(instance: KinematicBody2D):
  var ghost: KinematicBody2D = load("res://Ghost.tscn").instance()
  ghost.position = instance.position
  ghost.connect("show_player", self, "show_player")
  instance.queue_free()
  add_child(ghost)

func show_player(instance: KinematicBody2D, tombstone: KinematicBody2D):
  var player: KinematicBody2D = load("res://Player.tscn").instance()
  player.position = instance.position
  player.connect("show_ghost", self, "show_ghost")
  instance.queue_free()
  tombstone.queue_free()
  add_child(player)

func _on_Fire_body_entered(body):
  if body.name == "Player":
    show_ghost(body)
