extends Node2D
@export_file("*.tscn") var next_scene 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_packed(load(next_scene))
