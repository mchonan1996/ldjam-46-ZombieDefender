extends Node

var in_shop: bool = false
var current_wave: int = 0
var current_wave_zombie_cnt: int = 0
var current_wave_zombie_killed: int = 0

var money: int = 5000

var has_pistol = false # purely cosmetic, no verification
var has_shotgun = false
var has_rocket = false

var pistol_ammo: int = -1 # not used
var shotgun_ammo: int = 20
var rocket_ammo: int = 5

func reset():
	has_pistol = false
	has_shotgun = false
	has_rocket = false

	in_shop = false
	pistol_ammo = -1
	shotgun_ammo = 20
	rocket_ammo = 5
	current_wave = 0
	current_wave_zombie_cnt = 0
	current_wave_zombie_killed = 0
