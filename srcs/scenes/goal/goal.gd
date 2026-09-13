extends Node2D
@export var next_scene : PackedScene


func _ready() -> void:
	$AnimationPlayer.play("fade", 0, -1, true)


func _on_goal_detecrt_body_entered(body: Node2D) -> void:
	if body is Player:
		$AnimationPlayer.play("fade")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_packed(next_scene)
