# res://gd/WebXRStartup.gd
# 注意:
# このスクリプトは「Autoload」としてのみ使用することを意図しています。
# いかなるノードにもアタッチしないでください。
extends Node

# 定数とプロパティ
var _webxr_interface
var _canvaslayer
var _canvaslayer_button


# 初期化メソッド
func _ready() -> void:
	_canvaslayer = get_tree().root.get_node("Main/CanvasLayer")
	_canvaslayer_button = _canvaslayer.get_node("Button")
	_canvaslayer.visible = false
	_canvaslayer_button.pressed.connect(self._on_button_pressed)
	_webxr_interface = XRServer.find_interface("WebXR")
	if _webxr_interface:
		_webxr_interface.session_supported.connect(self._webxr_session_supported)
		_webxr_interface.session_started.connect(self._webxr_session_started)
		_webxr_interface.session_ended.connect(self._webxr_session_ended)
		_webxr_interface.session_failed.connect(self._webxr_session_failed)
		#_webxr_interface.select.connect(self._webxr_on_select)
		#_webxr_interface.selectstart.connect(self._webxr_on_select_start)
		#_webxr_interface.selectend.connect(self._webxr_on_select_end)
		#_webxr_interface.squeeze.connect(self._webxr_on_squeeze)
		#_webxr_interface.squeezestart.connect(self._webxr_on_squeeze_start)
		#_webxr_interface.squeezeend.connect(self._webxr_on_squeeze_end)
		_webxr_interface.is_session_supported("immersive-vr")


# [Enter VR] ボタンが押されたときのイベントハンドラ
func _on_button_pressed() -> void:
	_webxr_interface.session_mode = "immersive-vr"
	_webxr_interface.requested_reference_space_types = "bounded-floor, local-floor, local"
	_webxr_interface.required_features = "local-floor"
	_webxr_interface.optional_features = "bounded-floor"
	if not _webxr_interface.initialize():
		Debug.error("Failed to initialize WebXR")
		#print("Failed to initialize WebXR")
		return


# WebXRセッションのサポート状況を確認するイベントハンドラ
func _webxr_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode == "immersive-vr":
		if supported:
			_canvaslayer.visible = true
		else:
			Debug.error("Your browser doesn't support VR")
			#print("Your browser doesn't support VR")


# WebXRセッションが開始されたときのイベントハンドラ
func _webxr_session_started() -> void:
	_canvaslayer.visible = false
	get_viewport().use_xr = true
	#Debug.error("Reference space type: " + _webxr_interface.reference_space_type)
	#print("Reference space type: " + _webxr_interface.reference_space_type)


# WebXRセッションが終了したときのイベントハンドラ
func _webxr_session_ended() -> void:
	_canvaslayer.visible = true
	get_viewport().use_xr = false


# WebXRセッションの初期化が失敗したときのイベントハンドラ
func _webxr_session_failed(message: String) -> void:
	Debug.error("Failed to initialize: " + message)
	#print("Failed to initialize: " + message)


# Godotのシグナル用メソッド
#func _webxr_on_select(input_source_id: int) -> void:
	#var tracker: XRPositionalTracker = _webxr_interface.get_input_source_tracker(input_source_id)
	#var xform = tracker.get_pose("default").transform
	#Debug.#print("Selected position: " + str(xform.origin))
	#print("Selected position: " + str(xform.origin))
	#pass


func _webxr_on_select_start(input_source_id: int) -> void:
	Debug.print("Select Start: " + str(input_source_id))
	print("Select Start: " + str(input_source_id))
	pass


func _webxr_on_select_end(input_source_id: int) -> void:
	Debug.print("Select End: " + str(input_source_id))
	print("Select End: " + str(input_source_id))
	pass


#func _webxr_on_squeeze(input_source_id: int) -> void:
	#Debug.print("Squeeze: " + str(input_source_id))
	#pass


#func _webxr_on_squeeze_start(input_source_id: int) -> void:
	#Debug.print("Squeeze Start: " + str(input_source_id))
	#pass


#func _webxr_on_squeeze_end(input_source_id: int) -> void:
	#Debug.print("Squeeze End: " + str(input_source_id))
	#pass
