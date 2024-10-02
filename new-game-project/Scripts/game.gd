extends Node3D

@onready var player = $Player
@onready var zombie = $Zombie
@onready var zombie2 = $Zombie2
@onready var zombie3 = $Zombie3
@onready var zombie4 = $Zombie4

func _ready():
	zombie.set_player(player)
	zombie2.set_player(player)
	zombie3.set_player(player)
	zombie4.set_player(player)
