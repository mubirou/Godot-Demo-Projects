# Main.gd (Last update : 2024-08-14T21:54)
extends Node3D

var _car: Node3D
var _current_direction = Vector2.ZERO # 現在の移動方向（コントローラー入力に基づく）
var _is_reverse = false # 後退モードかどうかのフラグ
var _current_angle = 0.0 # 現在の車両の向き（度数法）
var _target_angle = 0.0 # 目標とする車両の向き（度数法）
var _smooth_factor = 0.1 # 現在の角度を目標角度に近づける際の補間係数
var _max_speed = 10.0 # 車両の最大速度
var _current_speed = 0.0 # 車両の現在の速度
var _target_speed = 0.0 # 目標とする速度
var _speed_up_rate = 10.0 # 加速率（大きいと急加速）
var _slow_down_rate = 20.0 # 減速率（大きいと急減速）
var _last_move_direction = 1  # 1 for forward, -1 for reverse


# 初期化処理を行うメソッド
func _ready() -> void:
	Debug.print("Hello VR World")
	Debug.print("前進：右スティック")
	Debug.print("後退：中指トリガー＋右スティック")
	_car = $Car
	_set_camera_position()


# フレームごとの更新処理を行うメソッド
func _process(delta: float) -> void:
	_current_angle += (_target_angle - _current_angle) * _smooth_factor
	
	# 速度の更新
	var speed_diff = _target_speed - abs(_current_speed)
	var speed_change = 0.0
	
	if abs(speed_diff) > 0.01:
		if speed_diff > 0:
			# 加速
			speed_change = min(speed_diff, _speed_up_rate * delta)
		else:
			# 減速
			speed_change = max(speed_diff, -_slow_down_rate * delta)
		
		_current_speed += speed_change * sign(_current_speed) if _current_speed != 0 else speed_change * _last_move_direction
	else:
		_current_speed = _target_speed * _last_move_direction

	# 進行方向の決定
	var move_direction = -1 if _is_reverse else 1
	
	if sign(_current_speed) != move_direction and _current_speed != 0:
		# 進行方向が変わる場合、現在の速度を徐々に0に近づける
		_current_speed = move_toward(_current_speed, 0, _slow_down_rate * delta)
	else:
		_last_move_direction = move_direction

	if _current_direction != Vector2.ZERO or _current_speed != 0:
		# ステアリング角度の計算
		var steering_angle = deg_to_rad(_current_angle * -45)
		if _is_reverse:
			steering_angle = -steering_angle  # バック時はステアリングを反転
		
		# 車の回転を更新
		_car.rotate_y(steering_angle * delta)
		
		# 前進方向と速度の計算
		var forward_speed = _current_speed
		var forward_vector = -_car.global_transform.basis.z * forward_speed * delta
		
		# 車を移動
		_car.global_translate(forward_vector)
		
		_set_camera_position()
	else:
		# 入力がなく、速度もゼロの場合は何もしない
		pass


# 右コントローラーのボタンが押されたときの処理を行う
func _on_right_controller_button_pressed(name: String) -> void:
	if name == "grip_click":
		_is_reverse = true
		Debug.print("後退")


# 右コントローラーのボタンが離されたときの処理を行う
func _on_right_controller_button_released(name):
	if name == "grip_click":
		_is_reverse = false
		Debug.print("前進")


# 右コントローラーの2次元入力（Vector2）が変化したときの処理を行う
func _on_right_controller_input_vector_2_changed(name: String, value: Vector2) -> void:
	if value.length() < 0.1:
		_target_angle = 0.0
		_current_direction = Vector2.ZERO
		_target_speed = 0.0  # 入力がない場合は停止を目指す
	else:
		_target_angle = value.x
		_current_direction = value
		_target_speed = _max_speed * value.length()  # スティックの傾きに応じて目標速度を設定


# カメラの位置を設定する処理を行う
func _set_camera_position() -> void:
	var car_transform = _car.global_transform
	# カメラの位置の微調整
	var camera_position = car_transform.origin + Vector3(0, -0.7, 0) + car_transform.basis.z * 4.0
	var xrorigin_pos = $XROrigin3D.transform
	xrorigin_pos.origin = camera_position
	$XROrigin3D.transform = xrorigin_pos
	$XROrigin3D.global_rotation = _car.global_rotation
