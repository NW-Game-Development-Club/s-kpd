extends Node

@export var maxHealth: int
@onready var currentHealth: int = maxHealth

func applyDamage(damage):
	currentHealth -= damage
	if currentHealth <= 0:
		# Do death logic
		print(str(self.name)+" died")
