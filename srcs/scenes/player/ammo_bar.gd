@tool
extends NinePatchRect
var max_ammo_count :int= 5
var current_ammo :int= 5

const AMMO_WIDTH := 3
const GAP_BETWEEN_AMMO := 1
const BORDER_WIDTH := 2
func _ready() -> void:
	update(current_ammo, max_ammo_count)


func update(new_ammo_count, new_max_ammo_count):
	self.size.x = (AMMO_WIDTH + GAP_BETWEEN_AMMO)* new_max_ammo_count + BORDER_WIDTH - 1
	for childs in $MarginContainer/HBoxContainer.get_children():
		childs.queue_free()
	
	var ammo_template := $AmmoTemplate
	for i in new_ammo_count:
		var new_ammo := ammo_template.duplicate()
		new_ammo.show()
		$MarginContainer/HBoxContainer.add_child(new_ammo)


func _on_rotation_origin_ammo_count_changed(new_ammo_count: Variant, new_max_ammo_count: Variant) -> void:
	update(new_ammo_count, new_max_ammo_count)
