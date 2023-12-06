extends CharacterBody2D

@export var rotation_speed: float = 7.5
@export var gravity: float = 200
@export var max_velocity: float = 500  # The maximum velocity
@export var bounce_cooldown: float = 0.75  # Time in seconds to allow next bounce
@export var max_health: float = 100
@export var health: float = max_health
@onready var speedbar = $SpeedBar

var bounce_factor: float = 0.5  # Adjust this for more/less bounce
var time_since_last_collision = 0.0  # Timer variable

func health_manager(amount: float):
	var healthbar = $HealthBar
	# Heal & damage logic
	health = min(health + amount, max_health)
	# Player death
	if health <= 0:
		queue_free()
	healthbar.value = health

func speedbar_manager():
	# Shows our current speed (in % atm) changes color to blood red if we can take collision damage
	var speed = velocity.length()
	speedbar.value = speed
	if speed < 300:
		speedbar.modulate = '#bd262a75'
	elif speed > 300:
		speedbar.modulate = '#f70000'

func collision_damage(collision):
	var impact_speed = velocity.length()
	# Calculating fall/collision damage based on your velocity and collision angle
	if impact_speed > 300:
		var collision_angle = acos(velocity.normalized().dot(collision.get_normal()))
		var angle_factor = abs(cos(collision_angle))  # More damage on head-on collision
		var damage = (impact_speed / 30) * angle_factor
		print(damage)
		health_manager(-damage)

func _physics_process(delta):
	# Get rotation direction from input
	var direction = Input.get_axis("rotate_left", "rotate_right")

	# Rotate the character
	rotation += rotation_speed * direction * delta # Rotate camera based on direction Input
	rotation = fmod(rotation + PI, 2 * PI) - PI # No idea what's that I think it doesn't change anything

	# Calculate the gravity direction based on the player/camera rotation
	var gravity_dir = Vector2(-sin(rotation), cos(rotation))

	# Calculate the gravity vector
	var gravity_vector = gravity_dir * gravity

	# Apply gravity vector to the character's velocity
	velocity += gravity_vector * delta
	
	if get_slide_collision_count() == 0:
		time_since_last_collision += delta  # Increment timer
	
	# If no collision detected for > bounce cooldown change player motion to floating
	if time_since_last_collision > bounce_cooldown:
		motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	else:
		motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED

	# Check for collisions
	if get_slide_collision_count() > 0:
		var collision = get_slide_collision(0)
		if collision != null and time_since_last_collision > bounce_cooldown:# and velocity.length() > 5:
			collision_damage(collision)
			print("Pre-bounce velocity: ", velocity)
			print("Collision normal: ", collision.get_normal())
			velocity = velocity.bounce(collision.get_normal()) * bounce_factor
			print("Post-bounce velocity: ", velocity)
		time_since_last_collision = 0.0
		print(motion_mode)
		
	# Cap the velocity after applying gravity
	if velocity.length() > max_velocity:
		velocity = velocity.normalized() * max_velocity
		
	move_and_slide()
	speedbar_manager()
