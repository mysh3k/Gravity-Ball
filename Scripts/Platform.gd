extends StaticBody2D

@export var x: int = 1
@export var y: int = 1

func _ready():
	update_mesh_size()

func update_mesh_size():
	var collision_shape = $CollisionShape2D
	var mesh_instance = $CollisionShape2D/MeshInstance2D
	collision_shape.scale = Vector2(x, y)

	if collision_shape and mesh_instance:
		var shape = collision_shape.shape

		# Check if the shape is a RectangleShape2D
		if shape is RectangleShape2D:
			var size = shape.extents * 2
			mesh_instance.scale = size
