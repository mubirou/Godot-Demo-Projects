# main.gd
extends Node3D

var _interface:XRInterface

func _ready():
	_interface = XRServer.find_interface("OpenXR")
	if _interface and _interface.is_initialized():
		var _viewport:Viewport = get_viewport()
		_viewport.use_xr = true
