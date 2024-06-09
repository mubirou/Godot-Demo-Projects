# Main.gd
extends Node3D

var _webxr_manager: WebXRManager
var _debugger: Label3D  # Debugger
var _car: Node3D

var _current_direction = Vector2.ZERO

func _ready() -> void:
	_webxr_manager = WebXRManager.new(self)
	
	# Debugger
	_debugger = $XROrigin3D/RightController/Debugger
	_debugger.print("Hello World")
	
	_car = $Car

func _process(delta: float) -> void:
	if _current_direction != Vector2.ZERO:
		# 車を動かす
		_car.move(_current_direction.x * delta, -_current_direction.y * delta)

func _on_right_controller_button_pressed(name: String) -> void:
	# _debugger.reset()  # Debugger（出力をクリア）
	pass

func _on_right_controller_input_vector_2_changed(name: String, value: Vector2) -> void:
	# 中央に戻っているかを確認
	if value.length() == 0:
		_debugger.print("・")
		_current_direction = Vector2.ZERO
		return

	# 方向を判断
	_current_direction = value

	_debugger.print("方向: " + str(value))
