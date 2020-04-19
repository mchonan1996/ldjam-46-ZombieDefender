extends Node

var in_shop: bool = false
var current_wave: int = 0
var current_wave_zombie_cnt: int = 0
var current_wave_zombie_killed: int = 0

var money: int = 50000

var has_pistol = false # purely cosmetic, no verification
var has_shotgun = false
var has_rocket = false

var pistol_ammo: int = -1 # not used
var shotgun_ammo: int = 20
var rocket_ammo: int = 5
