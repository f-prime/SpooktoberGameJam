extends Area2D

func in_win_state():
  var tombstones = get_tree().get_root().get_children()[0].get_children()
  for tombstone in tombstones:
    if not ("Tombstone" in tombstone.name):
      continue
    if tombstone.is_visible():
      return false
  return true

func _on_Portal_body_entered(body):
  print(in_win_state())
