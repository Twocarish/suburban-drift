extends Node3D

func _ready():
	print($WorldEnvironment.environment.sky.sky_material.sky_energy_multiplier)

# NOTE : the above property can be changed to simulate different depths
