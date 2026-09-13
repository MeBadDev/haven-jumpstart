extends CharacterBody2D
class_name Bullet

var vec := Vector2.ZERO
@export var speed := 2500
@export var explosion_power := 750

@onready var explosion_radius: Area2D = $ExplosionRadius
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var exploded := false

func _physics_process(delta: float) -> void:
	if exploded:
		return

	# move_and_collide sweeps the bullet shape and returns a collision object if it hits anything
	var collision := move_and_collide(vec.normalized() * speed * delta)

	if collision:
		var collider := collision.get_collider()
		
		if collider is Bullet or collider is Player:
			# Pass through ignored objects by adding them to collision exceptions
			add_collision_exception_with(collider)
		else:
			explode(collision.get_position())

func explode(origin: Vector2) -> void:
	exploded = true
	anim_sprite.reparent(get_parent(), true)
	anim_sprite.scale = Vector2.ONE * 2
	anim_sprite.show()
	anim_sprite.play()
	anim_sprite.animation_finished.connect(anim_sprite.queue_free)
	
	await get_tree().physics_frame
	
	for body in explosion_radius.get_overlapping_bodies():
		if body.has_method("hit_by_explosion"):
			body.hit_by_explosion(explosion_power, global_position)
	queue_free()
