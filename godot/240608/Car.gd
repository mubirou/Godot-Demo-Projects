# Car.gd
extends Node3D

var _speed = 1.5  # 車の移動速度
var _floor_size = 6.0  # 6m x 6mの床
var _car_radius = 0.15  # 車の全長 / 2
var _floor: Node3D  # 床のノード

func _ready() -> void:
	_floor = get_parent().get_node("Floor")  # 床のノードを取得

func move(x: float, z: float) -> void:
	# 現在の位置を取得して移動量を追加
	var new_x = position.x + (x * _speed)
	var new_z = position.z + (z * _speed)

	# 床の境界計算（グローバル座標）
	var half_floor_size = _floor_size / 2.0
	var floor_global_pos = _floor.global_transform.origin

	var min_x = floor_global_pos.x - half_floor_size + _car_radius
	var max_x = floor_global_pos.x + half_floor_size - _car_radius
	var min_z = floor_global_pos.z - half_floor_size + _car_radius
	var max_z = floor_global_pos.z + half_floor_size - _car_radius

	# 移動後の位置が床の範囲内か確認
	if new_x < min_x or new_x > max_x or new_z < min_z or new_z > max_z:
		# 範囲外なら何もしない
		return

	# 車の向きを変更
	var direction = Vector3(x, 0, z).normalized()
	# atan2を使用して方向に応じた回転を計算し、90度回転させる
	rotation = Vector3(0, atan2(direction.x, direction.z) - PI / 2, 0)

	# 新しい位置を設定
	position.x = new_x
	position.z = new_z
