extends RigidBody2D

@export var rotation_speed: float = 7.5
@export var gravity: float = 10
@export var max_velocity: float = 100  # The maximum velocity
@export var bounce_cooldown: float = 0.4  # Time in seconds to allow next bounce

var bounce_factor: float = 0.3  # Adjust this for more/less bounce
var time_since_last_collision = 0.0  # Timer variable

var velocity = Vector2.ZERO

func _physics_process(delta):
	# Get rotation direction from input
	var direction = Input.get_axis("rotate_left", "rotate_right")

	# Rotate the character
	rotation += rotation_speed * direction * delta # Rotate camera based on direction Input
	rotation = fmod(rotation + PI, 2 * PI) - PI # No idea what's that

	# Calculate the gravity direction based on the rotation
	var gravity_dir = Vector2(-sin(rotation), cos(rotation))

	# Calculate the gravity vector
	var gravity_vector = gravity_dir * gravity

	# Apply gravity to the character's velocity
	velocity += gravity_vector * delta

	# Check for collisions
	if body_entered:
		print('test')
		var collision = null
		if collision != null and time_since_last_collision > bounce_cooldown:# and velocity.length() > 5:
			# Bounce
			print("Pre-bounce velocity: ", velocity)
			print("Collision normal: ", collision.get_normal())
			#Somehow works
			#velocity = velocity * collision.get_normal() * bounce_factor
			#This should work but doesn't
			#velocity = velocity.bounce(collision.get_normal() * bounce_factor)
			# Math xD
			# R = V - 2 * dot(V, N) * N
			velocity = (velocity - 2 * (velocity * collision.get_normal()) * collision.get_normal()) * bounce_factor
			print("Post-bounce velocity: ", velocity)
		time_since_last_collision = 0.0  # Reset timer on collision
		
	# Cap the velocity after applying gravity
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
		
	move_and_collide(velocity)
	time_since_last_collision += delta  # Increment timer
