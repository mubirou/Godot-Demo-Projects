# Car.gd
extends Node3D

var _floor_size = 6.0
var _car_radius = 0.15
var _floor: Node3D


# 初期化処理を行うメソッド
func _ready() -> void:
	_floor = get_parent().get_node("Floor")


# フレームごとの更新処理を行うメソッド
func _process(delta: float) -> void:
	var half_floor_size = _floor_size / 2.0
	var floor_global_pos = _floor.global_transform.origin

	var min_x = floor_global_pos.x - half_floor_size + _car_radius
	var max_x = floor_global_pos.x + half_floor_size - _car_radius
	var min_z = floor_global_pos.z - half_floor_size + _car_radius
	var max_z = floor_global_pos.z + half_floor_size - _car_radius

	# if文を使わずにclamp()で合理化
	global_transform.origin.x = clamp(global_transform.origin.x, min_x, max_x)
	global_transform.origin.z = clamp(global_transform.origin.z, min_z, max_z)
